//
//  eLongNetworkDynamicCommunication.h
//  ElongClient
//
//  Created by top on 16/2/26.
//  Copyright © 2016年 elong. All rights reserved.
//  AES加密动态通信

#import <Foundation/Foundation.h>

typedef void(^CommunicationCompletionBlock)(BOOL isSuccessFul);

@interface eLongNetworkDynamicCommunication : NSObject

+ (instancetype)sharedInstance;

- (void)startCommunicationWithCompletion:(CommunicationCompletionBlock)completion;

- (BOOL)checkApiTitleEnabled:(NSString *)apiTitle;

- (NSString *)fetchSessionKey;

- (NSString *)fetchAesKey;

@end
