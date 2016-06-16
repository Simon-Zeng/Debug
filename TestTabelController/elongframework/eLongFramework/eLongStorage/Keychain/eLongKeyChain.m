//
//  eLongKeyChain.m
//  ElongClient
//
//  Created by top on 15/4/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongKeyChain.h"
#import "KeychainItemWrapper.h"
#import "NSString+eLongExtension.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#undef	DEFAULT_DOMAIN
#define DEFAULT_DOMAIN	@"default."


static NSString *keychain_guid = nil;

@interface NSString (CheckSting)

- (BOOL)hasValue;

@end

@implementation NSString (CheckSting)

- (BOOL)hasValue{
    if (self && [self isKindOfClass:[NSString class]] && [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        return YES;
    }
    return NO;
}

@end

@interface eLongKeyChain () {
    NSString *_defaultDomain;
}

@property (nonatomic, copy, readwrite) NSString *defaultDomain;

- (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain;

- (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain;

@end

@implementation eLongKeyChain

+ (instancetype)sharedInstance {
    static eLongKeyChain *_eLongKeyChain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _eLongKeyChain = [[eLongKeyChain alloc] init];
    });
    return _eLongKeyChain;
}

- (id)init {
    self = [super init];
    if (self){
        self.defaultDomain = DEFAULT_DOMAIN;
    }
    return self;
}

+ (void)setDefaultDomain:(NSString *)domain {
    [[eLongKeyChain sharedInstance] setDefaultDomain:domain];
}

+ (NSString *)readValueForKey:(NSString *)key {
    return [[eLongKeyChain sharedInstance] readValueForKey:key andDomain:nil];
}

+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain {
    return [[eLongKeyChain sharedInstance] readValueForKey:key andDomain:domain];
}

- (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain {
    if ( nil == key )
        return nil;
    
    if ( nil == domain ) {
        domain = self.defaultDomain;
        if ( nil == domain ){
            domain = DEFAULT_DOMAIN;
        }
    }
    domain = [domain stringByAppendingString:[self appIdentifier]];
    
    NSArray * keys = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil];
    NSArray * objects = [[NSArray alloc] initWithObjects: (__bridge NSString *) kSecClassGenericPassword, key, domain, nil];
    
    NSMutableDictionary * query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
    NSMutableDictionary * attributeQuery = [query mutableCopy];
    [attributeQuery setObject: (id) kCFBooleanTrue forKey:(__bridge id) kSecReturnAttributes];
    
    CFDataRef attributeResult = NULL;
    OSStatus status = SecItemCopyMatching( (__bridge CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult );
    
    
    
    
    if ( noErr != status )
        return nil;
    
    NSMutableDictionary * passwordQuery = [query mutableCopy];
    [passwordQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFDataRef resultData = nil;
    status = SecItemCopyMatching( (__bridge CFDictionaryRef)passwordQuery, (CFTypeRef *)&resultData );
    
    
    if ( noErr != status )
        return nil;
    
    if ( nil == resultData )
        return nil;
    
    NSString * password = [[NSString alloc] initWithData:(__bridge_transfer NSData *)resultData encoding:NSUTF8StringEncoding];
    return password;
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key {
    [[eLongKeyChain sharedInstance] writeValue:value forKey:key andDomain:nil];
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain {
    [[eLongKeyChain sharedInstance] writeValue:value forKey:key andDomain:domain];
}

- (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain {
    if ( nil == key )
        return;
    
    if ( nil == value ) {
        value = @"";
    }
    
    if ( nil == domain ) {
        domain = self.defaultDomain;
        if ( nil == domain ) {
            domain = DEFAULT_DOMAIN;
        }
    }
    
    domain = [domain stringByAppendingString:[self appIdentifier]];
    
    NSString *existedValue = [self readValueForKey:key andDomain:nil];
    
    if (existedValue) {
        if ( [existedValue isEqualToString:value] )
            return;
        
        NSArray * keys = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, nil];
        NSArray * objects = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClassGenericPassword, domain, domain, key, nil];
        
        NSDictionary * query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        SecItemUpdate( (__bridge  CFDictionaryRef)query, (__bridge  CFDictionaryRef)[NSDictionary dictionaryWithObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge NSString *)kSecValueData] );
    } else {
        NSArray * keys = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, kSecValueData, nil];
        NSArray * objects = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClassGenericPassword, domain, domain, key, [value dataUsingEncoding:NSUTF8StringEncoding], nil];
        
        NSDictionary * query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
        SecItemAdd( (__bridge CFDictionaryRef)query, NULL);
    }
}

+ (void)deleteValueForKey:(NSString *)key {
    [[eLongKeyChain sharedInstance] deleteValueForKey:key andDomain:nil];
}

+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain {
    [[eLongKeyChain sharedInstance] deleteValueForKey:key andDomain:domain];
}

- (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain {
    if ( nil == key )
        return;
    
    if ( nil == domain ) {
        domain = self.defaultDomain;
        if ( nil == domain ) {
            domain = DEFAULT_DOMAIN;
        }
    }
    
    domain = [domain stringByAppendingString:[self appIdentifier]];
    
    NSArray * keys = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
    NSArray * objects = [[NSArray alloc] initWithObjects:(__bridge NSString *)kSecClassGenericPassword, key, domain, kCFBooleanTrue, nil];
    
    NSDictionary * query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    SecItemDelete( (__bridge CFDictionaryRef)query );
}

#pragma mark - AppIdentifier
- (NSString *)appIdentifier {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    static NSString * __identifier = nil;
    if ( nil == __identifier ) {
        __identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    }
    return __identifier;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return @"";
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

#pragma mark - GUIDString & macaddress
+ (NSString *)GUIDString {
    if ([keychain_guid notEmpty]) {
        return keychain_guid;
    }
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"GUID" accessGroup:nil];
    //从keychain里取出GUID
    keychain_guid = [[wrapper objectForKey:(__bridge id)kSecValueData] copy];
    if ([keychain_guid hasValue]) {
        return keychain_guid;
    }else{
        // 从文件读取
        keychain_guid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ELONG_GUID"] copy];
        if ([keychain_guid hasValue]) {
            return keychain_guid;
        }else{
            keychain_guid = [[eLongKeyChain createGUIDString] copy];
            [wrapper setObject:keychain_guid forKey:(__bridge id)kSecValueData];
            wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"GUID" accessGroup:nil];
            keychain_guid = [[wrapper objectForKey:(__bridge id)kSecValueData] copy];
            if ([keychain_guid hasValue]) {
                return keychain_guid;
            }else{
                keychain_guid = [[eLongKeyChain createGUIDString] copy];
                [[NSUserDefaults standardUserDefaults] setObject:keychain_guid forKey:@"ELONG_GUID"];
                return keychain_guid;
            }
        }
    }
}

+ (NSString *)createGUIDString {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (NSString *)CFBridgingRelease(string);
}

+ (NSString *)macAddress {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSString *guid = [self GUIDString];
        return guid;
    }else{
        int                 mib[6];
        size_t              len;
        char                *buf;
        unsigned char       *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl  *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            printf("Error: if_nametoindex error\n");
            return NULL;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 1\n");
            return NULL;
        }
        
        if ((buf = malloc(len)) == NULL) {
            printf("Could not allocate memory. error!\n");
            return NULL;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 2");
            free(buf);
            return NULL;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                               *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        free(buf);
        
        
        if ([outstring empty]) {
            outstring = [self GUIDString];
        }
        
        return outstring;
        
    }
}

@end
