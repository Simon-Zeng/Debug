//
//  eLongHTTPEncryption.h
//
//  Created by Kirn on 2015.5.7
//
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


#define kChosenCipherBlockSize	kCCBlockSizeAES128
#define kChosenCipherKeySize	kCCKeySizeAES128
#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH

#define kElongCreditCardKey		@"1234567891123456"
//#define kElongCreditCardKey		@"1234567890123456"

@interface eLongHTTPEncryption : NSObject
/**
 *  使用默认密钥加密字符串
 *
 *  @param plainSourceStringToEncrypt 原始字符串
 *
 *  @return 加密后字符串
 */
+ (NSString *) encryptString:(NSString *)plainSourceStringToEncrypt;

/**
 *  使用自定义密钥加密字符串
 *
 *  @param plainSourceStringToEncrypt 原始字符串
 *  @param cutomKey                   加密密钥
 *
 *  @return 加密后字符串
 */
+ (NSString *) encryptString:(NSString *)plainSourceStringToEncrypt
                       byKey:(NSString *)cutomKey;
/**
 *  使用默认密钥解密字符串
 *
 *  @param base64StringToDecrypt 加密后的字符串
 *
 *  @return 解密后的字符串
 */
+ (NSString *) decryptString:(NSString *) base64StringToDecrypt;
/**
 *  使用默认密钥解密字符串
 *
 *  @param base64StringToDecrypt 加密后字符串
 *  @param cutomKey              解密密钥
 *
 *  @return 解密后字符串
 */
+ (NSString *) decryptString:(NSString *)base64StringToDecrypt
                       byKey:(NSString *)cutomKey;
/**
 *  加密手机号，后三位变为***
 *
 *  @param phoneNumber 原始手机号
 *
 *  @return 加密后手机号
 */
+ (NSString *) encryptPhoneNumber:(NSString *)phoneNumber;
@end
