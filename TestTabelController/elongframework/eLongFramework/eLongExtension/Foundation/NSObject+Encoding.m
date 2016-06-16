//
//  NSObject+Encoding.m
//  MyElong
//
//  Created by yangfan on 15/6/17.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "NSObject+Encoding.h"
#import "JSONKit.h"
#import <objc/runtime.h>
#import "NSMutableDictionary+SafeForObject.h"

@implementation NSObject (Encoding)

- (NSUInteger)safeCount
{
    if ([self isKindOfClass:[NSArray class]])
    {
        return [(NSArray *)self count];
    }
    else if ([self isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)self count];
    }
    else
    {
        return 0;
    }
}


- (NSString *)JSONRepresentation {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)self JSONString];
    }
    else if ([self isKindOfClass:[NSArray class]]) {
        return [(NSArray *)self JSONString];
    }
    else if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self JSONString];
    }
    
    return nil;
}


- (NSString *)JSONRepresentationWithURLEncoding {
    CFStringRef cfResult = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                   (CFStringRef)[self JSONRepresentation],
                                                                   NULL,
                                                                   CFSTR("&=@;!'*#%-,:/()<>[]{}?+ "),
                                                                   kCFStringEncodingUTF8);
    
    if (cfResult) {
        NSString *result = [NSString stringWithString:(__bridge NSString *)cfResult];
        CFRelease(cfResult);
        return result;
    }
    
    return @"";
}


// 成员变量转换成字典
- (void)serializeSimpleObject:(NSMutableDictionary *)dictionary
{
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    // 获取property
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        // 获取对象
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
        if(iVar == nil)
        {
            // 采用另外一种方法尝试获取
            iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
        }
        
        // 赋值
        if(iVar != nil)
        {
            id propertyValue = object_getIvar(self, iVar);
            
            // 插入Dictionary中
            if(propertyValue != nil)
            {
                [dictionary safeSetObject:propertyValue forKey:propertyName];
            }
        }
    }
    
    free(properties);
}

@end
