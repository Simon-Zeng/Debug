//
//  eLongLoggerRequest.m
//  eLongAnalytics
//
//  Created by chenggong on 15/12/8.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongLoggerRequest.h"
#import "eLongNetworkRequest.h"
#import "eLongHTTPRequest.h"
#import "eLongConfiguration.h"
#import "eLongDatabaseManager.h"
#import "eLongDefine.h"

@interface eLongLoggerRequest()

// 获取MVT相关
@property (nonatomic, strong) NSDictionary *recodeLogContent;
@property (nonatomic, assign) NSUInteger repeatIndex;

// 打点数据相关
@property (nonatomic, strong) NSMutableDictionary *responseWithRangeDic;

@property (nonatomic, assign) BOOL isSending;
@end

@implementation eLongLoggerRequest
DEF_SINGLETON(eLongLoggerRequest)

- (instancetype)init {
    if (self = [super init]) {
        self.isLogSending = NO;
        self.repeatIndex = 0;
        self.responseWithRangeDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return self;
}

- (void)sendFixedLog:(NSDictionary *)logContent {
    self.isLogSending = YES;
    __weak __typeof(self) weakSelf = self;
    self.recodeLogContent = logContent;
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"mtools/getMvtConfig"
                                                                       params:logContent
                                                                       method:eLongNetworkRequestMethodPOST
                                                                     encoding:eLongNetworkEncodingGNUZip];
    [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"IsError"] boolValue]) {
            [[eLongConfiguration sharedInstance] registerMVTConfigWithData:responseObject];
        }
        self.isLogSending = NO;
    } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
        if (_repeatIndex < 3) {
            [weakSelf sendFixedLog:_recodeLogContent];
            self.repeatIndex++;
        }
        else {
            self.repeatIndex = 0;
        }
        self.isLogSending = NO;
    }];
}

- (void)sendFlexibleLog:(NSDictionary *)logContent from:(NSUInteger)fromIndex to:(NSUInteger)toIndex {
    self.isLogSending = YES;
    
    if (self.isSending) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"mtools/uploadMvtLog"
                                                                       params:logContent
                                                                       method:eLongNetworkRequestMethodPOST
                                                                     encoding:eLongNetworkEncodingGNUZip];
    self.isSending = YES;
    eLongHTTPRequestOperation * uploadHTTPRequestOperation = [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"IsError"] boolValue]) {
            NSMutableDictionary *operationDic = [weakSelf.responseWithRangeDic objectForKey:[NSString stringWithFormat:@"%p", operation]];
            if (DICTIONARYHASVALUE(operationDic)) {
                NSUInteger minInt = [[operationDic objectForKey:@"minInt"] integerValue];
                NSUInteger maxInt = [[operationDic objectForKey:@"maxInt"] integerValue];
                [[eLongDatabaseManager shareDataInstance] eraseTable:@"eLongAnalyticsFlexibleLog" withDatabaseType:eLongAnalyticsLoggerType fromIndex:minInt toIndex:maxInt];
            }
        }
        self.isSending = NO;
        self.isLogSending = NO;
    } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
        self.isSending = NO;
        self.isLogSending = NO;
    }];
    
    [_responseWithRangeDic setObject:@{@"minInt":[NSNumber numberWithInteger:fromIndex], @"maxInt":[NSNumber numberWithInteger:toIndex]} forKey:[NSString stringWithFormat:@"%p", uploadHTTPRequestOperation]];
}

@end
