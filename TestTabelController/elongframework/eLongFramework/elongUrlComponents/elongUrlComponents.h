//
//  elongUrlComponents.h
//  BaiduSearchDemo
//
//  Created by ksy on 16/1/31.
//  Copyright © 2016年 ksy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface elongUrlComponents : NSObject
/*
 *解析URL，是否支持路由
 *同H5交互时如果不支持路由，需要判断是否支持回调
 */
+ (BOOL)canRouteURL:(NSURL *)url;

/*
 *支持路由,走路由，解析入参
 */
+ (BOOL)routeURL:(NSURL *)url;


/*
 *同H5交互时，判断是否需要服务
 */

+ (BOOL)needService:(NSURL *)url;
/*
 *同H5交互时，调用服务
 */
+ (BOOL)callService:(NSURL *)url;

/*
 *同H5交互时，判断是否需要回调
 */
+ (BOOL)needCallBack:(NSURL *)url;

/*
 *同H5交互时，回调 未开发完
 */
+ (void)callBack:(NSURL *)url success:(void (^)(NSDictionary *dic))success
                              failure:(void (^)(NSError *error))failure;
@end
