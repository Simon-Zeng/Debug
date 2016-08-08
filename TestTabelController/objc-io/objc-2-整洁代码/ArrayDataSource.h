//
//  ArrayDataSource.h
//  TestTabelController
//
//  Created by wzg on 16/8/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^tableViewCellConfigureBlock)(id cell,id item);

@interface ArrayDataSource : NSObject<UITableViewDataSource>
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(tableViewCellConfigureBlock)aConfigureBlock;
@end
