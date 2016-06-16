//
//  eLongGeographySelectTableView.h
//  ElongClient
//
//  Created by chenggong on 15/9/10.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongGeographySelectModel.h"
#import "eLongGeographySelectDataSourceModel.h"
#import "eLongGeographyTableViewDataSource.h"
#import "eLongGeographyTableViewDelegate.h"
#import "eLongGeographySelectTableViewHotCell.h"
#import "eLongGeographySelectTableViewHistoryCell.h"

@interface eLongGeographySelectTableView : UITableView

// DataSource properties
@property (nonatomic, copy) UITableViewNumberOfSectionsInTableViewBlock numberOfSectionsInTableView;
@property (nonatomic, copy) UITableViewSectionIndexTitlesForTableViewBlock sectionIndexTitlesForTableView;
@property (nonatomic, copy) UITableViewCellForRowAtIndexPathBlock cellForRowAtIndexPath;
@property (nonatomic, copy) UITableViewNumberOfRowsInSectionBlock numberOfRowsInSection;
@property (nonatomic, copy) UITableViewSectionForSectionIndexTitleBlock sectionForSectionIndexTitle;
@property (nonatomic, copy) UITableViewTitleForFooterInSectionBlock titleForFooterInSection;
@property (nonatomic, copy) UITableViewTitleForHeaderInSectionBlock titleForHeaderInSection;

// Delegate properties
@property (nonatomic, copy) UITableViewDidSelectRowAtIndexPathBlock didSelectRowAtIndexPath;
@property (nonatomic, copy) UITableViewHeightForFooterInSectionBlock heightForFooterInSection;
@property (nonatomic, copy) UITableViewHeightForHeaderInSectionBlock heightForHeaderInSection;
@property (nonatomic, copy) UITableViewHeightForRowAtIndexPathBlock heightForRowAtIndexPath;
@property (nonatomic, copy) UITableViewViewForFooterInSectionBlock viewForFooterInSection;
@property (nonatomic, copy) UITableViewViewForHeaderInSectionBlock viewForHeaderInSection;

// Hot click block.
@property (nonatomic, copy) GeographySelectHotClickBlock geographySelectHotClick;
// History click block.
@property (nonatomic, copy) GeographySelectHistoryClickBlock geographySelectHistoryClick;

- (instancetype)initWithFrame:(CGRect)frame withGeographySelectModel:(eLongGeographySelectModel *)model withGeographySelectDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel;

@end
