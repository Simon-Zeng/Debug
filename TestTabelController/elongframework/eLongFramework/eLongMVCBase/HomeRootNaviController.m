//
//  HomeRootNaviController.m
//  ElongClient
//
//  Created by Dawn on 14-8-22.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HomeRootNaviController.h"

@interface HomeRootNaviController ()<UINavigationControllerDelegate>

@property (nonatomic, retain) NSMutableArray* stackArr;
@property (nonatomic, assign) bool transitioning;

@end

@implementation HomeRootNaviController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.stackArr = [[NSMutableArray alloc] init];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    @synchronized(self.stackArr) {
        if (self.transitioning) {
            void (^codeBlock)(void) = [^{
                [super popViewControllerAnimated:animated];
            } copy];
            [self.stackArr addObject:codeBlock];
            
            // We cannot show what viewcontroller is currently animated now
            return nil;
        } else {
            return [super popViewControllerAnimated:animated];
        }
    }
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    @synchronized(self.stackArr) {
        if (self.transitioning) {
            void (^codeBlock)(void) = [^{
                [super popToRootViewControllerAnimated:animated];
            } copy];
            [self.stackArr addObject:codeBlock];
            
            // We cannot show what viewcontroller is currently animated now
            return nil;
        } else {
            return [super popToRootViewControllerAnimated:animated];
        }
    }
}

- (NSArray*) popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    @synchronized(self.stackArr) {
        if (self.transitioning) {
            void (^codeBlock)(void) = [^{
                [super popToViewController:viewController animated:animated];
            } copy];
            [self.stackArr addObject:codeBlock];
            
            // We cannot show what viewcontroller is currently animated now
            return nil;
        } else {
            return [super popToViewController:viewController animated:animated];
        }
    }
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    @synchronized(self.stackArr) {
        if (self.transitioning) {
            // Copy block so its no longer on the (real software) stack
            void (^codeBlock)(void) = [^{
                [super setViewControllers:viewControllers animated:animated];
            } copy];
            
            // Add to the stack list and then release
            [self.stackArr addObject:codeBlock];
        } else {
            [super setViewControllers:viewControllers animated:animated];
        }
    }
}

- (void) pushCodeBlock:(void (^)())codeBlock{
    @synchronized(self.stackArr) {
        [self.stackArr addObject:[codeBlock copy]];
        
        if (!self.transitioning)
            [self runNextBlock];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    @synchronized(self.stackArr) {
        if (self.transitioning) {
            void (^codeBlock)(void) = [^{
                [super pushViewController:viewController animated:animated];
            } copy];
            [self.stackArr addObject:codeBlock];
        } else {
            [super pushViewController:viewController animated:animated];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    @synchronized (self.stackArr) {
        self.transitioning = true;
        
        if ([navigationController.topViewController respondsToSelector:@selector(transitionCoordinator)]) {
            id <UIViewControllerTransitionCoordinator> transitionCoordinator = navigationController.topViewController.transitionCoordinator;
            [transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id <UIViewControllerTransitionCoordinatorContext> context) {
                if ([context isCancelled]) {
                    @synchronized (self.stackArr) {
                        self.transitioning = false;
                    }
                }
            }];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    @synchronized(self.stackArr) {
        self.transitioning = false;
        
        [self runNextBlock];
    }
}

- (void) runNextBlock {
    if (self.stackArr.count == 0)
        return;
    
    void (^codeBlock)(void) = [self.stackArr objectAtIndex:0];
    
    // Execute block, then remove it from the stack (which will dealloc)
    codeBlock();
    
    [self.stackArr removeObjectAtIndex:0];
}


@end
