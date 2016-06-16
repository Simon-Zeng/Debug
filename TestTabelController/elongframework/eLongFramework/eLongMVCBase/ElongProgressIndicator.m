//
//  elongProgressIndicator.m
//  MyElong
//
//  Created by yongxue on 16/1/7.
//  Copyright © 2016年 lvyue. All rights reserved.
//

#import "ElongProgressIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "ElongImagePlayer.h"

#define ANIMATION_IMAGE_WIDTH 106
#define ANIMATION_IMAGE_HEIGHT 83

@interface ElongProgressIndicator ()

@property (nonatomic, readwrite) ElongProgressIndicatorMaskType maskType;
@property (nonatomic, strong, readonly) NSTimer *fadeOutTimer;

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIImageView *hudView;
@property (nonatomic, strong, readonly) UILabel *stringLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) ElongImagePlayer *imagePlayerView;

//@property (nonatomic, weak) UIView *overView;

@property (nonatomic, copy) NSString *statusString;


@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;

- (void)showWithStatus:(NSString*)string maskType:(ElongProgressIndicatorMaskType)hudMaskType networkIndicator:(BOOL)show;
- (void)setStatus:(NSString*)string;
- (void)registerNotifications;
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle;
- (void)positionHUD:(NSNotification*)notification;

@end


@implementation ElongProgressIndicator

@synthesize overlayWindow, hudView, maskType, fadeOutTimer, stringLabel, imageView, imagePlayerView, visibleKeyboardHeight;

- (void)dealloc {
    self.fadeOutTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (ElongProgressIndicator*)sharedView {
    ElongProgressIndicator *sharedView;
    sharedView = [[ElongProgressIndicator alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    return sharedView;
}

#pragma mark - Show Methods
+ (ElongProgressIndicator *)showWithView:(UIView *)overlayView {
    return [ElongProgressIndicator showWithView:overlayView withStatus:nil];
}

+ (ElongProgressIndicator *)showClearWithView:(UIView *)overlayView {
    return [ElongProgressIndicator showClearWithView:overlayView withStatus:nil];
}

+ (ElongProgressIndicator *)showWithView:(UIView *)overlayView withStatus:(NSString *)status {
    ElongProgressIndicator *progressIndicator = [ElongProgressIndicator sharedView];
    if (overlayView) {
        progressIndicator.overView = overlayView;
    }
    progressIndicator.statusString = status;
    progressIndicator.maskType = ElongProgressIndicatorMaskTypeNone;
    return progressIndicator;
}

+ (ElongProgressIndicator *)showClearWithView:(UIView *)overlayView withStatus:(NSString *)status {
    ElongProgressIndicator *progressIndicator = [ElongProgressIndicator sharedView];
    if (overlayView) {
        progressIndicator.overView = overlayView;
    }
    progressIndicator.statusString = status;
    progressIndicator.maskType = ElongProgressIndicatorMaskTypeClear;
    return progressIndicator;
}

#pragma mark -
- (void)showLoading {
    [self showWithStatus:self.statusString
                maskType:ElongProgressIndicatorMaskTypeNone
        networkIndicator:NO];
}

- (void)showClearLoading {
    [self showWithStatus:self.statusString
                maskType:ElongProgressIndicatorMaskTypeClear
        networkIndicator:NO];
}

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.maskType) {
        case ElongProgressIndicatorMaskTypeNone: {
            [[UIColor colorWithWhite:0 alpha:0.1] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
        case ElongProgressIndicatorMaskTypeClear: {
            [[UIColor colorWithWhite:0 alpha:0.1] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
            
        case ElongProgressIndicatorMaskTypeBlack: {
            [[UIColor colorWithWhite:0 alpha:0.1] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
            
        case ElongProgressIndicatorMaskTypeGradient: {
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }
    }
}

- (void)setStatus:(NSString *)string {
    
    CGFloat hudWidth = ANIMATION_IMAGE_WIDTH;
    CGFloat hudHeight = ANIMATION_IMAGE_HEIGHT;
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    
    CGFloat interalToString = 0;
    if (string) {
        CGSize stringSize = [string boundingRectWithSize:CGSizeMake(200, 300) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil].size;
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;
        hudHeight += stringHeight;
        
        if (stringWidth > hudWidth) {
            hudWidth = ceil(stringWidth/2)*2;
        }
        // 动画和文字之间的间距
        interalToString = 10;
        hudHeight += interalToString;
        //        if(hudHeight > 100) {
        //            hudWidth+=24;
        //            labelRect = CGRectMake(12, hudHeight - stringHeight, hudWidth, stringHeight);
        //        } else {
        //            hudWidth+=24;
        //            labelRect = CGRectMake(0, hudHeight - stringHeight, hudWidth, stringHeight);
        //        }
        
        hudWidth+=24;
        labelRect = CGRectMake(0, hudHeight - stringHeight, hudWidth, stringHeight);
    }
    
    self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    if (string)
        self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, 36);
    else
       	self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, CGRectGetHeight(self.hudView.bounds)/2);
    
    self.stringLabel.hidden = NO;
    self.stringLabel.text = string;
    self.stringLabel.frame = labelRect;
    
    if (string) {
        self.imagePlayerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+0.5, (CGRectGetHeight(self.hudView.bounds) - stringHeight - interalToString)/2);
    }
    else {
        self.imagePlayerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+0.5, ceil(self.hudView.bounds.size.height/2)+0.5);
    }
}

- (void)setFadeOutTimer:(NSTimer *)newTimer {
    if (fadeOutTimer) {
        [fadeOutTimer invalidate], fadeOutTimer = nil;
    }
    if(newTimer) {
        fadeOutTimer = newTimer;
    }
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)positionHUD:(NSNotification*)notification {
    
    CGFloat keyboardHeight;
    double animationDuration = 0.0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(UIInterfaceOrientationIsPortrait(orientation))
                keyboardHeight = keyboardFrame.size.height;
            else
                keyboardHeight = keyboardFrame.size.width;
        } else
            keyboardHeight = 0;
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (self.overView) {
        orientationFrame = self.overView.bounds;
        statusBarFrame = CGRectMake(0, 0, 0, 0);
    }
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    if(keyboardHeight > 0)
        activeHeight += statusBarFrame.size.height*2;
    
    activeHeight -= keyboardHeight;
    
    //    CGFloat posY = floor(activeHeight*0.45);
    CGFloat posY = floor(activeHeight*0.5);
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    }
    if (self.overView) {
        rotateAngle = 0.0;
    }
    
    if(notification) {
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    }
    
    else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
    
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.hudView.transform = CGAffineTransformMakeRotation(angle);
    self.hudView.center = newCenter;
}

#pragma mark - Master show/dismiss methods

- (void)showWithStatus:(NSString*)string maskType:(ElongProgressIndicatorMaskType)hudMaskType networkIndicator:(BOOL)show {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.overView) {
            [self removeFromSuperview];
            [self.overView addSubview:self];
        }
        else {
            if(!self.superview) {
                [self.overlayWindow addSubview:self];
            }
        }
        
        self.fadeOutTimer = nil;
        self.imageView.hidden = YES;
        self.maskType = hudMaskType;
        self.statusString = string;
        
        [self setStatus:string];
        [self.imagePlayerView play];
        
        
        if (self.overView) {
            if(self.maskType != ElongProgressIndicatorMaskTypeNone) {
                self.overView.userInteractionEnabled = NO;
            } else {
                self.overView.userInteractionEnabled = YES;
            }
        }
        else {
            if(self.maskType != ElongProgressIndicatorMaskTypeNone) {
                self.overlayWindow.userInteractionEnabled = YES;
            } else {
                self.overlayWindow.userInteractionEnabled = NO;
            }
            [self.overlayWindow makeKeyAndVisible];
        }
        
        [self positionHUD:nil];
        NSLog(@"frame == %@",NSStringFromCGRect(self.imagePlayerView.frame));
        if(self.alpha != 1) {
            [self registerNotifications];
            self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
            
            [UIView animateWithDuration:0.15
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3, 1/1.3);
                                 self.alpha = 1;
                             }
                             completion:NULL];
        }
        
        [self setNeedsDisplay];
    });
}

- (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imagePlayerView stop];
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [[NSNotificationCenter defaultCenter] removeObserver:self];
                                 [hudView removeFromSuperview];
                                 hudView = nil;
                                 if (self.overView) {
                                     self.overView.userInteractionEnabled = YES;
                                     self.overView = nil;
                                 }
                                 else {
                                     // Make sure to remove the overlay window from the list of windows
                                     // before trying to find the key window in that same list
                                     NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                     [windows removeObject:overlayWindow];
                                     overlayWindow = nil;
                                     
                                     
                                     [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                         if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                             [window makeKeyWindow];
                                             *stop = YES;
                                         }
                                     }];
                                 }
                             }
                         }];
    });
}

#pragma mark - Utilities

#pragma mark - Getters

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
    }
    return overlayWindow;
}

- (UIView *)hudView {
    if(!hudView) {
        hudView = [[UIImageView alloc] initWithFrame:CGRectZero];
        hudView.backgroundColor = [UIColor clearColor];
        //        hudView.image = [UIImage imageNamed:@"loading_bg"];
        hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:hudView];
    }
    return hudView;
}

- (UILabel *)stringLabel {
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        stringLabel.textColor = [UIColor grayColor];
        stringLabel.backgroundColor = [UIColor clearColor];
        stringLabel.adjustsFontSizeToFitWidth = YES;
        stringLabel.textAlignment = NSTextAlignmentCenter;
        stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        stringLabel.font = [UIFont boldSystemFontOfSize:16.0];
        stringLabel.numberOfLines = 0;
    }
    
    if(!stringLabel.superview)
        [self.hudView addSubview:stringLabel];
    
    return stringLabel;
}

- (UIImageView *)imageView {
    if (imageView == nil)
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    
    if(!imageView.superview)
        [self.hudView addSubview:imageView];
    
    return imageView;
}

- (ElongImagePlayer *)imagePlayerView {
    if (imagePlayerView == nil) {
        imagePlayerView = [[ElongImagePlayer alloc] init];
        imagePlayerView.bounds = CGRectMake(0, 0, ANIMATION_IMAGE_WIDTH, ANIMATION_IMAGE_HEIGHT);
    }
    
    if(!imagePlayerView.superview) {
        [self.hudView addSubview:imagePlayerView];
    }
    
    return imagePlayerView;
}

- (CGFloat)visibleKeyboardHeight {
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    // Locate UIKeyboard.
    UIView *foundKeyboard = nil;
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:0];
        }
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
            foundKeyboard = possibleKeyboard;
            break;
        }
    }
    
    if(foundKeyboard && foundKeyboard.bounds.size.height > 100)
        return foundKeyboard.bounds.size.height;
    
    return 0;
}

@end
