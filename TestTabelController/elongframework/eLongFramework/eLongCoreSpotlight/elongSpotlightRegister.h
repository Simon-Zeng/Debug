//
//  elongSpotlightRegister.h
//  ElongClient
//
//  Created by ksy on 15/9/21.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreSpotlight/CoreSpotlight.h>
#define elongSpotlightSeparated @"#elongSpotlightRegister#"
#define elongSpotlightHotelIds @"#elongSpotlightHotelId#"

@interface elongSpotlightRegister : NSObject
/**
 *  注册CoreSpotlight搜索
 *
 *  @param title               展示的标题
 *  @param contentDescription  描述信息    可选
 *  @param thumbnailData       展示图片数据 可选
 *  @param routeString         路由地址    可选
 *  @param params              路由后返回的参数 可选
 */
+(void)registerSpotlightTitle:(NSString *)title contentDescription:(NSString *)contentDescription thumbnailData:(NSData *)thumbnailData route:(NSString *)routeString params:(NSDictionary *)params;
/**
 *  删除注册的CoreSpotlight搜索通过routeString 删除DomainIdentifier
 *
 *  @param routeString          通过路由地址删除对应该路由下的所有搜索
 */
+ (void)deleteSpotlightRouteDomainIdentifier:(NSString *)routeString;
/**
 *  删除注册的CoreSpotlight搜索通过routeString和注册是的字典 删除的是Identifier
 *
 *  @param routeString          通过路由地址
 *  @param params               注册时的字典
 */
+ (void)deleteSpotlightRouteIdentifier:(NSString *)routeString params:(NSDictionary *)params;
/**
 *  解析搜索返回来的字符串2个元素 0 为routeString 1为params
 *
 *  @param identifier           通过路由地址
 *  @param params               注册时的字典  可为空
 */
+ (NSArray *)identifierSeparated:(NSString *)identifier;
@end
