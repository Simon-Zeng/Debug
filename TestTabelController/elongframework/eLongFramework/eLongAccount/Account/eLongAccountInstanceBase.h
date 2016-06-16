//
//  eLongAccountInstanceBase.h
//  ElongClient
//
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongNetworking.h"

/**
 *  账户系统中封装的成功网络请求回调
 *
 *  @param op     eLongHTTPRequestOperation
 *  @param object object
 */
typedef void(^NetSuccessCallBack) (eLongHTTPRequestOperation*op,id object);
/**
 *  账户系统中封装的失败的网络请求
 *
 *  @param op    eLongHTTPRequestOperation
 *  @param error NSError
 */
typedef void(^NetFailedCallBack)(eLongHTTPRequestOperation *op,NSError *error);

@interface eLongAccountInstanceBase : NSObject
/**
 *  清除数据，子类实现
 */
-(void)clearData;
@end
