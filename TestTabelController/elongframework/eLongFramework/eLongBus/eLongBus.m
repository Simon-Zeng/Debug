//
//  eLongBus.m
//  ElongClient
//
//  Created by Dawn on 15/4/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongBus.h"
#import <objc/message.h>
#import "CustomRootViewController.h"
#import "HomeRootNaviController.h"

@implementation eLongBus
+ (instancetype) bus{
    static eLongBus *bus;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        bus = [[eLongBus alloc] init];
        bus.registedNoPushVCs = [[NSMutableDictionary alloc] init];
    });
    return bus;
}

- (void) registerBundle:(NSString *)bundle{
    // 绑定所有的URL路由协议
    NSDictionary *bundlespec = [NSDictionary dictionaryWithContentsOfFile:bundle];
    NSArray *routes = [bundlespec objectForKey:@"route_list"];
    for (NSDictionary *route in routes) {
        [eLongRoutes addRoute:[route objectForKey:@"url"] handler:^BOOL(NSDictionary *parameters) {
            NSString *title = [route objectForKey:@"title"];
            NSInteger style = [[route objectForKey:@"style"] integerValue];
            NSString *url = [route objectForKey:@"url"];
            NSString *className = [route objectForKey:@"object"];
            NSString *storyboardName = [route objectForKey:@"storyboard"];
            NSString * animatedStr = [parameters objectForKey:@"nopush"];
            if (storyboardName) {
                NSString * pComp = [storyboardName stringByAppendingPathExtension:@"storyboardc"];
                NSString * tmpPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pComp];
                if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:nil]) {
                    return NO;
                }
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:className];
                SEL method = NSSelectorFromString(@"setDicData:");
                if ([vc respondsToSelector:method]) {
                    ((void(*)(id, SEL, id))objc_msgSend)(vc, method, parameters);
                }
                if (animatedStr) {
                    [self.registedNoPushVCs setObject:vc forKey:url];
                    return YES;
                }else
                    [self pushVC:vc];
                return YES;
            }else{
                Class class = NSClassFromString(className);
                if (className && class) {
                    id obj = [class alloc];
                    SEL method = NSSelectorFromString(@"initWithTitle:style:params:");
                    if ([obj respondsToSelector:method]) {
                        ((void(*)(id, SEL, id,NSInteger,id))objc_msgSend)(obj,method,title,style,parameters);
                        if (animatedStr) {
                            [self.registedNoPushVCs setObject:obj forKey:url];
                            return YES;
                        }else
                            [self pushVC:obj];
                        return YES;
                    }
                    method = NSSelectorFromString(@"initWithTitle:style:");
                    if ([obj respondsToSelector:method]) {
                        ((void(*)(id, SEL, id,NSInteger))objc_msgSend)(obj,method,title,style);
                        if (animatedStr) {
                            [self.registedNoPushVCs setObject:obj forKey:url];
                            return YES;
                        }else
                            [self pushVC:obj];
                        return YES;
                    }
                    method = NSSelectorFromString(@"initWithTitle:style:url:");
                    if ([obj respondsToSelector:method]) {
                        ((void(*)(id, SEL, id,NSInteger,id))objc_msgSend)(obj,method,title,style,[NSURL URLWithString:url]);
                        if (animatedStr) {
                            [self.registedNoPushVCs setObject:obj forKey:url];
                            return YES;
                        }else
                            [self pushVC:obj];
                        return YES;
                    }
                }
                return NO;
            }
        }];
    }
    
    // 绑定所有的服务协议
    NSArray *services = [bundlespec objectForKey:@"service_list"];
    for (NSDictionary *service in services) {
        NSString *name = [service objectForKey:@"name"];
        NSString *protocol = [service objectForKey:@"protocol"];
        NSString *class = [service objectForKey:@"class"];
        BOOL singleton = [[service objectForKey:@"singleton"] boolValue];
        [eLongServices addService:name class:class protocol:protocol singleton:singleton];
    }
}

- (void) registerBundle:(NSString *)bundle andPriority:(NSUInteger)p
{
    // 绑定所有的URL路由协议
    NSDictionary *bundlespec = [NSDictionary dictionaryWithContentsOfFile:bundle];
    NSArray *routes = [bundlespec objectForKey:@"route_list"];
    for (NSDictionary *route in routes) {
        [eLongRoutes addRoute:[route objectForKey:@"url"] priority:p handler:^BOOL(NSDictionary *parameters) {
            NSString *title = [parameters objectForKey:@"title"];
            NSInteger style = [[parameters objectForKey:@"style"] integerValue];
            NSString *url = [route objectForKey:@"url"];
            NSString *className = [route objectForKey:@"object"];
            NSString *storyboardName = [route objectForKey:@"storyboard"];
            NSString * animatedStr = [parameters objectForKey:@"nopush"];
            if (storyboardName) {
                NSString * pComp = [storyboardName stringByAppendingPathExtension:@"storyboardc"];
                NSString * tmpPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pComp];
                if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:nil]) {
                    return NO;
                }
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:className];
                SEL method = NSSelectorFromString(@"setDicData:");
                if ([vc respondsToSelector:method]) {
                    ((void(*)(id, SEL, id))objc_msgSend)(vc, method, parameters);
                }
                if (animatedStr) {
                    [self.registedNoPushVCs setObject:vc forKey:url];
                    return YES;
                }else
                    [self pushVC:vc];
                return YES;
            }else{
                Class class = NSClassFromString(className);
                if (className && class) {
                    id obj = [class alloc];
                    SEL method = NSSelectorFromString(@"initWithTitle:style:params:");
                    if ([obj respondsToSelector:method]) {
                        ((void(*)(id, SEL, id,NSInteger,id))objc_msgSend)(obj,method,title,style,parameters);
                        if (animatedStr) {
                            [self.registedNoPushVCs setObject:obj forKey:url];
                            return YES;
                        }else
                            [self pushVC:obj];
                        return YES;
                    }
                    method = NSSelectorFromString(@"initWithTitle:style:");
                    if ([obj respondsToSelector:method]) {
                        ((void(*)(id, SEL, id,NSInteger))objc_msgSend)(obj,method,title,style);
                        if (animatedStr) {
                            [self.registedNoPushVCs setObject:obj forKey:url];
                            return YES;
                        }else
                            [self pushVC:obj];
                        return YES;
                    }
                    method = NSSelectorFromString(@"initWithTitle:style:url:");
                    if ([obj respondsToSelector:method]) {
                        ((void(*)(id, SEL, id,NSInteger,id))objc_msgSend)(obj,method,title,style,[NSURL URLWithString:url]);
                        if (animatedStr) {
                            [self.registedNoPushVCs setObject:obj forKey:url];
                            return YES;
                        }else
                            [self pushVC:obj];
                        return YES;
                    }
                }
                return NO;
            }
        }];
    }
    
    // 绑定所有的服务协议
    NSArray *services = [bundlespec objectForKey:@"service_list"];
    for (NSDictionary *service in services) {
        NSString *name = [service objectForKey:@"name"];
        NSString *protocol = [service objectForKey:@"protocol"];
        NSString *class = [service objectForKey:@"class"];
        BOOL singleton = [[service objectForKey:@"singleton"] boolValue];
        [eLongServices addService:name class:class protocol:protocol singleton:singleton];
    }
    
}

- (void) pushVC:(UIViewController *)vc{
    [self pushVC:vc animated:YES];
}

- (void) pushVC:(UIViewController *)vc animated:(BOOL)animated{
    if ([eLongBus bus].navigationController && [eLongBus bus].navigationController.viewControllers.count && [eLongBus bus].rootViewController.viewControllers.count > 1/*非首页一级页面*/) {
        [[eLongBus bus].navigationController pushViewController:vc animated:animated];
    }else{
        if ([eLongBus bus].navigationController) {
            [eLongBus bus].navigationController =  nil;
        }
        [eLongBus bus].navigationController = [[HomeRootNaviController alloc] initWithRootViewController:vc];
        CustomRootViewController * customRootVC = [[CustomRootViewController alloc] init];
        customRootVC.wantsFullScreenLayout = YES;
        customRootVC.navC = [eLongBus bus].navigationController;
        [customRootVC.view addSubview:[eLongBus bus].navigationController.view];
        [[eLongBus bus].rootViewController pushViewController:customRootVC animated:animated];
    }
}

@end
