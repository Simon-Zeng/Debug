//
//  eLongColorAlertView.m
//  eLongColorAlertView
//
//
//  Created by dayu on 15-7-8.
//  Copyright (c) 2015年 dayu. All rights reserved.

#import "eLongColorAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resizable.h"
#import "eLongFileIOUtils.h"

NSString *const eLongColorAlertViewWillShowNotification = @"eLongColorAlertViewWillShowNotification";
NSString *const eLongColorAlertViewDidShowNotification = @"eLongColorAlertViewDidShowNotification";
NSString *const eLongColorAlertViewWillDismissNotification = @"eLongColorAlertViewWillDismissNotification";
NSString *const eLongColorAlertViewDidDismissNotification = @"eLongColorAlertViewDidDismissNotification";

#define DEBUG_LAYOUT 0

#define MESSAGE_MIN_LINE_COUNT 1
#define MESSAGE_MAX_LINE_COUNT 10
#define GAP 0
#define CANCEL_BUTTON_PADDING_TOP 0
#define CONTENT_PADDING_LEFT 0
#define CONTENT_PADDING_TOP 12
#define CONTENT_PADDING_BOTTOM 10
#define BUTTON_HEIGHT 44
#define CONTAINER_WIDTH 300

const UIWindowLevel UIWindowLeveleLongAlert = 1999.0;  // don't overlap system's alert
const UIWindowLevel UIWindowLeveleLongAlertBackground = 1998.0; // below the alert window

@class eLongAlertBackgroundWindow;

static NSMutableArray *queues;
static BOOL alertAnimating;
static eLongAlertBackgroundWindow *alertBackgroundWindow;
static eLongColorAlertView *alertCurrentView;
 
@interface eLongColorAlertView ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, assign, getter = isVisible) BOOL visible;
@property (nonatomic, weak)  UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, assign, getter = isShowingKeyboard) BOOL showingKeyboard;
@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;
@property (nonatomic, assign, getter = isPortrait) BOOL portrait;

+ (NSMutableArray *)sharedQueue;
+ (eLongColorAlertView *)currentAlertView;

+ (BOOL)isAnimating;
+ (void)setAnimating:(BOOL)animating;

+ (void)showBackground;
+ (void)hideBackgroundAnimated:(BOOL)animated;

- (void)setup;
- (void)invaliadateLayout;
- (void)resetTransition;

@end

@implementation eLongColorAlertViewButtonModal



@end

#pragma mark - eLongBackgroundWindow

@interface eLongAlertBackgroundWindow : UIWindow

@end

@implementation eLongAlertBackgroundWindow

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = UIWindowLeveleLongAlertBackground;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0 alpha:0.3] set];
    CGContextFillRect(context, self.bounds);
}

@end

#pragma mark - eLongAlertItem

@interface eLongAlertItem : NSObject

@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) eLongColorAlertViewHandler action;
@property (nonatomic, assign) NSInteger buttonTag;

@end

@implementation eLongAlertItem

@end

#pragma mark - eLongColorAlertViewController

@interface eLongColorAlertViewController : UIViewController

@property (nonatomic, strong) eLongColorAlertView *alertView;

@end

@implementation eLongColorAlertViewController

#pragma mark - View life cycle

- (void)loadView {
    self.view = self.alertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.alertView setup];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.alertView resetTransition];
    [self.alertView invaliadateLayout];
}

@end

#pragma mark - eLongAlert

@implementation eLongColorAlertView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)initialize {
    if (self != [eLongColorAlertView class])
        return;
    
    eLongColorAlertView *appearance = [self appearance];
    appearance.viewBackgroundColor = [UIColor whiteColor];
    appearance.titleColor = [UIColor blackColor];
    appearance.messageColor = [UIColor darkGrayColor];
    appearance.titleFont = [UIFont boldSystemFontOfSize:20];
    appearance.messageFont = [UIFont systemFontOfSize:16];
    appearance.buttonFont = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
    appearance.cornerRadius = 8;
   // appearance.portrait = NO;
}

- (id)init {
    return [self initWithTitle:nil message:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        _title = title;
        _message = message;
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate modals:(NSArray *)modals {
    if (!modals || ![modals isKindOfClass:[NSArray class]] || ![modals isKindOfClass:[NSMutableArray class]] || modals.safeCount == 0 || modals.safeCount > 8) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络错误，请稍候再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return nil;
    }
    
    __block BOOL error = NO;
    [modals enumerateObjectsUsingBlock:^(eLongColorAlertViewButtonModal *obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[eLongColorAlertViewButtonModal class]]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络错误，请稍候再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            *stop = YES;
            error = YES;
        }
    }];
    if (error) {
        return nil;
    }
    
    self = [self initWithTitle:title message:message];
    for (eLongColorAlertViewButtonModal *obj in modals) {
        [self addButtonWithModal:obj];
    }
    self.delegate = delegate;
    return self;
}

#pragma mark - Class methods

+ (NSMutableArray *)sharedQueue {
    if (!queues) {
        queues = [NSMutableArray array];
    }
    return queues;
}

+ (eLongColorAlertView *)currentAlertView {
    return alertCurrentView;
}

+ (void)setCurrentAlertView:(eLongColorAlertView *)alertView
{
    alertCurrentView = alertView;
}

+ (BOOL)isAnimating {
    return alertAnimating;
}

+ (void)setAnimating:(BOOL)animating {
    alertAnimating = animating;
}

+ (void)showBackground {
    if (!alertBackgroundWindow) {
        alertBackgroundWindow = [[eLongAlertBackgroundWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [alertBackgroundWindow makeKeyAndVisible];
        alertBackgroundWindow.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             alertBackgroundWindow.alpha = 1;
                         }];
    }
}

+ (void)hideBackgroundAnimated:(BOOL)animated {
    if (!animated) {
        [alertBackgroundWindow removeFromSuperview];
        alertBackgroundWindow = nil;
        return;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         alertBackgroundWindow.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [alertBackgroundWindow removeFromSuperview];
                         alertBackgroundWindow = nil;
                     }];
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    _title = title;
    [self invaliadateLayout];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    
    [self invaliadateLayout];
}

#pragma mark - Public

- (void)addButtonWithModal:(eLongColorAlertViewButtonModal *)modal{
    eLongAlertItem *item = [[eLongAlertItem alloc] init];
    item.title = modal.title;
    item.buttonTag = modal.tag;
    [self.items addObject:item];
}

- (void)showInView:(UIView *)view {
    [view endEditing:YES];
    if (![[eLongColorAlertView sharedQueue] containsObject:self]) {
        [[eLongColorAlertView sharedQueue] addObject:self];
    }
    
    if ([eLongColorAlertView isAnimating]) {
        return; // wait for next turn
    }
    
    if (self.isVisible) {
        return;
    }
    
    if ([eLongColorAlertView currentAlertView].isVisible) {
        eLongColorAlertView *alert = [eLongColorAlertView currentAlertView];
        [alert dismissAnimated:YES cleanup:NO];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:eLongColorAlertViewWillShowNotification object:self userInfo:nil];
    
    self.visible = YES;
    
    [eLongColorAlertView setAnimating:YES];
    [eLongColorAlertView setCurrentAlertView:self];
    
    // traneLongtion background
    [eLongColorAlertView showBackground];
    
    eLongColorAlertViewController *viewController = [[eLongColorAlertViewController alloc] initWithNibName:nil bundle:nil];
    viewController.alertView = self;
    
    if (!self.alertWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask
        = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLeveleLongAlert;
        window.rootViewController = viewController;
        self.alertWindow = window;
    }
    [self.alertWindow makeKeyAndVisible];
    
    [self validateLayout];
    
    [self transitionInCompletion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:eLongColorAlertViewDidShowNotification object:self userInfo:nil];
        
        [eLongColorAlertView setAnimating:NO];
        
        NSInteger index = [[eLongColorAlertView sharedQueue] indexOfObject:self];
        if (index < [eLongColorAlertView sharedQueue].safeCount - 1) {
            [self dismissAnimated:YES cleanup:NO]; // dismiss to show next alert view
        }
    }];
    
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup {
    BOOL isVisible = self.isVisible;
    
    if (isVisible) {
        [[NSNotificationCenter defaultCenter] postNotificationName:eLongColorAlertViewWillDismissNotification object:self userInfo:nil];
    }
    //    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //    window.hidden = NO;
    
    void (^dismissComplete)(void) = ^{
        self.visible = NO;
        
        [self teardown];
        
        [eLongColorAlertView setCurrentAlertView:nil];
        
        eLongColorAlertView *nextAlertView;
        NSInteger index = [[eLongColorAlertView sharedQueue] indexOfObject:self];
        if (index != NSNotFound && index < [eLongColorAlertView sharedQueue].safeCount - 1) {
            nextAlertView = [[eLongColorAlertView sharedQueue] safeObjectAtIndex:(index + 1)];
        }
        
        if (cleanup) {
            [[eLongColorAlertView sharedQueue] removeObject:self];
        }
        
        [eLongColorAlertView setAnimating:NO];
        
        if (isVisible) {
            [[NSNotificationCenter defaultCenter] postNotificationName:eLongColorAlertViewDidDismissNotification object:self userInfo:nil];
        }
        
        // check if we should show next alert
        if (!isVisible) {
            return;
        }
        
        if (nextAlertView) {
            [nextAlertView showInView:nil];
        } else {
            // show last alert view
            if ([eLongColorAlertView sharedQueue].safeCount > 0) {
                eLongColorAlertView *alert = [[eLongColorAlertView sharedQueue] lastObject];
                [alert showInView:nil];
            }
        }
        
    };
    
    if (animated && isVisible) {
        [eLongColorAlertView setAnimating:YES];
        [self transitionOutCompletion:dismissComplete];
        
        if ([eLongColorAlertView sharedQueue].safeCount == 1) {
            [eLongColorAlertView hideBackgroundAnimated:YES];
        }
        
    } else {
        dismissComplete();
        
        if ([eLongColorAlertView sharedQueue].safeCount == 0) {
            [eLongColorAlertView hideBackgroundAnimated:YES];
        }
    }
}

#pragma mark - Transitions
- (void)transitionInCompletion:(void(^)(void))completion {
    self.containerView.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.containerView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)transitionOutCompletion:(void(^)(void))completion {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.containerView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)resetTransition {
    [self.containerView.layer removeAllAnimations];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self validateLayout];
}

- (void)invaliadateLayout {
    self.layoutDirty = YES;
    [self setNeedsLayout];
}

- (void)validateLayout {
    if (!self.isLayoutDirty) {
        return;
    }
    self.layoutDirty = NO;
    
    CGFloat height = [self preferredHeight];
    CGFloat left = (self.bounds.size.width - CONTAINER_WIDTH) * 0.5;
    CGFloat top = (self.bounds.size.height - height) * 0.5;
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.frame = CGRectMake(left, top, CONTAINER_WIDTH, height);
    self.backgroundImageView.frame = self.containerView.bounds;
    //    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:self.containerView.layer.cornerRadius].CGPath;
    
    CGFloat y = CONTENT_PADDING_TOP;
    if (self.titleLabel) {
        self.titleLabel.text = self.title;
        CGFloat height = [self heightForTitleLabel];
        self.titleLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
    }
    if (self.messageView) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        if (self.attributedFormatBlock) {
            NSAttributedString *attributeStr = self.attributedFormatBlock(self.message);
            
            self.messageView.attributedText = attributeStr;
        }else {
            self.messageView.text = self.message;
        }
        CGFloat height = [self heightFormessageView];
        self.messageView.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
    }
    if (self.items.safeCount > 0) {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        if (self.items.safeCount == 2 && !self.portrait) {
            CGFloat width = (self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2 - GAP) * 0.5;
            UIButton *button = [self.buttons safeObjectAtIndex:1];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT, y, width, BUTTON_HEIGHT);
            button = [self.buttons safeObjectAtIndex:0];
            button.frame = CGRectMake(CONTENT_PADDING_LEFT + width + GAP, y, width, BUTTON_HEIGHT);
        } else {
            for (NSUInteger i = 0; i < self.buttons.safeCount; i++) {
                UIButton *button = [self.buttons safeObjectAtIndex:i];
                button.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, BUTTON_HEIGHT);
                if (self.buttons.safeCount > 1) {
                    y += BUTTON_HEIGHT + GAP;
                }
            }
        }
    }
}

- (CGFloat)preferredHeight {
    CGFloat height = CONTENT_PADDING_TOP;
    if (self.title) {
        height += [self heightForTitleLabel];
    }
    if (self.message) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        height += [self heightFormessageView];
    }
    if (self.items.safeCount > 0) {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        if (self.portrait) {
            height += (BUTTON_HEIGHT + GAP) * self.items.safeCount - GAP;
        }else {
            if (self.items.safeCount <= 2) {
                height += BUTTON_HEIGHT;
            }else if (self.items.safeCount){
                height += (BUTTON_HEIGHT + GAP) * self.items.safeCount - GAP;
            }
        }
    }
    return height;
}

- (CGFloat)heightForTitleLabel {
    if (self.titleLabel) {
        CGSize size = [self.title sizeWithFont:self.titleLabel.font
                                   minFontSize:
#ifndef __IPHONE_6_0
                       self.titleLabel.font.pointSize * self.titleLabel.minimumScaleFactor
#else
                       self.titleLabel.minimumScaleFactor
#endif
                                actualFontSize:nil
                                      forWidth:CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2
                                 lineBreakMode:self.titleLabel.lineBreakMode];
        return size.height;
    }
    return 0;
}

- (CGFloat)heightFormessageView {
    CGFloat minHeight = MESSAGE_MIN_LINE_COUNT * self.messageView.font.lineHeight;
    if (self.messageView) {
        CGFloat maxHeight = MESSAGE_MAX_LINE_COUNT * self.messageView.font.lineHeight;
        CGSize size = [self.message sizeWithFont:self.messageView.font
                               constrainedToSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, maxHeight)
                                   lineBreakMode:0];
        return MAX(minHeight, size.height);
    }
    return minHeight;
}

#pragma mark - Setup

- (void)setup {
    [self setupContainerView];
    [self updateTitleLabel];
    [self updatemessageView];
    [self setupButtons];
    [self invaliadateLayout];
}

- (void)teardown {
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    self.titleLabel = nil;
    self.messageView = nil;
    [self.buttons removeAllObjects];
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
}

- (void)setupContainerView {
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = self.cornerRadius;
    self.containerView.layer.shadowOffset = CGSizeZero
    ;
    self.containerView.layer.shadowOpacity = 0.5;
    [self addSubview:self.containerView];
    
    //    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(CONTAINER_WIDTH, 44)]];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage resizableImage:@"Resource.bundle/box"]];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.layer.cornerRadius = self.cornerRadius;
    backgroundImageView.clipsToBounds = YES;
    [self.containerView addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
}

- (void)updateTitleLabel {
    if (self.title) {
        if (!self.titleLabel) {
            self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.font = self.titleFont;
            self.titleLabel.textColor = self.titleColor;
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
#ifndef __IPHONE_6_0
            self.titleLabel.minimumScaleFactor = 0.75;
#else
            self.titleLabel.minimumScaleFactor = self.titleLabel.font.pointSize * 0.75;
#endif
            [self.containerView addSubview:self.titleLabel];
#if DEBUG_LAYOUT
            self.titleLabel.backgroundColor = [UIColor redColor];
#endif
        }
        self.titleLabel.text = self.title;
    } else {
        [self.titleLabel removeFromSuperview];
        self.titleLabel = nil;
    }
    [self invaliadateLayout];
}

- (void)updatemessageView {
    if (self.message) {
        if (!self.messageView) {
            self.messageView = [[UITextView alloc] initWithFrame:self.bounds];
            self.messageView.editable = NO;
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
                self.messageView.selectable = NO;
            }
            self.messageView.textAlignment = NSTextAlignmentCenter;
            self.messageView.backgroundColor = [UIColor clearColor];
            self.messageView.font = self.messageFont;
            self.messageView.textColor = self.messageColor;
            [self.containerView addSubview:self.messageView];
        }
        if (self.attributedFormatBlock) {
            self.messageView.attributedText = self.attributedFormatBlock(self.message);
        }else {
            self.messageView.text = self.message;
        }
    } else {
        [self.messageView removeFromSuperview];
        self.messageView = nil;
    }
    [self invaliadateLayout];
}

- (void)setupButtons {
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.safeCount];
    for (NSUInteger i = 0; i < self.items.safeCount; i++) {
        UIButton *button = [self buttonForItemIndex:i];
        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}

- (UIButton *)buttonForItemIndex:(NSUInteger)index {
    eLongAlertItem *item = [self.items safeObjectAtIndex:index];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = item.buttonTag;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button setTitle:item.title forState:UIControlStateNormal];
    UIColor *color = [UIColor blueColor];
    
    button.titleLabel.font = self.buttonFont;
    
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    if ((self.items.safeCount != 2 && self.items.safeCount > 0) || self.portrait) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor blackColor];
        line.alpha = 0.3;
        line.frame = CGRectMake(0, 0, CONTAINER_WIDTH, 1/scale);
        [button addSubview:line];
    } else {
        if (button.tag == 1) {
            return button;
        }
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor blackColor];
        line.alpha = 0.1;
        line.frame = CGRectMake(0, 0, CONTAINER_WIDTH, 1/scale);
        [button addSubview:line];
        
        UIView *seperateLine = [[UIView alloc] init];
        seperateLine.backgroundColor = [UIColor blackColor];
        seperateLine.alpha = 0.1;
        seperateLine.frame = CGRectMake(CONTAINER_WIDTH/2, 0, 1/scale, BUTTON_HEIGHT);
        [button addSubview:seperateLine];
        
    }
    return button;
}

#pragma mark - Actions

- (void)buttonAction:(UIButton *)button {
    [eLongColorAlertView setAnimating:YES];
    
    if ([self.delegate respondsToSelector:@selector(eLongColorAlertView:clickedButtonAtIndex:)]) {
        [self.delegate eLongColorAlertView:self clickedButtonAtIndex:button.tag];
    }
    [self dismissAnimated:YES];
}

#pragma mark - UIAppearance setters

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor {
    if (_viewBackgroundColor == viewBackgroundColor) {
        return;
    }
    _viewBackgroundColor = viewBackgroundColor;
    self.containerView.backgroundColor = viewBackgroundColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont == titleFont) {
        return;
    }
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
    [self invaliadateLayout];
}

- (void)setMessageFont:(UIFont *)messageFont
{
    if (_messageFont == messageFont) {
        return;
    }
    _messageFont = messageFont;
    self.messageView.font = messageFont;
    [self invaliadateLayout];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor == titleColor) {
        return;
    }
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageColor:(UIColor *)messageColor {
    if (_messageColor == messageColor) {
        return;
    }
    _messageColor = messageColor;
    self.messageView.textColor = messageColor;
}

- (void)setButtonFont:(UIFont *)buttonFont {
    if (_buttonFont == buttonFont) {
        return;
    }
    _buttonFont = buttonFont;
    for (UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setAttributedType:(eLongColorAlertViewAttributedType)attributedType {
    NSString *pattern = nil;
    switch (attributedType) {
        case eLongColorAlertViewAttributedTypeNumber:
            pattern = @"[+\\-]?[0-9]+";
            break;
        case eLongColorAlertViewAttributedTypePhoneNumber:
            pattern = @"1\\\\d{10}";
            break;
        case eLongColorAlertViewAttributedTypeEnword:
            pattern = @"[A-Za-z]+";
            break;
        case eLongColorAlertViewAttributedTypeEmail:
            pattern = @"w+([-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*";
            break;
        case eLongColorAlertViewAttributedTypeURL:
            pattern = @"[a-zA-z]+://[^\s]*";
            break;
        default:
            break;
    }
    self.attributedFormatBlock = ^NSAttributedString* (NSString *value) {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc]initWithString:value];
        NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *ranges = [regexp matchesInString:value options:0 range:NSMakeRange(0, value.length)];
        [ranges enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger idx, BOOL *stop) {
            [subTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
        }];
        
        return subTitle;
    };
    
}

- (void)setOrientation:(eLongColorAlertViewOrientation)orientation {
    _orientation = orientation;
    if (orientation == eLongColorAlertViewOrientationPortrait) {
        self.portrait = YES;
    }else {
        self.portrait = NO;
    }
}
@end
