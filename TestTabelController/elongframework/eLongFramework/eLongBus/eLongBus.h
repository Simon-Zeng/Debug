//
//  eLongBus.h
//  ElongClient
//
//  Created by Dawn on 15/4/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "eLongRoutes.h"
#import "eLongServices.h"

@interface eLongBus : NSObject
@property (nonatomic,strong) UINavigationController *navigationController;
@property (nonatomic,strong) UINavigationController *rootViewController;
@property (nonatomic,strong) NSMutableDictionary * registedNoPushVCs;
@property (nonatomic,strong) UIWindow *window;

+ (instancetype) bus;
- (void) registerBundle:(NSString *)bundle;
- (void) pushVC:(UIViewController *)vc;
- (void) pushVC:(UIViewController *)vc animated:(BOOL)animated;
- (void) registerBundle:(NSString *)bundle andPriority:(NSUInteger)p;

@end
