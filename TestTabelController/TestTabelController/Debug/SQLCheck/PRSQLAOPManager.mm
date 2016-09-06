//
//  PRSQLAOPManager.m
//  TestTabelController
//
//  Created by wzg on 16/9/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "PRSQLAOPManager.h"
#import "Aspects.h"
#import "EXTScope.h"
#import <QuartzCore/QuartzCore.h>
#import "PRGlobalDefines.h"
#import "PRTimer.h"
#import <objc/runtime.h>
#import "ViewController.h"

#if defined(__cplusplus)
extern "C" {
#endif
    NS_INLINE id testMethod_aop(id self,SEL selector);
#if defined(__cplusplus)
}
#endif
@implementation PRSQLAOPManager

+ (void)aopFMDBQuery
{
    do {
        Class cls = NSClassFromString(@"ViewController");
        if (!cls) {
            //输出错误信息到控制台
            fprintf(stderr, "没有fmdb这个库\n");
            break;
        }
        
        __block CFTimeInterval beginT;
        __block CFTimeInterval endT;
//        [cls aspect_hookSelector:@selector(executeUpdate:error:withArgumentsInArray:orDictionary:orVAList:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
//            self.begin = CACurrentMediaTime();
//        } error:NULL];
//
//        
//        [cls aspect_hookSelector:@selector(executeUpdate:error:withArgumentsInArray:orDictionary:orVAList:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
//            self.end = CACurrentMediaTime();
//        } error:NULL];

//        [cls aspect_hookSelector:@selector(testMethod) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
//            self.begin = CACurrentMediaTime();
//        } error:NULL];
//        
//        
//        [cls aspect_hookSelector:@selector(testMethod) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
//            self.end = CACurrentMediaTime();
//        } error:NULL];
        
        class_addMethod(cls,
                        @selector(testMethod_aop),
                        (IMP)testMethod_aop,
                        "@@:@@@*");
        [self aopInstanceMethodWithOriClass:cls
                                             oriSEL:@selector(testMethod)
                                           aopClass:cls
                                             aopSEL:@selector(testMethod_aop)];

//        [cls aspect_hookSelector:@selector(testMethod) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
//            [[aspectInfo originalInvocation] invoke];
//        } error:NULL];
        
//        NSLog(@"sql执行时间:%zi",endT - beginT);
        
    } while (0);
}
+ (void)aopInstanceMethodWithOriClass:(Class)oriClass oriSEL:(SEL)oriSelector aopClass:(Class)aopClass aopSEL:(SEL)aopSelector
{
    Method oriMethod = class_getInstanceMethod(oriClass, oriSelector);
    // class_addMethod will fail if original method already exists
    Method aopMethod = class_getInstanceMethod(aopClass, aopSelector);
    
    BOOL didAddMethod = class_addMethod(oriClass, oriSelector, method_getImplementation(aopMethod), method_getTypeEncoding(aopMethod));
    if (didAddMethod) { // the method doesn’t exist and we just added one
        class_replaceMethod(oriClass, aopSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }
    else {
        class_addMethod(oriClass, aopSelector, method_getImplementation(aopMethod), method_getTypeEncoding(aopMethod));
        method_exchangeImplementations(oriMethod, aopMethod);
    }
}

+ (void)aopClassMethodWithOriClass:(Class)oriClass oriSEL:(SEL)oriSelector aopClass:(Class)aopClass aopSEL:(SEL)aopSelector
{
    Method oriMethod = class_getClassMethod(oriClass, oriSelector);
    assert(oriMethod);
    // class_addMethod will fail if original method already exists
    Method aopMethod = class_getClassMethod(aopClass, aopSelector);
    assert(aopMethod);
    
    BOOL didAddMethod = class_addMethod(oriClass, oriSelector, method_getImplementation(aopMethod), method_getTypeEncoding(aopMethod));
    if (!didAddMethod) { // the method doesn’t exist and we just added one
        class_replaceMethod(oriClass, aopSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }
    else {
        method_exchangeImplementations(oriMethod, aopMethod);
    }
}

@end


#if defined(__cplusplus)
extern "C" {
#endif
    NS_INLINE id testMethod_aop(id self,SEL selector)
    {
        NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = self;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        invocation.selector = @selector(testMethod_aop);
#pragma clang diagnostic pop
        static PRTimer *timer = [](){
            PRTimer *timer = [[PRTimer alloc]init];
            [timer start];
            return timer;
        }();
        [timer restart];
        [invocation invoke];
        id ret = nil;
        id obj;
//        void *ret_p = (__bridge void *)ret;
        [invocation getReturnValue:&obj];
        
        NSTimeInterval intervarl = [timer interval];
        NSLog(@"方法花费的时间:%zi",intervarl);
        return  ret;
    }
#if defined(__cplusplus)
}
#endif