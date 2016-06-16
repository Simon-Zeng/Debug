//
//  eLongNetworkRequest.h
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  HTTP请求类型
 */
typedef NS_ENUM(NSInteger, eLongNetworkRequestMethod) {
    /**
     *  GET
     */
    eLongNetworkRequestMethodGET,
    /**
     *  PUT
     */
    eLongNetworkRequestMethodPUT,
    /**
     *  POST
     */
    eLongNetworkRequestMethodPOST,
    /**
     *  DELETE
     */
    eLongNetworkRequestMethodDELETE
};

/**
 *  网络请求下行数据压缩格式
 */
typedef NS_ENUM(NSInteger, eLongNetworkContentEncoding){
    /**
     *  None (无压缩)
     */
    eLongNetworkEncodingNone = 0,
    /**
     *  LZSS (Jacob Ziv、Abraham Lempel、Storer、Szymanski)
     */
    eLongNetworkEncodingLZSS,
    /**
     *  GNUZip (Jean-loupGailly、MarkAdler)
     */
    eLongNetworkEncodingGNUZip
};

/**
 *  网络请求缓存策略
 */
typedef NS_ENUM(NSInteger, eLongNetworkContentCache) {
    /**
     *  默认缓存策略，先检测缓存是否存在，如果存在且没有过期读取缓存，如果不存在或者过期继续发送网络请求
     */
    eLongNetworkCacheDefault,
    /**
     *  优先缓存策略，先检测缓存是否存在，如果存在无论是否过期返回缓存数据，继续发送网络请求
     */
    eLongNetworkCacheFirst,
    /**
     *  无缓冲
     */
    eLongNetworkCacheNone
};

@interface eLongNetworkRequest : NSObject
/**
 *  服务器地址
 */
@property (nonatomic,copy) NSString *server;
/**
 *  渠道号
 */
@property (nonatomic,copy) NSString *channelID;
/**
 *  API 版本
 */
@property (nonatomic,copy) NSString *version;
/**
 *  设备ID
 */
@property (nonatomic,copy) NSString *deviceID;
/**
 *  AuthCode，暂时没有用到
 */
@property (nonatomic,copy) NSString *authCode;
/**
 *  ClientType客户端类型
 */
@property (nonatomic,copy) NSString *clientType;
/**
 *  手机操作系统版本
 */
@property (nonatomic,copy) NSString *osVersion;
/**
 *  Content-Type
 */
@property (nonatomic,copy) NSString *contentType;
/**
 *  Session
 */
@property (nonatomic,copy) NSString *sessionToken;
/**
 *  check code，防止网络抓取
 */
@property (nonatomic,copy) NSString *checkCode;
/**
 *  IDFA，广告追踪
 */
@property (nonatomic,copy) NSString *guid;
/**
 *  java请求的key
 */
@property (nonatomic,copy) NSString *javaKey;
/**
 *  trace id 追踪用户行为
 */
@property (nonatomic,copy) NSString *userTraceId;
/**
 *  设备类型
 */
@property (nonatomic,copy) NSString *phoneModel;
/**
 *  设备品牌
 */
@property (nonatomic,copy) NSString *phoneBrand;
/**
 *  经度
 */
@property (nonatomic,copy) NSString *longitude;
/**
 *  纬度
 */
@property (nonatomic,copy) NSString *latitude;


/**
 *  NetworkRequest单例
 *
 *  @return NetworkRequest
 */
+ (instancetype)sharedInstance;
/**
 *  .net网络请求，默认无缓存策略
 *
 *  @param target   请求地址
 *  @param params   请求参数
 *  @param method   请求类型(GET,POST等)
 *  @param encoding 是否压缩编码
 *
 *  GET请求时 target为请求地址 如： http://mobile-api2011.elong.com/JsonService/OtherService.aspx
 *  POST请求时 target为server地址以后的地址 如：JsonService/OtherService.aspx?action=GetCachingPolicy
 *
 *  @return NSURLReqeust
 */
- (NSURLRequest *)dotNetRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method encoding:(BOOL)encoding;

/**
 *  .net网络请求，带缓存策略和缓存时间
 *
 *  @param target            请求地址
 *  @param params            请求参数
 *  @param method            请求类型(GET,POST等)
 *  @param encoding          压缩编码类型
 *  @param cache             缓存策略
 *  @param cacheTimeInterval 缓存时间
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)dotNetRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method encoding:(BOOL)encoding cache:(eLongNetworkContentCache)cache cacheTimeInterval:(NSTimeInterval)cacheTimeInterval;

/**
 *  .net网络请求，带缓存策略和缓存时间(非会员订单列表)
 *
 *  @param target            请求地址
 *  @param params            请求参数
 *  @param method            请求类型(GET,POST等)
 *  @param encoding          压缩编码类型
 *  @param cache             缓存策略
 *  @param cacheTimeInterval 缓存时间
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *) dotNewNetRequest:(NSString *)target params:(NSString *)params method:(eLongNetworkRequestMethod)method encoding:(BOOL)encoding cache:(eLongNetworkContentCache)cache cacheTimeInterval:(NSTimeInterval)cacheTimeInterval;

/**
 *  java网络请求，默认为gzip压缩，默认无缓存策略
 *
 *  @param target 请求地址
 *  @param params 请求参数
 *  @param method  请求类型(GET,POST等)
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)javaRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method;
/**
 *  java网络请求，默认无缓存策略
 *
 *  @param target   请求地址
 *  @param params   请求参数
 *  @param method   请求类型(GET,POST等)
 *  @param encoding 压缩编码类型
 *
 *  请求时 target为server地址以后的地址 如：hotel/getHotSuggest
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)javaRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method encoding:(eLongNetworkContentEncoding)encoding;

/**
 *  java网络请求，带缓存策略
 *
 *  @param target            请求地址
 *  @param params            请求参数
 *  @param method            请求类型(GET,POST等)
 *  @param encoding          压缩编码类型
 *  @param cache             缓存策略
 *  @param cacheTimeInterval 缓存时间
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)javaRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method encoding:(eLongNetworkContentEncoding)encoding cache:(eLongNetworkContentCache)cache cacheTimeInterval:(NSTimeInterval)cacheTimeInterval;
@end
