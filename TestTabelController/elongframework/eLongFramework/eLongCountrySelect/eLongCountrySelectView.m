//
//  eLongCountrySelectView.m
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/24.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongCountrySelectView.h"
#import "eLongDefine.h"
#import "eLongCountrySelectTableViewCell.h"
#import "eLongCountryModel.h"

@interface eLongCountrySelectView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *countryList;

@property (nonatomic, strong) NSMutableArray *indexList;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation eLongCountrySelectView

- (id)initWithFrame:(CGRect)frame countryList:(NSArray *)countryList
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.countryList = [[NSArray alloc] initWithArray:countryList];
        self.indexList = [[NSMutableArray alloc] initWithCapacity:0];
        self.dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [self initData];
        [self initView];
    }
    
    return self;
}

- (void)initData
{
    for (eLongCountryModel *model in self.countryList) {
        
        NSString *sectionName = [model.countryName substringToIndex:1];
        
        if (!STRINGHASVALUE(sectionName)) {
            continue;
        }
        
        //首字母大写，做为分组
        sectionName = [sectionName uppercaseString];
        
        if (![self.indexList containsObject:sectionName]) {
            
            [self.indexList addObject:sectionName];
        }
        
        NSMutableArray *array = [self.dataDict objectForKey:sectionName];
        if (!array) {
            
            array = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        [array addObject:model];
        
        [self.dataDict setObject:array forKey:sectionName];
    }
}

- (void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName = [self.indexList objectAtIndex:section];
    NSArray *array = [self.dataDict objectForKey:sectionName];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eLongCountrySelectTableViewCell *cell = nil;
    static NSString *totalIdentifier = @"countrySelectCell";
    
    cell = (eLongCountrySelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:totalIdentifier];
    
    if (cell == nil)
    {
        cell = [[eLongCountrySelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:totalIdentifier];
    }
    
    NSString *sectionName = [self.indexList objectAtIndex:indexPath.section];
    NSArray *array = [self.dataDict objectForKey:sectionName];
    eLongCountryModel *countryModel = [array objectAtIndex:indexPath.row];
    cell.countryLabel.text = countryModel.countryName;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, self.frame.size.width, 32)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor = [UIColor colorWithHexStr:@"0x444444"];
    titleLabel.font = FONT_13;
    titleLabel.text = [self.indexList objectAtIndex:section];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexList;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(eLongCountrySelectView:didSelectCountry:)]) {
        
        NSString *sectionName = [self.indexList objectAtIndex:indexPath.section];
        NSArray *array = [self.dataDict objectForKey:sectionName];
        eLongCountryModel *countryModel = [array objectAtIndex:indexPath.row];
        
        [_delegate eLongCountrySelectView:self didSelectCountry:countryModel];
    }
}

@end
