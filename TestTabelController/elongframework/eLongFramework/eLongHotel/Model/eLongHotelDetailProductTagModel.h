//
//  eLongHotelDetailProductTagModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongHotelDetailProductTagModel @end
@interface eLongHotelDetailProductTagModel : eLongResponseBaseModel
/**
 *  标签id
 */
@property (nonatomic,assign) NSInteger Id;
/**
 *  标签展示名称
 */
@property (nonatomic,copy) NSString *Name;
/**
 *  标签描述
 */
@property (nonatomic,copy) NSString *Description;
/**
 *  颜色索引
 */
@property (nonatomic,assign) NSInteger ColorIndex;
/**
 *  是否可用
 */
@property (nonatomic,assign) BOOL Available;
@end
