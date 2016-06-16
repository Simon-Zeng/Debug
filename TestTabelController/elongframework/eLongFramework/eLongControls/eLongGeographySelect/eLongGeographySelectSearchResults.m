//
//  eLongGeographySelectSearchResults.m
//  Pods
//
//  Created by chenggong on 15/9/29.
//
//

#import "eLongGeographySelectSearchResults.h"
#import "eLongGeographySelectTableViewCell.h"
#import "eLongGeographySelectDetailModel.h"
#import "NSString+eLongExtension.h"
#import "eLongGeographyCountlyEventDefine.h"

@interface eLongGeographySelectSearchResults()

@property (nonatomic, strong) NSMutableArray *suggestionSearchList;
@property (nonatomic, strong) eLongGeographySelectModel *selectModel;
@property (nonatomic, strong) eLongGeographySelectDataSourceModel *dataSourceModel;

@end

@implementation eLongGeographySelectSearchResults

- (instancetype)initWithGeographySelectModel:(eLongGeographySelectModel *)selectModel  withDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel{
    if (self = [super init]) {
        self.selectModel = selectModel;
        self.dataSourceModel = dataSourceModel;
        self.suggestionSearchList = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (void)updateSearchList:(NSArray *)searchList {
    if (!_suggestionSearchList) {
        self.suggestionSearchList = [NSMutableArray arrayWithCapacity:0];
    }
    
    if (searchList && [searchList isKindOfClass:[NSArray class]]) {
        [self.suggestionSearchList setArray:searchList];
    }
}

- (NSMutableArray *)searchSuggestionKeyWordFromLocal:(NSString *)suggestionKeyWord {
    //    NSMutableArray *suggestionSearchString = [NSMutableArray new];
    [_suggestionSearchList removeAllObjects];
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", suggestionKeyWord];
    
    for (NSArray *array in _dataSourceModel.geographySelectSections)
    {
        for (NSArray *geography in array)
        {
            if ([[geography objectAtIndex:0] isKindOfClass:[NSArray class]]) {
                continue;
            }
            
            NSArray *filterArray = [NSMutableArray arrayWithArray:[geography filteredArrayUsingPredicate:preicate]];
            
            if (ARRAYHASVALUE(filterArray)) {
                eLongGeographySelectDetailModel *geographySelectDetailModel = [[eLongGeographySelectDetailModel alloc] init];
                geographySelectDetailModel.cityName = [geography objectAtIndex:0];
                geographySelectDetailModel.cityPy = [geography objectAtIndex:1];
                geographySelectDetailModel.cityNum = [geography objectAtIndex:2];
                geographySelectDetailModel.composedName = [geography objectAtIndex:0];
                [self.suggestionSearchList addObject:geographySelectDetailModel];
            }
        }
    }
    //过滤数据
    //    self.suggestionSearchList= [NSMutableArray arrayWithArray:[_dataSourceModel.sections filteredArrayUsingPredicate:preicate]];
    
    return _suggestionSearchList;
}

#pragma mark -
#pragma mark UITableView DataSource & Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果使用者自定义了UITableViewCellForRowAtIndexPathBlock，那么使用自定义的UITableViewDelegate处理方法
    if (_cellForRowAtIndexPath) {
        return self.cellForRowAtIndexPath(tableView, indexPath);
    }
    
    static NSString *eLongGeographySelectTableViewCellIdentifier = @"eLongGeographySelectTableViewCell";
    NSInteger row = [indexPath row];
    
    [tableView registerClass:[eLongGeographySelectTableViewCell class] forCellReuseIdentifier:eLongGeographySelectTableViewCellIdentifier];
    eLongGeographySelectTableViewCell *geographySelectTableViewCell = [tableView dequeueReusableCellWithIdentifier:eLongGeographySelectTableViewCellIdentifier forIndexPath:indexPath];
    geographySelectTableViewCell.showCityType = YES;
    
    NSString *geography = nil;
    id geographyDetail = [self.suggestionSearchList objectAtIndex:row];
    if ([geographyDetail isKindOfClass:[eLongGeographySelectDetailModel class]]) {
        eLongGeographySelectDetailModel *geographyDetailModel = ((eLongGeographySelectDetailModel *)geographyDetail);
        NSString *composedName = geographyDetailModel.composedName;
        if ([composedName notEmpty]) {
            geography = [composedName stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        }
        geographySelectTableViewCell.cityTypeLabel.text = geographyDetailModel.country;
    }
    geographySelectTableViewCell.cityLabel.text= geography;
    
    return geographySelectTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.suggestionSearchList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (STRINGHASVALUE(_selectModel.eLongCountlyGeographySuggestionPageName)) {
        eLongCountlyEventClick *countlyEventClick = [[eLongCountlyEventClick alloc] init];
        countlyEventClick.page = _selectModel.eLongCountlyGeographySuggestionPageName;
        countlyEventClick.clickSpot = COUNTLY_PAGE_DESTINATION_SUG_SELECT;
        [countlyEventClick sendEventCount:1];
    }
    
    if (_suggestionSearchDidSelectBlock) {
        self.suggestionSearchDidSelectBlock(tableView, indexPath, _suggestionSearchList);
    }
}

@end
