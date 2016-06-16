//
//  eLongNetUtil.m
//  MyElong
//
//  Created by yangfan on 15/6/26.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "eLongNetUtil.h"
#import "GNUzipUncompress.h"
#import "LzssUncompress.h"
#import "eLongAlertView.h"
#import "eLongDefine.h"
#import "JSONKit.h"
#import "eLongExtension.h"
#import "eLongDebugManager.h"
#import "eLongHTTPEncryption.h"
#import "eLongFileIOUtils.h"
#import "eLongNetworkRequest.h"
#import "eLongKeyChain.h"
#import "eLongCONST.h"
#import "eLongNewLoadingView.h"

#define kLoadingViewTag 2015100901

@implementation eLongNetUtil

+ (NSDictionary *)unCompressData:(NSData *)data{
    if (data.length > 0) {
//        if (!IOSVersion_5) {
//            NSString *string = nil;
//            // gzip试探性解压
//            GNUzipUncompress *uncompress = [[GNUzipUncompress alloc] init];
//            string = [uncompress uncompress:data];
//            if (!STRINGHASVALUE(string)) {
//                LzssUncompress *uncompress = [[LzssUncompress alloc] init];
//                string = [uncompress uncompress:data];
//                
//                // 检测漏掉的情况
//                if (!STRINGHASVALUE(string)) {
//                    GNUzipUncompress *uncompress = [[GNUzipUncompress alloc] init];
//                    string = [uncompress uncompress:data];
//                    NSLog(@"解压漏检");
//                }
//            }
//            
//            // 使用JOSNKIT框架解析
//            NSDictionary *rootDic = [string JSONValue];
//            
//            return rootDic;
//        }
//        else {
            NSData *newData = nil;
            // gzip试探性解压
            GNUzipUncompress *uncompress = [[GNUzipUncompress alloc] init];
            newData = [uncompress uncompressData:data];
            if (!newData) {
                LzssUncompress *uncompress = [[LzssUncompress alloc] init];
                newData = [uncompress uncompressData:data];
                
                // 检测漏掉的情况
                if (!newData) {
                    GNUzipUncompress *uncompress = [[GNUzipUncompress alloc] init];
                    newData = [uncompress uncompressData:data];
                    NSLog(@"解压漏检");
                }
            }
            // 使用系统自带的解析JOSN
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:&error];
            
            return dic;
//        }
    }
    
    return nil;
}

//+ (NSDictionary *)unCompressData:(NSData *)data httpUtil:(HttpUtil *)httpUtil {
//    if (data.length > 0) {
//        if (!IOSVersion_5) {
//            NSString *string = nil;
//            if (httpUtil.compressType == HttpDataCompressLzss) {
//                LzssUncompress *uncompress = [[LzssUncompress alloc] init];
//                string = [uncompress uncompress:data];
//            }else if(httpUtil.compressType == HttpDataCompressGNUZip){
//                GNUzipUncompress *uncompress = [[GNUzipUncompress alloc] init];
//                string = [uncompress uncompress:data];
//            }
//            
//            // 使用JOSNKIT框架解析
//            NSDictionary *rootDic = [string JSONValue];
//            
//            return rootDic;
//        }
//        else {
//            NSData *newData = nil;
//            if (httpUtil.compressType == HttpDataCompressLzss) {
//                LzssUncompress *uncompress = [[LzssUncompress alloc] init];
//                newData = [uncompress uncompressData:data];
//            }else if(httpUtil.compressType == HttpDataCompressGNUZip){
//                GNUzipUncompress *uncompress = [[GNUzipUncompress alloc] init];
//                newData = [uncompress uncompressData:data];
//            }
//            
//            // 使用系统自带的解析JOSN
//            NSError *error;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:&error];
//            
//            return dic;
//        }
//    }
//    
//    return nil;
//}

// 拼装请求Url
+ (NSString *)composeNetSearchUrl:(NSString *)business forService:(NSString *)service andParam:(NSString *)param
{
    if (business != nil && service != nil &&  param != nil)
    {
        NSLog(@"%@",[param JSONString]);
        NSString *newkey = [eLongNetworkRequest sharedInstance].javaKey;
        NSString *body = [eLongHTTPEncryption encryptString:param byKey:newkey];
        body = [body URLEncodedString];
        
        // 组装url
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@?req=%@",[eLongDebugManager serverInstance].serverUrl,business,service,body];
        
        return url;
    }
    
    return nil;
}


+ (NSString *)composeNetSearchUrl:(NSString *)business forService:(NSString *)service
{
    if (business != nil && service != nil)
    {
        // 组装url
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@?",[eLongDebugManager serverInstance].serverUrl, business, service];
        
        return url;
    }
    
    return nil;
}

// .net服务请求串拼接
+ (NSString *)requesString:(NSString *)actionName andIsCompress:(BOOL)iscompress andParam:(NSString *)param
{
    if (STRINGHASVALUE(actionName) && STRINGHASVALUE(param))
    {
        NSString *url = [NSString stringWithFormat:@"action=%@&version=1.2&compress=%@&req=%@",actionName,[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],param];
        
        return url;
    }
    
    return nil;
}

// 用于普通请求，超时时间较短
+(void)request:(NSString *)url req:(NSString *)req delegate:(id)delegate{
//    HttpUtil *httpUtil = [HttpUtil shared];
//    httpUtil.retryLimit = 1;
//    [httpUtil connectWithURLString:url Content:req Delegate:delegate];
}

//
+ (void)orderRequest:(NSString *)url req:(NSString *)req delegate:(id)delegate{
//    if (USENEWNET) {
//        HttpUtil *httpUtil = [HttpUtil shared];
//        httpUtil.outTime = 30;        // 提交订单的模块加长超时时间
//        [httpUtil connectWithURLString:url Content:req Delegate:delegate];
//    }
}

+(void)request:(NSString *)url req:(NSString *)req delegate:(id)delegate disablePop:(BOOL)disablePop disableClosePop:(BOOL)disableClosePop disableWait:(BOOL)disableWait{
//    if (USENEWNET) {
//        HttpUtil *httpUtil = [HttpUtil shared];
//        httpUtil.retryLimit = 1;
//        [httpUtil connectWithURLString:url Content:req StartLoading:!disablePop EndLoading:!disableClosePop Delegate:delegate];
//    }
}
//+ (void)request:(NSString *)url req:(NSString *)req policy:(CachePolicy)policy delegate:(id)delegate{
//    NSLog(@"req:%@",req);
//    HttpUtil *httpUtil = [HttpUtil shared];
//    httpUtil.retryLimit = 1;
//    [httpUtil sendSynchronousRequest:url PostContent:req CachePolicy:policy Delegate:delegate];
//}

// 弹框的错误检测
+(BOOL)checkJsonIsError:(NSDictionary *)root{
    if (root==nil) {
        [eLongAlertView showAlertQuiet:@"服务器错误"];
        return YES;
    }else {
        NSString *message = [root safeObjectForKey:@"ErrorMessage"];
        NSObject *code = nil;
        if(!OBJECTISNULL([root safeObjectForKey:@"ErrorCode"])){
            code = [root safeObjectForKey:@"ErrorCode"];
        }
        
        if ([code isKindOfClass:[NSNumber class]]) {
            if ([((NSNumber *)code) intValue] == 1000) {
                // 后台出错的情况
                if (STRINGHASVALUE(message)) {
                    [eLongAlertView showAlertTitle:message Message:nil];
                } else {
                    [eLongAlertView showAlertQuiet:@"系统正忙，请稍后再试"];
                }
                return YES;
            }
            if ([((NSNumber *)code) intValue] == 1) {
                // 这是提交订单时重单的情况,不做提示
                return NO;
            }
        }else if([code isKindOfClass:[NSString class]]){
            // sessionToken 过期
            if ([((NSString *)code) isEqualToString:@"session_1001"])
            {
                // token过期
                if (STRINGHASVALUE(message)) {
                    [eLongAlertView showAlertTitle:message Message:nil];
                }
                else
                {
                    //modify by jin.li
                    //[PublicMethods showAlertTitle:@"登录过期，请重新登录" Message:nil];
                    [eLongAlertView showAlertQuiet:@"登录过期，请重新登录"];
                }
                
                // 需改动
//                // 删除本地保存的sessionToken
//                [[TokenReq shared] deleteSessionToken];
                
                return YES;
            }else if([((NSString *)code) isEqualToString:@"turtle_1000"]){
                // 需改动
//                // 防抓取
//                RobotForbidStrategy *robotForbidStrategy = [[RobotForbidStrategy alloc] init];
//                [robotForbidStrategy showCheckCodeViewWithURL:[root objectForKey:@"checkUrl"]];
//                [robotForbidStrategy release];
                return YES;
            }
        }
        
        if (( [message isEqual:[NSNull null]]||!STRINGHASVALUE(message)) && ![[root safeObjectForKey:@"IsError"] boolValue]) {
            return NO;
        }else {
            if ([root safeObjectForKey:@"ErrorMessage"]==[NSNull null]||[message isEqualToString:@""]) {
                [eLongAlertView showAlertQuiet:@"服务器错误"];
            } else {
                [eLongAlertView showAlertQuiet:message];
            }
            return YES;
        }
        return NO;
    }
}

// 不弹框的错误检测
+ (BOOL)checkJsonIsErrorNoAlert:(NSDictionary *)root {
    if (root==nil) {
        return YES;
    }else {
        NSString *message = [root safeObjectForKey:@"ErrorMessage"];
        
        NSObject *code = nil;
        if(!OBJECTISNULL([root safeObjectForKey:@"ErrorCode"])){
            code = [root safeObjectForKey:@"ErrorCode"];
        }
        
        // 防抓取
        if([code isKindOfClass:[NSString class]]){
            if([((NSString *)code) isEqualToString:@"turtle_1000"]){
                // 需改动
//                RobotForbidStrategy *robotForbidStrategy = [[RobotForbidStrategy alloc] init];
//                [robotForbidStrategy showCheckCodeViewWithURL:[root objectForKey:@"checkUrl"]];
//                [robotForbidStrategy release];
                return YES;
            }
        }
        
        if (([message isEqual:[NSNull null]] || !STRINGHASVALUE(message)) && ![[root safeObjectForKey:@"IsError"] boolValue]) {
            return NO;
        }else {
            return YES;
        }
        
        return NO;
    }
}

+ (void)showLoadingView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *loadingView = [keyWindow viewWithTag:kLoadingViewTag];
    
    if (!loadingView) {
        
        loadingView = [[eLongNewLoadingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        loadingView.tag = kLoadingViewTag;
        [keyWindow addSubview:loadingView];
    }
    
    if ([[loadingView class] isSubclassOfClass:[eLongNewLoadingView class]]) {
        
        [keyWindow bringSubviewToFront:loadingView];
        [(eLongNewLoadingView *)loadingView startLoading];
    }
}

+ (void)dismissLoadingView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *loadingView = [keyWindow viewWithTag:kLoadingViewTag];

    if ([[loadingView class] isSubclassOfClass:[eLongNewLoadingView class]]) {
        
        loadingView.hidden = YES;
        [(eLongNewLoadingView *)loadingView stopLoading];
    }
}

@end
