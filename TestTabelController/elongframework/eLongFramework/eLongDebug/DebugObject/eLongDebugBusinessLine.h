//
//  eLongDebugBusinessLine.h
//  ElongClient
//
//  Created by Kirn on 15/3/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugObject.h"
#import "eLongDebugBusinessModel.h"

@interface eLongDebugBusinessLine : eLongDebugObject

/**
 *  添加业务线
 *
 *  @param name 业务线名
 *  @param tag  tag标识
 */
- (void) addBusinessLineName:(NSString *)name tag:(NSUInteger)tag;
/**
 *  移除业务线
 *
 *  @param businessModel 业务线Model
 */
- (void) removeBusinessLine:(eLongDebugBusinessModel *)businessModel;
/**
 *  返回所有的业务线
 */
- (NSArray *) businessLines;
/**
 *  保存
 *
 *  @param businessLineModel 
 */
- (void) saveBusinessLine:(eLongDebugBusinessModel *)businessLineModel;
/**
 *  检测业务线是否可用
 *
 *  @param type 业务类型
 *
 *  @return
 */
- (BOOL) isEnabled:(eLongDebugBLType)type;
@end
