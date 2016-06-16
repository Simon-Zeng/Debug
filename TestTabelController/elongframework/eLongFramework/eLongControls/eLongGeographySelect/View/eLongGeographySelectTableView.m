//
//  eLongGeographySelectTableView.m
//  ElongClient
//
//  Created by chenggong on 15/9/10.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongGeographySelectTableView.h"
#import "eLongGeographySelectTableViewDataSource.h"
#import "eLongGeographySelectTableViewDelegate.h"

@interface eLongGeographySelectTableView()

@property (nonatomic, strong) eLongGeographySelectTableViewDataSource *selectTableViewDataSource;
@property (nonatomic, strong) eLongGeographySelectTableViewDelegate *selectTableViewDelegate;
@property (nonatomic, strong) eLongGeographySelectModel *geographySelectModel;
@property (nonatomic, strong) eLongGeographySelectDataSourceModel *geographySelectDataSourceModel;

@end

@implementation eLongGeographySelectTableView

//
- (void)setNumberOfSectionsInTableView:(UITableViewNumberOfSectionsInTableViewBlock)numberOfSectionsInTableViewBlock {
    _selectTableViewDataSource.numberOfSectionsInTableView = [numberOfSectionsInTableViewBlock copy];
}

- (void)setSectionIndexTitlesForTableView:(UITableViewSectionIndexTitlesForTableViewBlock)sectionIndexTitlesForTableViewBlock {
    _selectTableViewDataSource.sectionIndexTitlesForTableView = [sectionIndexTitlesForTableViewBlock copy];
}

- (void)setCellForRowAtIndexPath:(UITableViewCellForRowAtIndexPathBlock)cellForRowAtIndexPathBlock {
    _selectTableViewDataSource.cellForRowAtIndexPath = [cellForRowAtIndexPathBlock copy];
}

- (void)setNumberOfRowsInSection:(UITableViewNumberOfRowsInSectionBlock)numberOfRowsInSectionBlock {
    _selectTableViewDataSource.numberOfRowsInSection = [numberOfRowsInSectionBlock copy];
}

- (void)setSectionForSectionIndexTitle:(UITableViewSectionForSectionIndexTitleBlock)sectionForSectionIndexTitleBlock {
    _selectTableViewDataSource.sectionForSectionIndexTitle = [sectionForSectionIndexTitleBlock copy];
}

- (void)setTitleForFooterInSection:(UITableViewTitleForFooterInSectionBlock)titleForFooterInSectionBlock {
    _selectTableViewDataSource.titleForFooterInSection = [titleForFooterInSectionBlock copy];
}

- (void)setTitleForHeaderInSection:(UITableViewTitleForHeaderInSectionBlock)titleForHeaderInSectionBlock {
    _selectTableViewDataSource.titleForHeaderInSection = [titleForHeaderInSectionBlock copy];
}

// Delegate
- (void)setHeightForHeaderInSection:(UITableViewHeightForHeaderInSectionBlock)heightForHeaderInSectionBlock {
    _selectTableViewDelegate.heightForHeaderInSection = [heightForHeaderInSectionBlock copy];
}

- (void)setHeightForRowAtIndexPath:(UITableViewHeightForRowAtIndexPathBlock)heightForRowAtIndexPathBlock {
    _selectTableViewDelegate.heightForRowAtIndexPath = [heightForRowAtIndexPathBlock copy];
}

- (void)setViewForHeaderInSection:(UITableViewViewForHeaderInSectionBlock)viewForHeaderInSectionBlock {
    _selectTableViewDelegate.viewForHeaderInSection = [viewForHeaderInSectionBlock copy];
}

- (void)setDidSelectRowAtIndexPath:(UITableViewDidSelectRowAtIndexPathBlock)didSelectRowAtIndexPathBlock {
    _selectTableViewDelegate.didSelectRowAtIndexPath = [didSelectRowAtIndexPathBlock copy];
}

- (void)setGeographySelectHotClick:(GeographySelectHotClickBlock)geographySelectHotClickBlock {
    _selectTableViewDataSource.geographySelectHotClick = [geographySelectHotClickBlock copy];
}

- (void)setGeographySelectHistoryClick:(GeographySelectHistoryClickBlock)geographySelectHistoryClickBlock {
    _selectTableViewDataSource.geographySelectHistoryClick = [geographySelectHistoryClickBlock copy];
}

- (instancetype)initWithFrame:(CGRect)frame withGeographySelectModel:(eLongGeographySelectModel *)model withGeographySelectDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel{
    if (self = [super initWithFrame:frame]) {
        self.geographySelectModel = model;
        self.geographySelectDataSourceModel = dataSourceModel;
        
        self.selectTableViewDataSource = [[eLongGeographySelectTableViewDataSource alloc] initWithSelectModel:_geographySelectModel withDataSourceModel:_geographySelectDataSourceModel];
        
        self.selectTableViewDelegate = [[eLongGeographySelectTableViewDelegate alloc] initWithSelectModel:_geographySelectModel withDataSourceModel:_geographySelectDataSourceModel];
        
        self.dataSource = _selectTableViewDataSource;
        self.delegate = _selectTableViewDelegate;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        if (IOSVersion_7) {
            self.sectionIndexBackgroundColor = [UIColor clearColor];
//        }
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
