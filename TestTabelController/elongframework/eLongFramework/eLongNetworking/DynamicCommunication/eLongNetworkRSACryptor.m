//
//  eLongNetworkRSACryptor.m
//  ElongClient
//
//  Created by top on 16/3/10.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongNetworkRSACryptor.h"
#import "eLongDefine.h"

#define DocumentsDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define OpenSSLRSAKeyDir [DocumentsDir stringByAppendingPathComponent:@".openssl_rsa"]

@implementation eLongNetworkRSACryptor

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // mkdir for key dir
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:OpenSSLRSAKeyDir])
        {
            [fm createDirectoryAtPath:OpenSSLRSAKeyDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

- (BOOL)generateRSAKeyPairWithKeySize:(int)keySize withFilename:(NSString *)filename {
    NSAssert(STRINGHASVALUE(filename), @"You should input filename");
    
    if (NULL != _rsa)
    {
        RSA_free(_rsa);
        _rsa = NULL;
    }
    _rsa = RSA_generate_key(keySize,RSA_F4,NULL,NULL);
    assert(_rsa != NULL);
    
    NSString *pubilcKeyfilePath = [OpenSSLRSAKeyDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.publicKey.pem", filename]];
    NSString *privateKeyfilePath = [OpenSSLRSAKeyDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.privateKey.pem", filename]];
    
    
    const char *publicKeyFileName = [pubilcKeyfilePath cStringUsingEncoding:NSASCIIStringEncoding];
    const char *privateKeyFileName = [privateKeyfilePath cStringUsingEncoding:NSASCIIStringEncoding];
    
    //写入私钥和公钥
    RSA_blinding_on(_rsa, NULL);
    
    BIO *priBio = BIO_new_file(privateKeyFileName, "w");
    PEM_write_bio_RSAPrivateKey(priBio, _rsa, NULL, NULL, 0, NULL, NULL);
    
    BIO *pubBio = BIO_new_file(publicKeyFileName, "w");
    
    
    PEM_write_bio_RSA_PUBKEY(pubBio, _rsa);
    //    PEM_write_bio_RSAPublicKey(pubBio, _rsa);
    
    BIO_free(priBio);
    BIO_free(pubBio);
    
    //分别获取公钥和私钥
    _rsaPrivate = RSAPrivateKey_dup(_rsa);
    assert(_rsaPrivate != NULL);
    
    _rsaPublic = RSAPublicKey_dup(_rsa);
    assert(_rsaPublic != NULL);
    
    if (_rsa && _rsaPublic && _rsaPrivate)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)importRSAPublicKeyBase64:(NSString *)publicKey withFilename:(NSString *)filename {
    if (!STRINGHASVALUE(publicKey) || !STRINGHASVALUE(filename)) {
        return NO;
    }
    //格式化公钥
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    int count = 0;
    for (int i = 0; i < [publicKey length]; ++i) {
        
        unichar c = [publicKey characterAtIndex:i];
        if (c == '\n' || c == '\r') {
            continue;
        }
        [result appendFormat:@"%c", c];
        if (++count == 64) {
            [result appendString:@"\n"];
            count = 0;
        }
    }
    NSString *filePath = [OpenSSLRSAKeyDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.publicKey.pem", filename]];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    }
    NSLog(@"path: %@",filePath);
    [result appendString:@"\n-----END PUBLIC KEY-----"];
    [result writeToFile:filePath
             atomically:YES
               encoding:NSASCIIStringEncoding
                  error:NULL];
    
    FILE *publicKeyFile;
    const char *publicKeyFileName = [filePath cStringUsingEncoding:NSASCIIStringEncoding];
    publicKeyFile = fopen(publicKeyFileName,"rb");
    if (NULL != publicKeyFile)
    {
        BIO *bpubkey = NULL;
        bpubkey = BIO_new(BIO_s_file());
        BIO_read_filename(bpubkey, publicKeyFileName);
        
        _rsaPublic = PEM_read_bio_RSA_PUBKEY(bpubkey, NULL, NULL, NULL);
        assert(_rsaPublic != NULL);
        BIO_free_all(bpubkey);
    }
    
    return YES;
}

- (BOOL)importRSAPrivateKeyBase64:(NSString *)privateKey withFilename:(NSString *)filename {
    NSAssert(STRINGHASVALUE(filename), @"You should input filename");
    
    //格式化私钥
    const char *pstr = [privateKey UTF8String];
    int len = (int)[privateKey length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN RSA PRIVATE KEY-----\n"];
    int index = 0;
    int count = 0;
    while (index < len) {
        char ch = pstr[index];
        if (ch == '\r' || ch == '\n') {
            ++index;
            continue;
        }
        [result appendFormat:@"%c", ch];
        if (++count == 64)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    NSString *filePath = [OpenSSLRSAKeyDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.privateKey.pem", filename]];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    }
    [result appendString:@"\n-----END RSA PRIVATE KEY-----"];
    [result writeToFile:filePath
             atomically:YES
               encoding:NSASCIIStringEncoding
                  error:NULL];
    
    FILE *privateKeyFile;
    const char *privateKeyFileName = [filePath cStringUsingEncoding:NSASCIIStringEncoding];
    privateKeyFile = fopen(privateKeyFileName,"rb");
    if (NULL != privateKeyFile)
    {
        BIO *bpubkey = NULL;
        bpubkey = BIO_new(BIO_s_file());
        BIO_read_filename(bpubkey, privateKeyFileName);
        
        _rsaPrivate = PEM_read_bio_RSAPrivateKey(bpubkey, NULL, NULL, NULL);
        assert(_rsaPrivate != NULL);
        BIO_free_all(bpubkey);
    }
    
    return YES;
}

- (void)loadRSAPublicKeyWithFilePath:(NSString *)filePath {
    FILE *publicKeyFile;
    const char *publicKeyFileName = [filePath cStringUsingEncoding:NSASCIIStringEncoding];
    publicKeyFile = fopen(publicKeyFileName,"rb");
    if (NULL != publicKeyFile)
    {
        BIO *bpubkey = NULL;
        bpubkey = BIO_new(BIO_s_file());
        BIO_read_filename(bpubkey, publicKeyFileName);
        
        _rsaPublic = PEM_read_bio_RSA_PUBKEY(bpubkey, NULL, NULL, NULL);
        assert(_rsaPublic != NULL);
        BIO_free_all(bpubkey);
    }
}

- (void)loadRSAPublicKeyWithFileName:(NSString *)fileName {
    NSString *filePath = [OpenSSLRSAKeyDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.publicKey.pem", fileName]];
    FILE *publicKeyFile;
    const char *publicKeyFileName = [filePath cStringUsingEncoding:NSASCIIStringEncoding];
    publicKeyFile = fopen(publicKeyFileName,"rb");
    if (NULL != publicKeyFile)
    {
        BIO *bpubkey = NULL;
        bpubkey = BIO_new(BIO_s_file());
        BIO_read_filename(bpubkey, publicKeyFileName);
        
        _rsaPublic = PEM_read_bio_RSA_PUBKEY(bpubkey, NULL, NULL, NULL);
        assert(_rsaPublic != NULL);
        BIO_free_all(bpubkey);
    }
}


- (NSString *)base64EncodedPublicKeyWithFilename:(NSString *)filename {
    NSAssert(STRINGHASVALUE(filename), @"You should input filename");
    NSString *filePath = [OpenSSLRSAKeyDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.publicKey.pem", filename]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath])
    {
        NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSString *string = [[str componentsSeparatedByString:@"-----"] objectAtIndex:2];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        return string;
    }
    return nil;
}

- (NSString *)base64EncodedPrivateKeyWithFilename:(NSString *)filename {
    NSAssert(STRINGHASVALUE(filename), @"You should input filename");
    NSString *filePath = [OpenSSLRSAKeyDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.privateKey.pem", filename]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath])
    {
        NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSString *string = [[str componentsSeparatedByString:@"-----"] objectAtIndex:2];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        return string;
    }
    return nil;
}

- (NSData *)encryptWithPublicKeyUsingPadding:(RSA_PADDING_TYPE)padding plainData:(NSData *)plainData {
    NSAssert(_rsaPublic != NULL, @"You should import public key first");
    
    if ([plainData length])
    {
        int len = (int)[plainData length];
        unsigned char *plainBuffer = (unsigned char *)[plainData bytes];
        
        //result len
        int clen = RSA_size(_rsaPublic);
        unsigned char *cipherBuffer = calloc(clen, sizeof(unsigned char));
        
        RSA_public_encrypt(len,plainBuffer,cipherBuffer, _rsaPublic,  padding);
        
        NSData *cipherData = [[NSData alloc] initWithBytes:cipherBuffer length:clen];
        
        free(cipherBuffer);
        
        return cipherData;
    }
    
    return nil;
}

- (NSData *)encryptWithPrivateKeyUsingPadding:(RSA_PADDING_TYPE)padding plainData:(NSData *)plainData {
    NSAssert(_rsaPrivate != NULL, @"You should import private key first");
    
    if ([plainData length])
    {
        int len = (int)[plainData length];
        unsigned char *plainBuffer = (unsigned char *)[plainData bytes];
        
        //result len
        int clen = RSA_size(_rsaPrivate);
        unsigned char *cipherBuffer = calloc(clen, sizeof(unsigned char));
        
        RSA_private_encrypt(len,plainBuffer,cipherBuffer, _rsaPrivate,  padding);
        
        NSData *cipherData = [[NSData alloc] initWithBytes:cipherBuffer length:clen];
        
        free(cipherBuffer);
        
        return cipherData;
    }
    
    return nil;
}

- (NSData *)decryptWithPrivateKeyUsingPadding:(RSA_PADDING_TYPE)padding cipherData:(NSData *)cipherData {
    NSAssert(_rsaPrivate != NULL, @"You should import private key first");
    
    if ([cipherData length])
    {
        int len = (int)[cipherData length];
        unsigned char *cipherBuffer = (unsigned char *)[cipherData bytes];
        
        //result len
        int mlen = RSA_size(_rsaPrivate);
        unsigned char *plainBuffer = calloc(mlen, sizeof(unsigned char));
        
        RSA_private_decrypt(len, cipherBuffer, plainBuffer, _rsaPrivate, padding);
        
        NSData *plainData = [[NSData alloc] initWithBytes:plainBuffer length:mlen];
        
        free(plainBuffer);
        
        return plainData;
    }
    
    return nil;
}

- (NSData *)decryptWithPublicKeyUsingPadding:(RSA_PADDING_TYPE)padding cipherData:(NSData *)cipherData {
    NSAssert(_rsaPublic != NULL, @"You should import public key first");
    
    if ([cipherData length])
    {
        //result len
        int mlen = RSA_size(_rsaPublic);
        int len = (int)[cipherData length];
        size_t blockCount = (size_t)ceil(len / mlen);
        NSMutableData *dencryptedData = [[NSMutableData alloc] init];
        
        for (int i = 0; i < blockCount; i++) {
            size_t bufferSize = MIN(mlen, len - i * mlen);
            NSData *buffer = [cipherData subdataWithRange:NSMakeRange(i * mlen, bufferSize)];
            
            unsigned char *cipherBuffer = (unsigned char *)[buffer bytes];
            
            unsigned char *plainBuffer = calloc(mlen, sizeof(unsigned char));
            
            int status =  RSA_public_decrypt((int)[buffer length], cipherBuffer, plainBuffer, _rsaPublic, padding);
            
            NSData *plainData = [[NSData alloc] initWithBytes:(const void *)plainBuffer length:status];
            [dencryptedData appendData:plainData];
            free(plainBuffer);
        }
        
        return dencryptedData;
    }
    return nil;
}

@end
