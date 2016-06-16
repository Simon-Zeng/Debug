//
//  eLongNetworkDynamicCommunication.m
//  ElongClient
//
//  Created by top on 16/2/26.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongNetworkDynamicCommunication.h"
#import "eLongNetworkRSAManager.h"
#import "eLongHTTPBase64Encoding.h"
#import "eLongHTTPURLEncoding.h"
#import "eLongNetworkDynamicCommunicationAPIAndVersionModel.h"
#import "eLongNetworkDynamicCommunicationNegoDataModel.h"
#import "eLongNetworkDynamicCommunicationSessionDataModel.h"
#import "eLongNetworkRSACryptor.h"
#import "eLongDefine.h"
#import "eLongHTTPRequest.h"
#import "eLongFileIOUtils.h"
#import "eLongNetworkRequest.h"

static NSString * const aes_key = @"a207bdbd-75d0-4184-97d9-abb30aca57b5";
static NSString * const kApiAndVersionKey = @"ApiAndVersionForDynamicCommunication";
static NSString * const kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface eLongNetworkDynamicCommunication ()

@property (nonatomic, copy) NSString *sessionKey;

@property (nonatomic, assign) NSTimeInterval sessionKeyTimeInterval;

@property (nonatomic, assign) long sessionKeyEffectivePeriod;

@property (nonatomic, copy) NSString *aesKey;

@property (nonatomic, copy) CommunicationCompletionBlock completionBlock;

@property (nonatomic, strong) eLongNetworkDynamicCommunicationAPIAndVersionModel *apiAndVersionModel;

@property (nonatomic, assign) BOOL isUnderNegotiation;

@end

@implementation eLongNetworkDynamicCommunication

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id singleton;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isUnderNegotiation = NO;
    }
    return self;
}

#pragma mark - public method
- (void)startCommunicationWithCompletion:(CommunicationCompletionBlock)completion {
    if (self.isUnderNegotiation) {
        return;
    }
    if ([self p_checkHasConnected]) {
        [self p_completion:YES];
    } else {
        [self p_reset];
        self.completionBlock = completion;
        [self p_fetchApiAndVersion];
        [self p_fetchNegoInfo];
    }
}

- (BOOL)checkApiTitleEnabled:(NSString *)apiTitle {
    BOOL isEnabled = NO;
    if (!STRINGHASVALUE(apiTitle)
        || !STRINGHASVALUE(self.sessionKey)
        || self.sessionKeyEffectivePeriod <= 0
        || self.sessionKeyTimeInterval <= 0
        || !STRINGHASVALUE(self.aesKey)
        || !self.apiAndVersionModel
        || !ARRAYHASVALUE(self.apiAndVersionModel.whitelist)) {
        return isEnabled;
    }
    if (ARRAYHASVALUE(self.apiAndVersionModel.blacklist)) {
        for (NSString *bApi in self.apiAndVersionModel.blacklist) {
            if ([bApi rangeOfString:@"/*"].location == NSNotFound) {
                if ([bApi isEqualToString:apiTitle]) {
                    return isEnabled;
                }
            } else {
                NSString *newApi = [bApi substringToIndex:bApi.length-1];
                if ([apiTitle rangeOfString:newApi].location == 0) {
                    return isEnabled;
                }
            }
        }
    }
    for (NSString *wApi in self.apiAndVersionModel.whitelist) {
        if ([wApi rangeOfString:@"/*"].location == NSNotFound) {
            if ([wApi isEqualToString:apiTitle]) {
                isEnabled = YES;
                return isEnabled;
            }
        } else {
            NSString *newApi = [wApi substringToIndex:wApi.length-1];
            if ([apiTitle rangeOfString:newApi].location == 0) {
                isEnabled = YES;
                return isEnabled;
            }
        }
    }
    return isEnabled;
}

- (NSString *)fetchAesKey {
    return self.aesKey;
}

- (NSString *)fetchSessionKey {
    return self.sessionKey;
}

#pragma mark - private method
- (void)p_reset {
    self.completionBlock = nil;
    self.sessionKey = nil;
    self.sessionKeyEffectivePeriod = 0;
    self.sessionKeyTimeInterval = 0;
    self.aesKey = nil;
    self.apiAndVersionModel = nil;
}

//提前协商
- (void)p_refetchNegoInfo {
    [self p_reset];
    [self p_fetchApiAndVersion];
    [self p_fetchNegoInfo];
}

//检查是否需要重新进行协商
- (BOOL)p_checkHasConnected {
    BOOL hasConnected = NO;
    if (!STRINGHASVALUE(self.sessionKey)
        || self.sessionKeyEffectivePeriod <= 0
        || self.sessionKeyTimeInterval <= 0
        || !STRINGHASVALUE(self.aesKey)
        || !self.apiAndVersionModel
        || !ARRAYHASVALUE(self.apiAndVersionModel.whitelist)) {
        return hasConnected;
    }
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval expiredPeriod = currentTimeInterval - self.sessionKeyTimeInterval;
    if (expiredPeriod < self.sessionKeyEffectivePeriod) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if (self.sessionKeyEffectivePeriod-expiredPeriod > 600) {
            [self performSelector:@selector(p_refetchNegoInfo)
                       withObject:nil
                       afterDelay:(self.sessionKeyEffectivePeriod-expiredPeriod)*0.6];
        } else {
            [self p_refetchNegoInfo];
        }
        hasConnected = YES;
    }
    return hasConnected;
}

//获取本地存储的apilist和version信息
- (void)p_fetchApiAndVersion {
    NSData *data = [eLongUserDefault objectForKey:kApiAndVersionKey];
    if (data) {
        eLongNetworkDynamicCommunicationAPIAndVersionModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (model) {
            self.apiAndVersionModel = [model copy];
        }
    }
}

- (void)p_setRequestHeader:(NSMutableURLRequest *)request {
    [request setValue:[eLongNetworkRequest sharedInstance].deviceID forHTTPHeaderField:@"deviceid"];
    [request setValue:[eLongNetworkRequest sharedInstance].version forHTTPHeaderField:@"version"];
    [request setValue:[eLongNetworkRequest sharedInstance].osVersion forHTTPHeaderField:@"OsVersion"];
    [request setValue:[eLongNetworkRequest sharedInstance].guid forHTTPHeaderField:@"Guid"];
    [request setValue:[eLongNetworkRequest sharedInstance].phoneBrand forHTTPHeaderField:@"PhoneBrand"];
    [request setValue:[eLongNetworkRequest sharedInstance].phoneModel forHTTPHeaderField:@"PhoneModel"];
}

- (void)p_fetchNegoInfo {
    self.isUnderNegotiation = YES;
    NSString *server = [eLongNetworkRequest sharedInstance].server;
    if (!STRINGHASVALUE(server)) {
        [self p_completion:NO];
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/commu/a?protocolName=ETLSv1.0", server]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self p_setRequestHeader:request];
    [request setHTTPMethod:@"GET"];
    //设置negoVersion
    NSString *negoVersion = nil;
    if (!self.apiAndVersionModel || self.apiAndVersionModel.negoversion <= 0) {
        negoVersion = @"-1";
    } else {
        negoVersion = [NSString stringWithFormat:@"%ld", self.apiAndVersionModel.negoversion];
    }
    [request setValue:STRINGHASVALUE(negoVersion) ? negoVersion : @"-1" forHTTPHeaderField:@"negoversion"];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    request.timeoutInterval = 30.0f;
    [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        if (DICTIONARYHASVALUE(responseObject)) {
            [self p_analysisPublicKeyWithInfo:responseObject];
        } else {
            [self p_completion:NO];
        }
    } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [self p_completion:NO];
    }];
}

- (void)p_completion:(BOOL)isSuccessful {
    self.isUnderNegotiation = NO;
    if (self.completionBlock) {
        self.completionBlock(isSuccessful);
    }
    if (!isSuccessful) {
        [self p_reset];
    }
}

- (void)p_createAesKey {
    // 生成字符串长度
    int randomLength = 16;
    NSMutableString *randomString = [NSMutableString stringWithCapacity:randomLength];
    for (int i = 0; i < randomLength; i++) {
        [randomString appendFormat:@"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    NSLog(@"AesKey = %@", randomString);
    self.aesKey = randomString;
}

- (void)p_analysisPublicKeyWithInfo:(NSDictionary *)info {
    eLongNetworkDynamicCommunicationNegoDataModel *negoModel = [[eLongNetworkDynamicCommunicationNegoDataModel alloc] initWithDictionary:info error:nil];
    //version 更新
    if (self.apiAndVersionModel) {
        if (self.apiAndVersionModel.negoversion < negoModel.negoversion) {
            self.apiAndVersionModel = [[eLongNetworkDynamicCommunicationAPIAndVersionModel alloc] initWithDictionary:info error:nil];
        }
    } else {
        self.apiAndVersionModel = [[eLongNetworkDynamicCommunicationAPIAndVersionModel alloc] initWithDictionary:info error:nil];
    }
    NSData *historyData = [NSKeyedArchiver archivedDataWithRootObject:self.apiAndVersionModel];
    [eLongUserDefault setObject:historyData forKey:kApiAndVersionKey];
    //验签
    NSString *publicKeyfilePath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    BOOL isMatch = [eLongNetworkRSAManager verifyPlainString:negoModel.negoKey
                                                    withSign:negoModel.sign
                                        andPublicKeyFilePath:publicKeyfilePath];
    if (isMatch) {
        //生成aesKey
        [self p_createAesKey];
        //解密网络获取的公钥
        eLongNetworkRSACryptor *rsaCryptor = [[eLongNetworkRSACryptor alloc] init];
        NSString *localPublickKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"pem"];
        [rsaCryptor loadRSAPublicKeyWithFilePath:localPublickKeyPath];
        NSData *cipherData = [eLongNetworkRSAManager base64DecodeWithString:negoModel.negoKey];
        NSData *plainData = [rsaCryptor decryptWithPublicKeyUsingPadding:RSA_PADDING_TYPE_PKCS1
                                                              cipherData:cipherData];
        //公钥
        NSString *publicKeyText = [eLongNetworkRSAManager base64EncodeWithData:plainData];
        BOOL importSuccess = [rsaCryptor importRSAPublicKeyBase64:publicKeyText
                                                     withFilename:@"first"];
        if (importSuccess) {
            //公钥加密aesKey
            NSData *cipherData = [rsaCryptor encryptWithPublicKeyUsingPadding:RSA_PADDING_TYPE_PKCS1
                                                                    plainData:[self.aesKey dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *cipherString = [[eLongHTTPBase64Encoding alloc] encodingData:cipherData];
            if (STRINGHASVALUE(cipherString)) {
                [self fetchPublicKeySecondStepWithVerifyString:cipherString];
            } else {
                [self p_completion:NO];
            }
        } else {
            [self p_completion:NO];
        }
    } else {
        [self p_completion:NO];
    }
}

- (void)fetchPublicKeySecondStepWithVerifyString:(NSString *)verifyString {
    NSString *server = [eLongNetworkRequest sharedInstance].server;
    if (!STRINGHASVALUE(server)) {
        [self p_completion:NO];
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/commu/b", server]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:verifyString forKey:@"commuKey"];
    //添加密文-》请求body
    eLongHTTPURLEncoding *urlEncoding = [[eLongHTTPURLEncoding alloc] init];
    verifyString = [urlEncoding encoding:verifyString];
    NSString *str = [NSString stringWithFormat:@"%@=%@", @"commuKey", verifyString];
    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [self p_setRequestHeader:request];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    request.timeoutInterval = 30.0f;
    [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        if (DICTIONARYHASVALUE(responseObject)) {
            NSString *statusString = [responseObject safeObjectForKey:@"status"];
            if ([statusString isEqualToString:@"OK"]) {
                eLongNetworkDynamicCommunicationSessionDataModel *sessionDataModel = [[eLongNetworkDynamicCommunicationSessionDataModel alloc] initWithDictionary:responseObject error:nil];
                NSString *publicKeyfilePath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
                //验签
                BOOL isMatch = [eLongNetworkRSAManager verifyPlainString:sessionDataModel.sessionkey
                                                                withSign:sessionDataModel.sign
                                                    andPublicKeyFilePath:publicKeyfilePath];
                if (isMatch) {
                    //验证成功
                    self.sessionKey = sessionDataModel.sessionkey;
                    self.sessionKeyEffectivePeriod = [sessionDataModel.expiredTime longLongValue];
                    self.sessionKeyTimeInterval = [[NSDate date] timeIntervalSince1970];
                    [self p_completion:YES];
                    [self performSelector:@selector(p_refetchNegoInfo) withObject:nil afterDelay:self.sessionKeyEffectivePeriod*0.6];
                } else {
                    [self p_completion:NO];
                }
            } else {
                [self p_completion:NO];
            }
        } else {
            [self p_completion:NO];
        }
    } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [self p_completion:NO];
    }];
}

@end
