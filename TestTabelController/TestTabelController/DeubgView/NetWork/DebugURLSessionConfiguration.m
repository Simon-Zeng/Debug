//
//  DebugURLSessionConfiguration.m
//  TestTabelController
//
//  Created by 王智刚 on 16/7/3.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugURLSessionConfiguration.h"
#import "DebugHttpMonitor.h"
#import <objc/runtime.h>

@interface DebugURLSessionConfiguration ()

@end

@implementation DebugURLSessionConfiguration
#pragma mark - public Mehtod
+ (DebugURLSessionConfiguration *)defaultConfiguration
{
    static DebugURLSessionConfiguration *configuration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuration = [[DebugURLSessionConfiguration alloc]init];
    });
    return configuration;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.swizzle = NO;
    }
    return self;
}
- (void)load
{
    self.swizzle = YES;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ? :NSClassFromString(@"__NSCFURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
}

- (void)unload
{
    self.swizzle = NO;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ? :NSClassFromString(@"__NSCFURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:[self class] toClass:cls];

}
#pragma mark - private Mehtod
- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub
{
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod= class_getInstanceMethod(stub, selector);

    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
//    NSAssert(!originalMethod || !stubMethod, @"方法不存在");
    
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses
{
    return @[[DebugHttpMonitor class]];
}
#pragma mark - property

@end
