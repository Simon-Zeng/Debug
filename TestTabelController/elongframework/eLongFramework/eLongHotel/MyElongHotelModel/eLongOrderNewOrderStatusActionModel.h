//
//  eLongOrderNewOrderStatusActionModel.h
//  ElongClient
//
//  Created by yangfan on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongOrderNewOrderStatusActionModel @end

@interface eLongOrderNewOrderStatusActionModel : eLongResponseBaseModel
/**
 *  操作名称
 */
@property (nonatomic, copy) NSString * ActionName;
/**
 *  操作id
 */
@property (nonatomic, assign) NSInteger ActionId;
/**
 *  操作在app上的位置 (0,1,2,3)
 */
@property (nonatomic, assign) NSInteger Position;
/**
 *  操作在app上的位置 (0,1,2,3)
 */
@property (nonatomic, assign) NSInteger NewPosition;

@end
