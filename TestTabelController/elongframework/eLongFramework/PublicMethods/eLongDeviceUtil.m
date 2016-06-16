//
//  eLongDeviceUtil.m
//  MyElong
//
//  Created by yangfan on 15/6/26.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "eLongDeviceUtil.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "eLongDefine.h"
#import "eLongKeyChain.h"
#import "KeychainItemWrapper.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "eLongCONST.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "eLongDebugManager.h"

static NSString *keychain_guid = nil;

@implementation eLongDeviceUtil

+ (NSString *)macaddress {
//    if (IOSVersion_7) {
        NSString *guid = [self GetGUIDString];
        return guid;
//    }else{
//        int                 mib[6];
//        size_t              len;
//        char                *buf;
//        unsigned char       *ptr;
//        struct if_msghdr    *ifm;
//        struct sockaddr_dl  *sdl;
//        
//        mib[0] = CTL_NET;
//        mib[1] = AF_ROUTE;
//        mib[2] = 0;
//        mib[3] = AF_LINK;
//        mib[4] = NET_RT_IFLIST;
//        
//        if ((mib[5] = if_nametoindex("en0")) == 0) {
//            printf("Error: if_nametoindex error\n");
//            return NULL;
//        }
//        
//        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//            printf("Error: sysctl, take 1\n");
//            return NULL;
//        }
//        
//        if ((buf = malloc(len)) == NULL) {
//            printf("Could not allocate memory. error!\n");
//            return NULL;
//        }
//        
//        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//            printf("Error: sysctl, take 2");
//            free(buf);
//            return NULL;
//        }
//        
//        ifm = (struct if_msghdr *)buf;
//        sdl = (struct sockaddr_dl *)(ifm + 1);
//        ptr = (unsigned char *)LLADDR(sdl);
//        NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
//                               *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//        free(buf);
//        
//        if (!STRINGHASVALUE(outstring))
//        {
//            outstring = [self GetGUIDString];
//        }
//        
//        return outstring;
//        
//    }
}

+ (NSString *)device
{
    static NSString *modelString = nil;
    if (modelString) {
        return modelString;
    }
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    char *modelKey = "hw.machine";
#else
    char *modelKey = "hw.model";
#endif
    size_t size;
    sysctlbyname(modelKey, NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname(modelKey, model, &size, NULL, 0);
    modelString = [[NSString stringWithUTF8String:model] copy];
    free(model);
    return modelString;
}

+ (NSString *)GetGUIDString
{
    if (STRINGHASVALUE(keychain_guid)) {
        return keychain_guid;
    }
    
    if ([eLongDebugManager deviceIdInstance].enabled) {
        NSString *deviceId = [eLongDebugManager deviceIdInstance].deviceid;
        if (STRINGHASVALUE(deviceId)) {
            keychain_guid = deviceId;
            return keychain_guid;
        }
    }
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_GUID accessGroup:nil];
    
    //从keychain里取出GUID
    keychain_guid = [[wrapper objectForKey:(id)CFBridgingRelease(kSecValueData)] copy];
    if (STRINGHASVALUE(keychain_guid)) {
        if ([eLongDebugManager deviceIdInstance].enabled) {
            NSString *deviceId = [eLongDebugManager deviceIdInstance].deviceid;
            if (!STRINGHASVALUE(deviceId)) {
                [[eLongDebugManager deviceIdInstance] addDeviceIdName:@"" deviceid:keychain_guid];
            }
        }

        return keychain_guid;
    }else{
        // 从文件读取
        keychain_guid = [[eLongUserDefault objectForKey:USERDEFAULT_KEYCHAIN_GUID] copy];
        if (STRINGHASVALUE(keychain_guid)) {
            if ([eLongDebugManager deviceIdInstance].enabled) {
                NSString *deviceId = [eLongDebugManager deviceIdInstance].deviceid;
                if (!STRINGHASVALUE(deviceId)) {
                    [[eLongDebugManager deviceIdInstance] addDeviceIdName:@"" deviceid:keychain_guid];
                }
            }
            return keychain_guid;
        }else{
            keychain_guid = [[self GUIDString] copy];
            [wrapper setObject:keychain_guid forKey:(__bridge id)kSecValueData];
            
            wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_GUID accessGroup:nil];
            keychain_guid = [[wrapper objectForKey:(__bridge id)kSecValueData] copy];
            if (STRINGHASVALUE(keychain_guid)) {
                if ([eLongDebugManager deviceIdInstance].enabled) {
                    [[eLongDebugManager deviceIdInstance] addDeviceIdName:@"" deviceid:keychain_guid];
                }
                return keychain_guid;
            }else{
                keychain_guid = [[self GUIDString] copy];
                [eLongUserDefault setObject:keychain_guid forKey:USERDEFAULT_KEYCHAIN_GUID];
                if ([eLongDebugManager deviceIdInstance].enabled) {
                    [[eLongDebugManager deviceIdInstance] addDeviceIdName:@"" deviceid:keychain_guid];
                }
                return keychain_guid;
            }
        }
    }
}

+ (NSString*)GUIDString {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    //    return (__bridge NSString *)string;
    return (NSString *)CFBridgingRelease(string);
}

+ (void)showAvailableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    if(kernReturn != KERN_SUCCESS) return;
    
    double availableNum = ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
    NSLog(@"<<%.f M can be used>>",availableNum);
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    //    NSLog(@"手机的IP是：%@", address);
    
    return address;
}
@end
