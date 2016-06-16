//
//  eLongGeographyTableViewDataSource.h
//  ElongClient
//
//  Created by chenggong on 15/9/11.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#ifndef ElongClient_eLongGeographyTableViewDataSource_h
#define ElongClient_eLongGeographyTableViewDataSource_h

typedef NSUInteger (^UITableViewNumberOfSectionsInTableViewBlock)(UITableView* tableView);
typedef NSArray* (^UITableViewSectionIndexTitlesForTableViewBlock)(UITableView* tableView);
typedef UITableViewCell* (^UITableViewCellForRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef NSUInteger (^UITableViewNumberOfRowsInSectionBlock)(UITableView* tableView, NSInteger section);
typedef NSUInteger (^UITableViewSectionForSectionIndexTitleBlock)(UITableView* tableView, NSString* title, NSInteger index);
typedef NSString* (^UITableViewTitleForFooterInSectionBlock)(UITableView* tableView, NSInteger section);
typedef NSString* (^UITableViewTitleForHeaderInSectionBlock)(UITableView* tableView, NSInteger section);

#endif
