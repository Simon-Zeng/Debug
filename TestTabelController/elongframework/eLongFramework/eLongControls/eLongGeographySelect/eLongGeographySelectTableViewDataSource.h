//
//  eLongGeographySelectTableViewDataSource.h
//  ElongClient
//
//  Created by chenggong on 15/9/10.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongGeographySelectModel.h"
#import "eLongGeographySelectDataSourceModel.h"
#import "eLongGeographyTableViewDataSource.h"
#import "eLongGeographySelectTableViewHotCell.h"
#import "eLongGeographySelectTableViewHistoryCell.h"

@interface eLongGeographySelectTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy) UITableViewNumberOfSectionsInTableViewBlock numberOfSectionsInTableView;
@property (nonatomic, copy) UITableViewSectionIndexTitlesForTableViewBlock sectionIndexTitlesForTableView;
@property (nonatomic, copy) UITableViewCellForRowAtIndexPathBlock cellForRowAtIndexPath;
@property (nonatomic, copy) UITableViewNumberOfRowsInSectionBlock numberOfRowsInSection;
@property (nonatomic, copy) UITableViewSectionForSectionIndexTitleBlock sectionForSectionIndexTitle;
@property (nonatomic, copy) UITableViewTitleForFooterInSectionBlock titleForFooterInSection;
@property (nonatomic, copy) UITableViewTitleForHeaderInSectionBlock titleForHeaderInSection;
@property (nonatomic, copy) GeographySelectHotClickBlock geographySelectHotClick;
@property (nonatomic, copy) GeographySelectHistoryClickBlock geographySelectHistoryClick;

- (instancetype)initWithSelectModel:(eLongGeographySelectModel *)selectModel withDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel;

@end
