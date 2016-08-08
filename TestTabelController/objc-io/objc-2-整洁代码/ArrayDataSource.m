//
//  ArrayDataSource.m
//  TestTabelController
//
//  Created by wzg on 16/8/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "ArrayDataSource.h"

@interface ArrayDataSource()
@property (nonatomic, strong)NSArray *items;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) tableViewCellConfigureBlock configureBlock;
@end

@implementation ArrayDataSource
- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(tableViewCellConfigureBlock)aConfigureBlock
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.items = items;
        self.configureBlock = aConfigureBlock;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return _items[(NSUInteger)indexPath.row];
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:_identifier
                                              forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureBlock(cell,item);
    return cell;
}
@end
