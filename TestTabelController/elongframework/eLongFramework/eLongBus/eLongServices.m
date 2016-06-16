//
//  eLongServices.m
//  ElongClient
//
//  Created by Kirn on 15/4/21.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongServices.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSMutableDictionary *servicesMap = nil;
static NSString *serviceProtocol    = @"eLongServiceProtocol";
static NSString *serviceClass       = @"eLongServiceClass";
static NSString *serviceSingleton   = @"eLongServiceSingleton";

@implementation eLongServices
+ (instancetype) services{
    static eLongServices *services;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        services = [[eLongServices alloc] init];
        servicesMap = [[NSMutableDictionary alloc] init];
    });
    return services;
}

+ (void) addService:(NSString *)service class:(NSString *)className protocol:(NSString *)protocol singleton:(BOOL)singleton{
    [[eLongServices services] addService:service class:className protocol:protocol singleton:singleton];
}

- (void) addService:(NSString *)service class:(NSString *)className protocol:(NSString *)protocol singleton:(BOOL)singleton{
    [servicesMap setValue:@{
                            serviceProtocol:protocol,
                            serviceClass:className,
                            serviceSingleton:@(singleton)
                            } forKey:service];
}

+ (void) callService:(NSString *)service,...{
    va_list args;
    va_start(args, service);
    [[eLongServices services] callService:service arguments:args];
    va_end(args);
}

- (void) callService:(NSString *)service arguments:(va_list)argList{
    if (!service || ![servicesMap objectForKey:service]) {
        return;
    }
    NSString *protocol = [[servicesMap objectForKey:service] objectForKey:serviceProtocol];
    NSString *class = [[servicesMap objectForKey:service] objectForKey:serviceClass];
    BOOL singleton = [[[servicesMap objectForKey:service] objectForKey:serviceSingleton] boolValue];
    Class sClass = NSClassFromString(class);
    Protocol *sProtocol = NSProtocolFromString(protocol);
    if (!sClass || !sProtocol) {
        return;
    }
    
    // 解析服务协议
    SEL method = [self methodsOfProtocol:sProtocol class:sClass];
    if (method) {
        NSMutableArray *argArray = [NSMutableArray array];
        id arg = nil;
        while ((arg = va_arg(argList, id))) {
            [argArray addObject:arg];
        }
        if (singleton) {
            // 单例
            id obj = nil;
            SEL sel = NSSelectorFromString(@"serviceInstance");
            if (sel) {
                typedef id (*send_type)(id, SEL);
                send_type imp = (send_type)[sClass methodForSelector:sel];
                obj = imp(sClass, sel);
            }
            if (!obj) {
                obj = [[sClass alloc] init];
            }
            [self callMethod:method args:argArray obj:obj];
        }else{
            // 实例
            id obj = [[sClass alloc] init];
            [self callMethod:method args:argArray obj:obj];
        }
    }
}

- (void) callMethod:(SEL)method args:(NSArray *)args obj:(id)obj{
    if (args.count) {
        switch (args.count) {
            case 1:{
                ((void(*)(id, SEL, id))objc_msgSend)(obj, method,[args objectAtIndex:0]);
            }
                break;
            case 2:{
                ((void(*)(id, SEL, id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1]);
            }
                break;
            case 3:{
                ((void(*)(id, SEL, id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2]);
            }
                break;
            case 4:{
                ((void(*)(id, SEL, id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3]);
            }
                break;
            case 5:{
                ((void(*)(id, SEL, id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4]);
            }
                break;
            case 6:{
                ((void(*)(id, SEL, id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5]);
            }
                break;
            case 7:{
                ((void(*)(id, SEL, id,id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5],[args objectAtIndex:6]);
            }
                break;
            case 8:{
                ((void(*)(id, SEL, id,id,id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5],[args objectAtIndex:6],[args objectAtIndex:7]);
            }
                break;
            case 9:{
                ((void(*)(id, SEL, id,id,id,id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5],[args objectAtIndex:6],[args objectAtIndex:7],[args objectAtIndex:8]);
            }
                break;
            case 10:{
                ((void(*)(id, SEL, id,id,id,id,id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5],[args objectAtIndex:6],[args objectAtIndex:7],[args objectAtIndex:8],[args objectAtIndex:9]);
            }
                break;

            default:
                break;
        }
    }
    else if (obj && method){
        ((void(*)(id, SEL))objc_msgSend)(obj, method);
    }
}

- (SEL) methodsOfProtocol:(Protocol *)protocol class:(Class)className{
    SEL method = NULL;
    struct objc_method_description *methods = NULL;
    unsigned int outCount = 0;
    methods = protocol_copyMethodDescriptionList(protocol, YES, YES, &outCount);
    if (outCount) {
        method = methods[0].name;
    }
    if (methods) {
        free(methods);
        methods = NULL;
    }
    return method;
}

+ (id)callServiceHasReturnValue:(NSString *)service,...{
    va_list args;
    va_start(args, service);
    id returnValue = [[eLongServices services] callServiceHasReturnValue:service arguments:args];
    va_end(args);
    
    return returnValue;
}

- (id)callServiceHasReturnValue:(NSString *)service arguments:(va_list)argList{
    
    id returnValue = nil;
    
    if (!service || ![servicesMap objectForKey:service]) {
        return returnValue;
    }
    NSString *protocol = [[servicesMap objectForKey:service] objectForKey:serviceProtocol];
    NSString *class = [[servicesMap objectForKey:service] objectForKey:serviceClass];
    BOOL singleton = [[[servicesMap objectForKey:service] objectForKey:serviceSingleton] boolValue];
    Class sClass = NSClassFromString(class);
    Protocol *sProtocol = NSProtocolFromString(protocol);
    if (!sClass || !sProtocol) {
        return returnValue;
    }
    
    // 解析服务协议
    SEL method = [self methodsOfProtocol:sProtocol class:sClass];
    if (method) {
        NSMutableArray *argArray = [NSMutableArray array];
        id arg = nil;
        while ((arg = va_arg(argList, id))) {
            [argArray addObject:arg];
        }
        if (singleton) {
            // 单例
            id obj = nil;
            SEL sel = NSSelectorFromString(@"serviceInstance");
            if (sel) {
                typedef id (*send_type)(id, SEL);
                send_type imp = (send_type)[sClass methodForSelector:sel];
                obj = imp(sClass, sel);
            }
            if (!obj) {
                obj = [[sClass alloc] init];
            }
            returnValue = [self callMethodHasReturnValue:method args:argArray obj:obj];
        }else{
            // 实例
            id obj = [[sClass alloc] init];
            returnValue = [self callMethodHasReturnValue:method args:argArray obj:obj];
        }
    }
    
    return returnValue;
}

- (id)callMethodHasReturnValue:(SEL)method args:(NSArray *)args obj:(id)obj{
    
    id returnValue = nil;
    
    if (args.count) {
        switch (args.count) {
            case 1:{
                returnValue = ((id(*)(id, SEL, id))objc_msgSend)(obj, method,[args objectAtIndex:0]);
            }
                break;
            case 2:{
                returnValue = ((id(*)(id, SEL, id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1]);
            }
                break;
            case 3:{
                returnValue = ((id(*)(id, SEL, id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2]);
            }
                break;
            case 4:{
                returnValue = ((id(*)(id, SEL, id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3]);
            }
                break;
            case 5:{
                returnValue = ((id(*)(id, SEL, id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4]);
            }
                break;
            case 6:{
                returnValue = ((id(*)(id, SEL, id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5]);
            }
                break;
            case 7:{
                returnValue = ((id(*)(id, SEL, id,id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5],[args objectAtIndex:6]);
            }
                break;
            case 8:{
                returnValue = ((id(*)(id, SEL, id,id,id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5],[args objectAtIndex:6],[args objectAtIndex:7]);
            }
                break;
            case 9:{
                returnValue = ((id(*)(id, SEL, id,id,id,id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5],[args objectAtIndex:6],[args objectAtIndex:7],[args objectAtIndex:8]);
            }
                break;
            case 10:{
                returnValue = ((id(*)(id, SEL, id,id,id,id,id,id,id,id,id,id))objc_msgSend)(obj, method,[args objectAtIndex:0],[args objectAtIndex:1],[args objectAtIndex:2],[args objectAtIndex:3],[args objectAtIndex:4],[args objectAtIndex:5],[args objectAtIndex:6],[args objectAtIndex:7],[args objectAtIndex:8],[args objectAtIndex:9]);
            }
                break;
                
            default:
                break;
        }
    }
    else if (obj && method){
        
        returnValue = ((id(*)(id, SEL))objc_msgSend)(obj, method);
    }
    
    return returnValue;
}

@end
