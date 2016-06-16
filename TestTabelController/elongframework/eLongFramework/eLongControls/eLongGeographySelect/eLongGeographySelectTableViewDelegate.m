//
//  eLongGeographySelectTableViewDelegate.m
//  Pods
//
//  Created by chenggong on 15/9/22.
//
//

#import "eLongGeographySelectTableViewDelegate.h"
#import "UIImageView+Extension.h"
#import "UIView+LayoutMethods.h"
#import "eLongGeographySelectDetailModel.h"
#import "eLongGeographyCountlyEventDefine.h"

@interface eLongGeographySelectTableViewDelegate()

@property (nonatomic, retain) eLongGeographySelectModel *selectModel;
@property (nonatomic, retain) eLongGeographySelectDataSourceModel *dataSourceModel;

@end

@implementation eLongGeographySelectTableViewDelegate

- (instancetype)initWithSelectModel:(eLongGeographySelectModel *)selectModel withDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel {
    if (self = [super init]) {
        self.selectModel = selectModel;
        self.dataSourceModel = dataSourceModel;
    }
    
    return self;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_heightForHeaderInSection) {
        return self.heightForHeaderInSection(tableView, section);
    }
    
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_heightForRowAtIndexPath) {
        return self.heightForRowAtIndexPath(tableView, indexPath);
    }
    
    NSString *sectionKey = [_dataSourceModel.geographySelectSectionIndexTitles objectAtIndex:indexPath.section];
    if ([sectionKey isEqualToString:@"热门"] ||
        [sectionKey isEqualToString:@"历史"]) {
        
        NSArray *citys = [[_dataSourceModel.geographySelectSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSInteger rows = citys.count / 4;
        rows += (citys.count % 4> 0 ? 1 : 0);
        
        return 40 * rows + (rows > 1 ? 70 : 20);
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_viewForHeaderInSection) {
        return self.viewForHeaderInSection(tableView, section);
    }
    
    UIView* mview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    mview.backgroundColor=[UIColor colorWithHexStr:@"f2f2f2"];
    
    UILabel *headerview=[[UILabel alloc] initWithFrame:CGRectMake(17, 0, 220, 24)];
    headerview.backgroundColor=[UIColor clearColor];
    NSString *title = [_dataSourceModel.geographySelectSectionIndexTitles objectAtIndex:section];
    if ([title isEqualToString:@"历史"]) {
        headerview.text = @"搜索历史";
    }else if([title isEqualToString:@"热门"]){
        headerview.text = @"热门城市";
    }else if([title isEqualToString:@"当前"]){
        headerview.text = @"当前位置";
    }else {
        headerview.text = title;
    }
    
    headerview.font= FONT_B15;
    headerview.textColor =  RGBACOLOR(52, 52, 52, 1);
    headerview.textAlignment = NSTextAlignmentLeft;
    [mview addSubview:headerview];
    if (section != 0) {
        [mview addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)]];
    }
    [mview addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, mview.height - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
    
    return mview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionKey = [_dataSourceModel.geographySelectSectionIndexTitles objectAtIndex:indexPath.section];
    if ([sectionKey isEqualToString:@"热门"] ||
        [sectionKey isEqualToString:@"历史"]) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];//取消选中项
        return;
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSArray *destination = [[_dataSourceModel.geographySelectSections objectAtIndex:section] objectAtIndex:row];
    
    if ([[destination objectAtIndex:0] isEqualToString:@"当前位置"]) {
        [self sendCountlyEventWithClickSpot:COUNTLY_PAGE_DESTINATION_LOCATION];
    }
    
    if (_didSelectRowAtIndexPath) {
        self.didSelectRowAtIndexPath(tableView, indexPath);
    }
}

#pragma mark - Countly Event
- (void)sendCountlyEventWithClickSpot:(NSString *)spot
{
    if (STRINGHASVALUE(_selectModel.eLongCountlyGeographySuggestionPageName)) {
        eLongCountlyEventClick *countlyEventClick = [[eLongCountlyEventClick alloc] init];
        countlyEventClick.page = _selectModel.eLongCountlyGeographyPageName;
        countlyEventClick.clickSpot = spot;
        [countlyEventClick sendEventCount:1];
    }
}

@end
