//
//  eLongDeviceUtil.h
//  MyElong
//
//  Created by yangfan on 15/6/26.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongDeviceUtil : NSObject

// 返回mac地址
+ (NSString *)macaddress;

// 设备类型
+ (NSString *)device;

// 显示当前还有多少内存可用
+ (void)showAvailableMemory;

// 获取一个GUID字符串
+ (NSString*)GUIDString;

// 获取IP地址
+ (NSString *)deviceIPAdress;

@end
