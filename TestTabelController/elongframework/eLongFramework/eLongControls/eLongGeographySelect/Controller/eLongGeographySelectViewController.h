//
//  eLongGeographySelectViewController.h
//  ElongClient
//
//  Created by chenggong on 15/9/8.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "eLongGeographySelectModel.h"
#import "eLongGeographyTableViewDataSource.h"
#import "eLongGeographyTableViewDelegate.h"
#import "eLongGeographySelectDataSourceModel.h"
#import "eLongGeographySelectDetailSuggestionResponseModel.h"
#import "eLongGeographySelectSearchResults.h"
#import "eLongGeographySelectTableViewHotCell.h"
#import "eLongGeographySelectTableViewHistoryCell.h"

typedef void (^GeographySelectSuggestionSearchBusinessBlock)(NSString *suggestionSearchWord);

@interface eLongGeographySelectViewController : ElongBaseViewController

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

// Suggestion Search
@property (nonatomic, copy) GeographySelectSuggestionSearchBusinessBlock geographySelectSuggestionSearchBusiness;

// Select geography tableview didSelect.
@property (nonatomic, copy) SearchResultDidSelectRowAtIndexPathBlock suggestionSearchDidSelectBlock;
@property (nonatomic, copy) UITableViewCellForRowAtIndexPathBlock suggestionSearchCellForRowAtIndexPathBlock;

@property (nonatomic, strong) eLongGeographySelectDataSourceModel *geographySelectDataSourceModel;

// Hot click block.
@property (nonatomic, copy) GeographySelectHotClickBlock geographySelectHotClick;
// History click block.
@property (nonatomic, copy) GeographySelectHistoryClickBlock geographySelectHistoryClick;

- (instancetype)initWithModel:(eLongGeographySelectModel *)model withDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel;
- (void)doneWithSuggestionSearch:(eLongGeographySelectDetailSuggestionResponseModel *)suggestionResponseModel;
- (UIView *)geographySelectView;
- (void)reloadView;
- (void)hideNavgationBar;
@end
