//
//  eLongCountlyEventClick.h
//  ElongClient
//
//  Created by top on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongCountlyEventBase.h"

@interface eLongCountlyEventClick : eLongCountlyEventBase

/**
 *  点击的名称
 */
@property (nonatomic,copy) NSString *clickSpot;

/**
 *  点击所在页面
 */
@property (nonatomic,copy) NSString *page;

@end
