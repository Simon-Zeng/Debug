//
//  eLongNetworkRSAManager.m
//  ElongClient
//
//  Created by top on 16/2/29.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongNetworkRSAManager.h"
#import <Security/Security.h>
#include <CommonCrypto/CommonDigest.h>
#import "eLongDefine.h"

@interface eLongNetworkRSAManager ()

@end

@implementation eLongNetworkRSAManager

NSString *base64Encode_data(NSData *data) {
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

NSData *base64Decode(NSString *str) {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

+ (NSData *)base64DecodeWithString:(NSString *)string {
    return base64Decode(string);
}

+ (NSString *)base64EncodeWithData:(NSData *)data {
    return base64Encode_data(data);
}

+ (BOOL)verifyPlainString:(NSString *)plainString withSign:(NSString *)sign andPublicKeyFilePath:(NSString *)filePath {
    NSData *plainData = [[NSData alloc] initWithBase64EncodedString:plainString
                                                            options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *signData = [[NSData alloc] initWithBase64EncodedString:sign
                                                           options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return PKCSVerifyBytesSHA256withRSA(plainData, signData, [eLongNetworkRSAManager publicKeyWithFilePath:filePath]);
}

BOOL PKCSVerifyBytesSHA256withRSA(NSData* plainData, NSData* signature, SecKeyRef publicKey) {
    if (!publicKey) {
        return NO;
    }
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKey);
    const void* signedHashBytes = [signature bytes];
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
    }
    
    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA256,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}


+ (SecKeyRef)publicKeyWithFilePath:(NSString *)filePath {
    SecKeyRef _public_key = nil;
    if (_public_key == nil && STRINGHASVALUE(filePath)) {
        NSData *certificateData = [NSData dataWithContentsOfFile:filePath];
        SecCertificateRef myCertificate =  SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData);
        if (myCertificate == nil) {
            return nil;
        }
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        SecTrustRef myTrust;
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        SecTrustResultType trustResult;
        if (status == noErr) {
            status = SecTrustEvaluate(myTrust, &trustResult);
        } else {
            return nil;
        }
        _public_key = SecTrustCopyPublicKey(myTrust);
        CFRelease(myCertificate);
        CFRelease(myPolicy);
        CFRelease(myTrust);
    }
    return _public_key;
}

@end
