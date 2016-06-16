//
//  eLongColorAlertView.h
//  eLongColorAlertView
//
//  Created by dayu on 15-7-8.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eLongColorAlertViewButtonModal : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger tag;

@end


typedef NSAttributedString* (^eLongAttributedFormatBlock)(NSString *value);

extern NSString *const eLongColorAlertViewWillShowNotification;
extern NSString *const eLongColorAlertViewDidShowNotification;
extern NSString *const eLongColorAlertViewWillDismissNotification;
extern NSString *const eLongColorAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, eLongColorAlertViewAttributedType) {
    eLongColorAlertViewAttributedTypeNumber = 0,
    eLongColorAlertViewAttributedTypePhoneNumber,
    eLongColorAlertViewAttributedTypeEnword,
    eLongColorAlertViewAttributedTypeEmail,
    eLongColorAlertViewAttributedTypeURL
};

typedef NS_ENUM(NSInteger, eLongColorAlertViewOrientation) {
    eLongColorAlertViewOrientationPortrait = 0,
    eLongColorAlertViewOrientationLandscape,
};

@class eLongColorAlertView;
typedef void(^eLongColorAlertViewHandler)(eLongColorAlertView *alertView);

@protocol eLongColorAlertViewDelegate <UIAlertViewDelegate>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)eLongColorAlertView:(eLongColorAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface eLongColorAlertView : UIView<UIAlertViewDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
/** Set text attributed format block
 *
 * Holds the attributed string.
 */
@property (nonatomic, copy) eLongAttributedFormatBlock attributedFormatBlock;
@property (nonatomic, weak) id<eLongColorAlertViewDelegate> delegate;
@property (nonatomic, readonly, getter = isVisible) BOOL visible;

@property (nonatomic, strong) UIColor *viewBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 5.0
@property (nonatomic, assign) eLongColorAlertViewAttributedType attributedType;// default is eLongColorAlertViewAttributedTypeNumber
@property (nonatomic, assign) eLongColorAlertViewOrientation orientation;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate modals:(NSArray *)modals;

- (void)showInView:(UIView *)view;
- (void)dismissAnimated:(BOOL)animated;

@end
