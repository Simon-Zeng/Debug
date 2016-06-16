//
//  eLongHTTPAESEncoding.m
//  eLongNetworking
//
//  Created by Dawn on 14-12-1.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongHTTPAESEncoding.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "eLongHTTPBase64Encoding.h"

#define kChosenCipherBlockSize_	kCCBlockSizeAES128
#define kChosenCipherKeySize_	kCCKeySizeAES128
CCOptions padding_ = kCCOptionPKCS7Padding;

@implementation eLongHTTPAESEncoding
- (NSString *)encryptString:(NSString *)string byKey:(NSString *)key{
    
    NSData *plainText = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aSymmetricKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    CCOperation encryptOrDecrypt = kCCEncrypt;
    CCOptions *pkcs7 = &padding_;
    
    CCCryptorStatus ccStatus = kCCSuccess;
    // Symmetric crypto reference.
    CCCryptorRef thisEncipher = NULL;
    // Cipher Text container.
    NSData * cipherOrPlainText = nil;
    // Pointer to output buffer.
    uint8_t * bufferPtr = NULL;
    // Total size of the buffer.
    size_t bufferPtrSize = 0;
    // Remaining bytes to be performed on.
    size_t remainingBytes = 0;
    // Number of bytes moved to buffer.
    size_t movedBytes = 0;
    // Length of plainText buffer.
    size_t plainTextBufferSize = 0;
    // Placeholder for total written.
    size_t totalBytesWritten = 0;
    // A friendly helper pointer.
    uint8_t * ptr;
    
    // Initialization vector; dummy in this case 0's.
    uint8_t iv[kChosenCipherBlockSize_];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    plainTextBufferSize = [plainText length];
    
    // Create and Initialize the crypto reference.
    ccStatus = CCCryptorCreate(encryptOrDecrypt,
                               kCCAlgorithmAES128,
                               *pkcs7,
                               (const void *)[aSymmetricKey bytes],
                               kChosenCipherKeySize_,
                               (const void *)iv,
                               &thisEncipher
                               );
    
    // Calculate byte block alignment for all calls through to and including final.
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
    
    // Allocate buffer.
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
    
    // Zero out buffer.
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    // Initialize some necessary book keeping.
    
    ptr = bufferPtr;
    
    // Set up initial size.
    remainingBytes = bufferPtrSize;
    
    // Actually perform the encryption or decryption.
    ccStatus = CCCryptorUpdate(thisEncipher,
                               (const void *) [plainText bytes],
                               plainTextBufferSize,
                               ptr,
                               remainingBytes,
                               &movedBytes
                               );
    
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;
    
    ccStatus = CCCryptorFinal(thisEncipher,
                              ptr,
                              remainingBytes,
                              &movedBytes
                              );
    
    totalBytesWritten += movedBytes;
    
    if(thisEncipher) {
        (void) CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }
    
    if (ccStatus == kCCSuccess)
        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
    else
        cipherOrPlainText = nil;
    
    if(bufferPtr) free(bufferPtr);
    
    eLongHTTPBase64Encoding *base64Encoding = [[eLongHTTPBase64Encoding alloc] init];
    return [base64Encoding encodingData:cipherOrPlainText];
}
@end
