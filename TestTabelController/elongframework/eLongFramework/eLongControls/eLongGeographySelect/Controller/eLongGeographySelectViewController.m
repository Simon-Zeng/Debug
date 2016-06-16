//
//  eLongGeographySelectViewController.m
//  ElongClient
//
//  Created by chenggong on 15/9/8.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongGeographySelectViewController.h"
#import "eLongGeographySelectTableView.h"
#import <objc/runtime.h>
#import "eLongCountly.h"
#import "eLongGeographyCountlyEventDefine.h"

@interface eLongGeographySelectViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) eLongGeographySelectModel *geographySelectModel;
@property (nonatomic, strong) eLongGeographySelectTableView *geographySelectTableView;

// 搜索
@property (nonatomic, strong) UISearchBar *geographySelectSearchBar;
@property (nonatomic, strong) UISearchDisplayController *geographySelectSearchDisplayController;
@property (nonatomic, strong) eLongGeographySelectSearchResults *geographySelectSearchResults;

@property (nonatomic, strong) UIView *geographySelectContainer;
@property (nonatomic, assign) BOOL isHideNavBar;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation eLongGeographySelectViewController

// Initialiazer
- (instancetype)initWithModel:(eLongGeographySelectModel *)model withDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel{
    if (!model || ![model isKindOfClass:[eLongGeographySelectModel class]]) {
        return nil;
    }
    
    NSString *navBarDisplayName = model.navBarDisplayName;
    NavBarBtnStyle navBarBtnStyle = model.navBarBtnStyle;
    
    if (self = [super initWithTitle:navBarDisplayName style:navBarBtnStyle]) {
        // TODO: Check errors.
        self.geographySelectModel = model;
        
        if (dataSourceModel) {
            self.geographySelectDataSourceModel = dataSourceModel;
        }
        else {
            self.geographySelectDataSourceModel = [[eLongGeographySelectDataSourceModel alloc] initWithGeographySelectModel:_geographySelectModel];
        }
    }
    
    return self;
}

- (void)back {
    [self sendCountlyEventWithClickSpot:COUNTLY_PAGE_DESTINATION_BACK];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadView {
    [self.geographySelectTableView reloadData];
}

- (void)hideNavgationBar {
    self.isHideNavBar = YES;
}

- (UIView *)geographySelectView {
    return _geographySelectContainer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.geographySelectContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.isHideNavBar ? 20 : 0, self.view.bounds.size.width,  self.isHideNavBar ? MAINCONTENTHEIGHT + 44 : MAINCONTENTHEIGHT)];
    [self.view addSubview:_geographySelectContainer];
    // 地理信息列表
    CGFloat tableHeight = self.isHideNavBar ? MAINCONTENTHEIGHT : MAINCONTENTHEIGHT - 44;
    CGRect tableRect = CGRectMake(0, 44, self.view.bounds.size.width, tableHeight);
    
    if (!CGRectEqualToRect(_geographySelectModel.geographySelectViewFrame, CGRectZero)) {
        tableRect = _geographySelectModel.geographySelectViewFrame;
    }
    
    self.geographySelectTableView = [[eLongGeographySelectTableView alloc] initWithFrame:tableRect withGeographySelectModel:_geographySelectModel withGeographySelectDataSourceModel:_geographySelectDataSourceModel];
    // DataSource assign.
    _geographySelectTableView.numberOfSectionsInTableView = _numberOfSectionsInTableView;
    _geographySelectTableView.sectionIndexTitlesForTableView = _sectionIndexTitlesForTableView;
    _geographySelectTableView.cellForRowAtIndexPath = _cellForRowAtIndexPath;
    _geographySelectTableView.numberOfRowsInSection = _numberOfRowsInSection;
    _geographySelectTableView.sectionForSectionIndexTitle = _sectionForSectionIndexTitle;
    _geographySelectTableView.titleForFooterInSection = _titleForFooterInSection;
    _geographySelectTableView.titleForHeaderInSection = _titleForHeaderInSection;
    // Delegate assign.
    _geographySelectTableView.didSelectRowAtIndexPath = _didSelectRowAtIndexPath;
    _geographySelectTableView.heightForFooterInSection = _heightForFooterInSection;
    _geographySelectTableView.heightForHeaderInSection = _heightForHeaderInSection;
    _geographySelectTableView.heightForRowAtIndexPath = _heightForRowAtIndexPath;
    _geographySelectTableView.viewForFooterInSection = _viewForFooterInSection;
    _geographySelectTableView.viewForHeaderInSection = _viewForHeaderInSection;
    // Hot click.
    _geographySelectTableView.geographySelectHotClick = _geographySelectHotClick;
    // History click.
    _geographySelectTableView.geographySelectHistoryClick = _geographySelectHistoryClick;
    
    if (self.isHideNavBar) {
        self.view.backgroundColor = [UIColor whiteColor];
        _geographySelectTableView.backgroundColor = [UIColor colorWithHexStr:@"#f4f4f4"];
    }
    
    [_geographySelectContainer addSubview:_geographySelectTableView];
    
    self.geographySelectSearchResults = [[eLongGeographySelectSearchResults alloc] initWithGeographySelectModel:_geographySelectModel withDataSourceModel:_geographySelectDataSourceModel];
    _geographySelectSearchResults.suggestionSearchDidSelectBlock = _suggestionSearchDidSelectBlock;
    _geographySelectSearchResults.cellForRowAtIndexPath = _suggestionSearchCellForRowAtIndexPathBlock;
    
    self.geographySelectSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:[self createSearchBar] contentsController:self];
    [_geographySelectSearchDisplayController setDelegate:self];
    [_geographySelectSearchDisplayController setSearchResultsDataSource:self.geographySelectSearchResults];
    [_geographySelectSearchDisplayController setSearchResultsDelegate:self.geographySelectSearchResults];
    _geographySelectSearchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _geographySelectSearchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _geographySelectSearchDisplayController.searchBar.placeholder = _geographySelectModel.searchBarPlaceholder;
    
    if (self.isHideNavBar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self createBackBtn];
    }
}

- (void)doneWithSuggestionSearch:(eLongGeographySelectDetailSuggestionResponseModel *)suggestionResponseModel {
    if (suggestionResponseModel && [suggestionResponseModel.suggestCityList count] != 0) {
        [_geographySelectSearchResults updateSearchList:suggestionResponseModel.suggestCityList];
        [_geographySelectSearchDisplayController.searchResultsTableView reloadData];
    }
    else if (!suggestionResponseModel || [suggestionResponseModel.suggestCityList count] == 0) {
        [_geographySelectSearchResults updateSearchList:[_geographySelectSearchResults searchSuggestionKeyWordFromLocal:_geographySelectSearchDisplayController.searchBar.text]];
        [_geographySelectSearchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISearchBar *)createSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 36, 44)];
    searchBar.frame = self.isHideNavBar ? CGRectMake(0, 0, SCREEN_WIDTH - 36, 44) : CGRectMake(0, 0, SCREEN_WIDTH, 44);
    searchBar.backgroundImage = [UIImage new];
    if (self.isHideNavBar) {
        [searchBar setSearchFieldBackgroundImage:[UIImage noCacheImageNamed:@"searchbar_field_bg.png"] forState:UIControlStateNormal];
        
        UITextField *searchField = [searchBar valueForKey:@"searchField"];
        if (searchField) {
            searchField.layer.cornerRadius = 3.0f;
            searchField.layer.masksToBounds = YES;
        }
    }else {
        [searchBar setSearchFieldBackgroundImage:[UIImage noCacheImageNamed:@"IHotelsearchbar_field_bg.png"] forState:UIControlStateNormal];
    }
    [_geographySelectContainer addSubview:searchBar];
    [searchBar setTranslucent:YES];
    searchBar.delegate = self;
    // Set Search Button Title to Done
    for (UIView *searchBarSubview in [searchBar subviews]) {
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            // Before iOS 7.0
            @try {
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
            } @catch (NSException * e) {
                // ignore exception
            }
        } else { // iOS 7.0
            for(UIView *subSubView in [searchBarSubview subviews]) {
                if([subSubView conformsToProtocol:@protocol(UITextInputTraits)]) {
                    @try {
                        [(UITextField *)subSubView setReturnKeyType:UIReturnKeyDone];
                    }
                    @catch (NSException * e) {
                        // ignore exception
                    }
                }
            }
        }
    }
    
    return searchBar;
}

- (void)createBackBtn {
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(SCREEN_WIDTH - 46, 25, 48, 34);
    [self.backBtn setImage:[UIImage imageNamed:@"basevc_navtel_close"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    if (self.isHideNavBar) {
        self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        self.backBtn.hidden = YES;
    }
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self sendCountlyEventWithClickSpot:COUNTLY_PAGE_DESTINATION_SEARCH];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if (_geographySelectSuggestionSearchBusiness) {
        self.geographySelectSuggestionSearchBusiness(searchString);
    }
    
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    if (self.isHideNavBar) {
        self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH - 36, 44);
        self.backBtn.hidden = NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (self.isHideNavBar) {
        [self.searchDisplayController setActive:NO animated:NO];
        [self sendCountlySugEventWithClickSpot:COUNTLY_PAGE_DESTINATION_CANCEL];
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    if (self.isHideNavBar) {
        [self sendCountlySugEventWithClickSpot:COUNTLY_PAGE_DESTINATION_CANCELPUTIN];
    }
}


#pragma mark - eLongCountly
- (void)sendCountlyEventWithClickSpot:(NSString *)spot
{
    eLongCountlyEventClick *countlyEventClick = [[eLongCountlyEventClick alloc] init];
    countlyEventClick.page = _geographySelectModel.eLongCountlyGeographyPageName;;
    countlyEventClick.clickSpot = spot;
    [countlyEventClick sendEventCount:1];
}

- (void)sendCountlySugEventWithClickSpot:(NSString *)spot
{
    eLongCountlyEventClick *countlyEventClick = [[eLongCountlyEventClick alloc] init];
    countlyEventClick.page = _geographySelectModel.eLongCountlyGeographySuggestionPageName;;
    countlyEventClick.clickSpot = spot;
    [countlyEventClick sendEventCount:1];
}

@end
