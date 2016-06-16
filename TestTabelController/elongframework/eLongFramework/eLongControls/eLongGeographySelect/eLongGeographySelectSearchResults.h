//
//  eLongGeographySelectSearchResults.h
//  Pods
//
//  Created by chenggong on 15/9/29.
//
//

#import <Foundation/Foundation.h>
#import "eLongGeographySelectModel.h"
#import "eLongGeographySelectDataSourceModel.h"
#import "eLongGeographyTableViewDataSource.h"

typedef void (^SearchResultDidSelectRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath, NSArray *searchList);

@interface eLongGeographySelectSearchResults : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) SearchResultDidSelectRowAtIndexPathBlock suggestionSearchDidSelectBlock;
@property (nonatomic, copy) UITableViewCellForRowAtIndexPathBlock cellForRowAtIndexPath;

- (instancetype)initWithGeographySelectModel:(eLongGeographySelectModel *)selectModel withDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel;

- (void)updateSearchList:(NSArray *)searchList;
- (NSMutableArray *)searchSuggestionKeyWordFromLocal:(NSString *)suggestionKeyWord;

@end
