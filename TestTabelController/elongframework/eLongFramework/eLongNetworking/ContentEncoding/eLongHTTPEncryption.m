//
//  eLongHTTPEncryption.m
//
//  Created by Kirn on 2015.5.7
//

#import "eLongHTTPEncryption.h"
#import "eLongHTTPBase64Encoding.h"

@implementation eLongHTTPEncryption

CCOptions padding = kCCOptionPKCS7Padding;

+ (NSString *) encryptString:(NSString *)plainSourceStringToEncrypt {
    eLongHTTPEncryption *crypto = [[eLongHTTPEncryption alloc] init];
	NSData *_secretData = [plainSourceStringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
	NSData *encryptedData = [crypto encrypt:_secretData key:[kElongCreditCardKey dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];

    eLongHTTPBase64Encoding *base64 = [[eLongHTTPBase64Encoding alloc] init];
    return [base64 encodingData:encryptedData];
}

+ (NSString *) encryptString:(NSString *)plainSourceStringToEncrypt
                       byKey:(NSString *)customKey {
    eLongHTTPEncryption *crypto = [[eLongHTTPEncryption alloc] init];
	NSData *_secretData = [plainSourceStringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
	NSData *encryptedData = [crypto encrypt:_secretData key:[customKey dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
    eLongHTTPBase64Encoding *base64 = [[eLongHTTPBase64Encoding alloc] init];
    return [base64 encodingData:encryptedData];
}

+ (NSString *) decryptString:(NSString *)base64StringToDecrypt {
    eLongHTTPEncryption *crypto = [[eLongHTTPEncryption alloc] init];
    eLongHTTPBase64Encoding *base64 = [[eLongHTTPBase64Encoding alloc] init];
	NSData *data = [crypto decrypt:[base64 encoding:base64StringToDecrypt]
                               key:[kElongCreditCardKey dataUsingEncoding:NSUTF8StringEncoding]
                           padding: &padding];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


+ (NSString *) decryptString:(NSString *)base64StringToDecrypt
                       byKey:(NSString *)cutomKey {
    eLongHTTPEncryption *crypto = [[eLongHTTPEncryption alloc] init];
    eLongHTTPBase64Encoding *base64 = [[eLongHTTPBase64Encoding alloc] init];
    
	NSData *data = [crypto decrypt:[base64 encoding:base64StringToDecrypt]
                               key:[cutomKey dataUsingEncoding:NSUTF8StringEncoding]
                           padding: &padding];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *) encryptPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length != 11) {
        return nil;
    }
    NSRange range = NSMakeRange(3, 4);
    NSString *encryptStr = [phoneNumber stringByReplacingCharactersInRange:range withString:@"****"];
    return encryptStr;
}

- (NSData *)encrypt:(NSData *)plainText
                key:(NSData *)aSymmetricKey
            padding:(CCOptions *)pkcs7 {
    return [self doCipher:plainText key:aSymmetricKey context:kCCEncrypt padding:pkcs7];
}

- (NSData *)decrypt:(NSData *)plainText
                key:(NSData *)aSymmetricKey
            padding:(CCOptions *)pkcs7 {
    return [self doCipher:plainText key:aSymmetricKey context:kCCDecrypt padding:pkcs7];
}

- (NSData *)doCipher:(NSData *)plainText
                 key:(NSData *)aSymmetricKey
			 context:(CCOperation)encryptOrDecrypt
             padding:(CCOptions *)pkcs7 {
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
    uint8_t iv[kChosenCipherBlockSize];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
	
    plainTextBufferSize = [plainText length];
	
    // Create and Initialize the crypto reference.
    ccStatus = CCCryptorCreate(encryptOrDecrypt,
                               kCCAlgorithmAES128,
                               *pkcs7,
                               (const void *)[aSymmetricKey bytes],
                               kChosenCipherKeySize,
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

    return cipherOrPlainText;
}
@end
