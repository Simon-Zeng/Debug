//
//  eLongRoutes.h
//  ElongClient
//
//  Created by Dawn on 15/4/18.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const eLongRoutesPatternKey = @"eLongRoutePattern";
static NSString *const eLongRoutesURLKey = @"eLongRouteURL";
static NSString *const eLongRoutesNamespaceKey = @"eLongRouteNamespace";
static NSString *const eLongRoutesWildcardComponentsKey = @"eLongRouteWildcardComponents";
static NSString *const eLongRoutesGlobalNamespaceKey = @"eLongRoutesGlobalNamespace";

@interface eLongRoutes : NSObject
/** @class eLongRoutes
 eLongRoutes 用来管理URL路由
 */

/**
*  返回全局的路由namespace
*
*  @return 全局的路由namespace
*/
+ (instancetype)globalRoutes;

/// Returns a routing namespace for the given scheme

/**
 *  通过给定的scheme返回路由namespace
 *
 *  @param scheme scheme
 *
 *  @return namespace
 */
+ (instancetype)routesForScheme:(NSString *)scheme;
/**
 *  是否把“+”替换为“ ” 默认为YES
 *
 *  @param shouldDeecode
 */
+ (void)setShouldDecodePlusSymbols:(BOOL)shouldDeecode;
/**
 *  返回是否把“+”替换为“ ”
 *
 *  @return
 */
+ (BOOL)shouldDecodePlusSymbols;
/**
 *  注册路由模式，默认优先级为0(类方法)
 *
 *  @param routePattern 路由模式
 *  @param handlerBlock 匹配之后的block
 */
+ (void)addRoute:(NSString *)routePattern handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;
/**
 *  注册路由模式，默认优先级为0(实例方法)
 *
 *  @param routePattern 路由模式
 *  @param handlerBlock 匹配之后的block
 */
- (void)addRoute:(NSString *)routePattern handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;
/**
 *  删除路由模式(类方法)
 *
 *  @param routePattern 路由模式
 */
+ (void)removeRoute:(NSString *)routePattern;
/**
 *  删除路由模式(实例方法)
 *
 *  @param routePattern 路由模式
 */
- (void)removeRoute:(NSString *)routePattern;
/**
 *  删除所有的路由模式(类方法)
 */
+ (void)removeAllRoutes;
/**
 *  删除所有的路由模式(实例方法)
 */
- (void)removeAllRoutes;
/**
 *  接触scheme的注册
 *
 *  @param scheme scheme
 */
+ (void)unregisterRouteScheme:(NSString *)scheme;
/**
 *  KVC模式注册路由模式
 *
 *  @param handlerBlock 匹配之后的block
 *  @param routePatten  路由模式
 */
- (void)setObject:(id)handlerBlock forKeyedSubscript:(NSString *)routePatten;
/**
 *  在全局scheme空间下注册路由模式，如果路由模式匹配成功并且block返回YES则不再继续路由，如果block返回NO则继续路由(类方法)
 *
 *  @param routePattern 路由模式
 *  @param priority     优先级
 *  @param handlerBlock 路由模式匹配以后的回调
 */
+ (void)addRoute:(NSString *)routePattern priority:(NSUInteger)priority handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;
/**
 *  在全局scheme空间下注册路由模式，如果路由模式匹配成功并且block返回YES则不再继续路由，如果block返回NO则继续路由(实例方法)
 *
 *  @param routePattern 路由模式
 *  @param priority     优先级
 *  @param handlerBlock 路由模式匹配以后的回调
 */
- (void)addRoute:(NSString *)routePattern priority:(NSUInteger)priority handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;
/**
 *  路由一个URL，成功之后返回YES(类方法)
 *
 *  @param URL URL
 *
 *  @return 路由结果
 */
+ (BOOL)routeURL:(NSURL *)URL;
/**
 *  路由一个URL，成功之后返回YES(类方法)
 *
 *  @param URL        URL
 *  @param parameters 参数
 *
 *  @return 路由结果
 */
+ (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters;
/**
 *  路由一个URL，成功之后返回YES(实例方法)
 *
 *  @param URL URL
 *
 *  @return 路由结果
 */
- (BOOL)routeURL:(NSURL *)URL;
/**
 *  路由一个URL，成功之后返回YES(实例方法)
 *
 *  @param URL        URL
 *  @param parameters 参数
 *
 *  @return 路由结果
 */
- (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters;
/**
 *  取消一次路由(类方法)
 *
 *  @param URL URL
 *
 *  @return 取消结果
 */
+ (BOOL)canRouteURL:(NSURL *)URL;
/**
 *  取消一次路由(类方法)
 *
 *  @param URL        URL
 *  @param parameters 参数
 *
 *  @return 取消结果
 */
+ (BOOL)canRouteURL:(NSURL *)URL withParameters:(NSDictionary *)parameters;
/**
 *  取消一次路由(实例方法)
 *
 *  @param URL URL
 *
 *  @return 取消结果
 */
- (BOOL)canRouteURL:(NSURL *)URL;
/**
 *  取消一次路由(实例方法)
 *
 *  @param URL        URL
 *  @param parameters 参数
 *
 *  @return 取消结果
 */
- (BOOL)canRouteURL:(NSURL *)URL withParameters:(NSDictionary *)parameters;
/**
 *  打印路由表
 *
 *  @return 路由表
 */
+ (NSString *)description;
/**
 *  开启或关闭日志模式
 *
 *  @param loggingEnabled 是否开启日志模式
 */
+ (void)setVerboseLoggingEnabled:(BOOL)loggingEnabled;
/**
 *  返回当前的日志模式
 *
 *  @return 当前的日志模式
 */
+ (BOOL)isVerboseLoggingEnabled;
/**
 *  是否在路由失败时回到全局模式进行路由，默认为NO
 */
@property (nonatomic, assign) BOOL shouldFallbackToGlobalRoutes;
/**
 *  路由失败时进行截获
 */
@property (nonatomic, copy) void (^unmatchedURLHandler)(eLongRoutes *routes, NSURL *URL, NSDictionary *parameters);

@end
