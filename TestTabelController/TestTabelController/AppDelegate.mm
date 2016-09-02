//
//  AppDelegate.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/6.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BaseMarco.h"
//#import "GYHttpMock.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    ViewController *vc = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.navigationBar.hidden = YES;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = nav;
    [window makeKeyAndVisible];
    
    
    
//    mockRequest(@"GET",@"http//www.goole.com");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    NSString *idtifier = userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];
//    if ([idtifier isEqualToString:@"1"]) {
//        demoOneVc *ovc = [[demoOneVc alloc]init];
//        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//        [navigationController pushViewController:ovc animated:true];
//    }
    return YES;
}

@end