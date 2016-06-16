//
//  eLongGeographyTableViewDelegate.h
//  Pods
//
//  Created by chenggong on 15/9/21.
//
//

#ifndef eLongGeographyTableViewDelegate_h
#define eLongGeographyTableViewDelegate_h

typedef void (^UITableViewAccessoryButtonTappedForRowWithIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef void (^UITableViewDidDeselectRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef void (^UITableViewDidEndEditingRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef void (^UITableViewDidSelectRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef UITableViewCellEditingStyle (^UITableViewEditingStyleForRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef CGFloat (^UITableViewHeightForFooterInSectionBlock)(UITableView* tableView, NSInteger section);
typedef CGFloat (^UITableViewHeightForHeaderInSectionBlock)(UITableView* tableView, NSInteger section);
typedef CGFloat (^UITableViewHeightForRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef BOOL (^UITableViewShouldIndentWhileEditingRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef NSIndexPath* (^UITableViewTargetIndexPathForMoveFromRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* sourceIndexPath, NSIndexPath* proposedDestinationIndexPath);
typedef NSString* (^UITableViewTitleForDeleteConfirmationButtonForRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef UIView* (^UITableViewViewForFooterInSectionBlock)(UITableView* tableView, NSInteger section);
typedef UIView* (^UITableViewViewForHeaderInSectionBlock)(UITableView* tableView, NSInteger section);
typedef void (^UITableViewWillBeginEditingRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef NSIndexPath* (^UITableViewWillDeselectRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);
typedef void (^UITableViewWillDisplayCellBlock)(UITableView* tableView, UITableViewCell* cell, NSIndexPath* indexPath);
typedef NSIndexPath* (^UITableViewWillSelectRowAtIndexPathBlock)(UITableView* tableView, NSIndexPath* indexPath);

#endif /* eLongGeographyTableViewDelegate_h */
