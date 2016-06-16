//
//  eLongNetworkRSAManager.h
//  ElongClient
//
//  Created by top on 16/2/29.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongNetworkRSAManager : NSObject

+ (NSData *)base64DecodeWithString:(NSString *)string;

+ (NSString *)base64EncodeWithData:(NSData *)data;

+ (BOOL)verifyPlainString:(NSString *)plainString
                 withSign:(NSString *)sign
     andPublicKeyFilePath:(NSString *)filePath;


@end
