//
//  eLongGeographySelectTableViewDataSource.m
//  ElongClient
//
//  Created by chenggong on 15/9/10.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongGeographySelectTableViewDataSource.h"
#import "eLongGeographySelectTableViewCell.h"
#import "eLongGeographyCountlyEventDefine.h"

@interface eLongGeographySelectTableViewDataSource()

@property (nonatomic, strong) eLongGeographySelectModel *selectModel;
@property (nonatomic, strong) eLongGeographySelectDataSourceModel *dataSourceModel;

@end

@implementation eLongGeographySelectTableViewDataSource

-(NSArray *)historyArray{
    NSString *geographyOfHistoryPersistName = _selectModel.persistanceHistoryName;
    return [[NSUserDefaults standardUserDefaults] objectForKey:geographyOfHistoryPersistName];
}

- (instancetype)initWithSelectModel:(eLongGeographySelectModel *)selectModel withDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel {
    if (self = [super init]) {
        self.selectModel = selectModel;
        self.dataSourceModel = dataSourceModel;
    }
    
    return self;
}

#pragma mark UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_titleForHeaderInSection) {
        return self.titleForHeaderInSection(tableView, section);
    }
    
    NSString *title = [_dataSourceModel.geographySelectSectionIndexTitles objectAtIndex:section];
    if ([title isEqualToString:@"历史"]) {
        return @"搜索历史";
    }else if([title isEqualToString:@"热门"]){
        return @"热门城市";
    }else if([title isEqualToString:@"当前"]){
        return @"当前位置";
    } else {
        return title;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_sectionIndexTitlesForTableView) {
        return self.sectionIndexTitlesForTableView(tableView);
    }
    
    return _dataSourceModel.geographySelectSectionIndexTitles;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_numberOfSectionsInTableView) {
        return self.numberOfSectionsInTableView(tableView);
    }
    
    return [_dataSourceModel.geographySelectSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_numberOfRowsInSection) {
        return self.numberOfRowsInSection(tableView, section);
    }
    
    return [[_dataSourceModel.geographySelectSections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果使用者自定义了UITableViewCellForRowAtIndexPathBlock，那么使用自定义的UITableViewDelegate处理方法
    if (_cellForRowAtIndexPath) {
        return self.cellForRowAtIndexPath(tableView, indexPath);
    }
    
    static NSString *eLongGeographySelectTableViewHistoryCellIdentifier = @"eLongGeographySelectTableViewHistoryCell";
    static NSString *eLongGeographySelectTableViewHotCellIdentifier = @"eLongGeographySelectTableViewHotCell";
    static NSString *eLongGeographySelectTableViewCellIdentifier = @"eLongGeographySelectTableViewCell";
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSArray *geographies = [[_dataSourceModel.geographySelectSections objectAtIndex:section] objectAtIndex:row];
    NSString *sectionKey = [_dataSourceModel.geographySelectSectionIndexTitles objectAtIndex:section];
    
    if ([sectionKey isEqualToString:@"热门"]) {
        [tableView registerClass:[eLongGeographySelectTableViewHotCell class] forCellReuseIdentifier:eLongGeographySelectTableViewHotCellIdentifier];
        eLongGeographySelectTableViewHotCell *geographySelectTableViewHotCell = [tableView dequeueReusableCellWithIdentifier:eLongGeographySelectTableViewHotCellIdentifier forIndexPath:indexPath];
        geographySelectTableViewHotCell.geographies = geographies;
        geographySelectTableViewHotCell.countlyPage = _selectModel.eLongCountlyGeographyPageName;
        geographySelectTableViewHotCell.countlySpot = COUNTLY_PAGE_DESTINATION_HOT;
        geographySelectTableViewHotCell.geographySelectHotClickBlock = ^(eLongGeographySelectDetailModel *geographySelectDetailModel) {
            if (_geographySelectHotClick) {
                self.geographySelectHotClick(geographySelectDetailModel);
            }
        };
        
        return geographySelectTableViewHotCell;
    } else if ([sectionKey isEqualToString:@"历史"]){
        [tableView registerClass:[eLongGeographySelectTableViewHistoryCell class] forCellReuseIdentifier:eLongGeographySelectTableViewHistoryCellIdentifier];
        eLongGeographySelectTableViewHistoryCell *geographySelectTableViewHistoryCell = [tableView dequeueReusableCellWithIdentifier:eLongGeographySelectTableViewHistoryCellIdentifier forIndexPath:indexPath];
        geographySelectTableViewHistoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        geographySelectTableViewHistoryCell.geographies = geographies;
        geographySelectTableViewHistoryCell.countlyPage = _selectModel.eLongCountlyGeographyPageName;
        geographySelectTableViewHistoryCell.countlySpot = COUNTLY_PAGE_DESTINATION_HISTORY;
        geographySelectTableViewHistoryCell.geographySelectHistoryClickBlock = ^(eLongGeographySelectDetailModel *geographySelectDetailModel) {
            if (_geographySelectHistoryClick) {
                self.geographySelectHistoryClick(geographySelectDetailModel);
            }
        };
        
        return geographySelectTableViewHistoryCell;
    }
    
    [tableView registerClass:[eLongGeographySelectTableViewCell class] forCellReuseIdentifier:eLongGeographySelectTableViewCellIdentifier];
    eLongGeographySelectTableViewCell *geographySelectTableViewCell = [tableView dequeueReusableCellWithIdentifier:eLongGeographySelectTableViewCellIdentifier forIndexPath:indexPath];
    geographySelectTableViewCell.showCityType = NO;
    geographySelectTableViewCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    NSString *city = nil;
    
    if (geographies.count > 0) {
        city = [geographies objectAtIndex:0];
    }
    
    if ((section == 0) && (row == 0))
    {
        geographySelectTableViewCell.gpsView.hidden = NO;
    }
    else
    {
        geographySelectTableViewCell.gpsView.hidden = YES;
    }
    
    if ([city isEqualToString:@"当前位置"]) {
        city = _dataSourceModel.currentPositionWithFullAddress;
        
        if (city == nil || [city isEqualToString:@""]) {
            city = @"尚未获取位置信息";
            geographySelectTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    geographySelectTableViewCell.cityLabel.text = city;
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        geographySelectTableViewCell.splitView.hidden = YES;
    }else{
        geographySelectTableViewCell.splitView.hidden = NO;
    }
    return geographySelectTableViewCell;
}

@end
