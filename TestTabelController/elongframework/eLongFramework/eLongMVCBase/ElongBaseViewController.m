//
//  ElongBaseViewController.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "NSString+eLongExtension.h"
#import "eLongDefine.h"
#import "ElongProgressIndicator.h"
#import "eLongBus.h"

#define kBackBtnTag				3007

@implementation UIBarButtonItem (Public)

+ (id)navBarLeftButtonItemWithTitle:(NSString *)title
                             Target:(id)target
                             Action:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)];
    btn.adjustsImageWhenDisabled = NO;
    btn.titleLabel.font = FONT_B15;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    switch (title.length)
    {
        case 2:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 16);
            break;
        case 3:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8);
            break;
        default:
            break;
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE_H forState:UIControlStateHighlighted];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE_DISABLE forState:UIControlStateDisabled];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}


+ (id)navBarRightButtonItemWithTitle:(NSString *)title
                              Target:(id)target
                              Action:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)];
    btn.adjustsImageWhenDisabled = NO;
    btn.titleLabel.font = FONT_B15;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    switch (title.length)
    {
        case 2:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, -16);
            break;
        case 3:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
            break;
        default:
            break;
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE_H forState:UIControlStateHighlighted];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE_DISABLE forState:UIControlStateDisabled];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (id)navBarRightBlueButtonItemWithTitle:(NSString *)title
                                  Target:(id)target
                                  Action:(SEL)selector{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)];
    btn.adjustsImageWhenDisabled = NO;
    btn.titleLabel.font = FONT_B15;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    switch (title.length)
    {
        case 2:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, -16);
            break;
        case 3:
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
            break;
        default:
            break;
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE_BLUE forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE_BLUE_H forState:UIControlStateHighlighted];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE_DISABLE forState:UIControlStateDisabled];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}


+ (id)uniformWithTitle:(NSString *)title Style:(BarButtonStyle)style Target:(id)target Selector:(SEL)method {
    float width = 50;
    if (title.length >= 4) {
        width = 70;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, TABITEM_DEFALUT_HEIGHT)];
    
    [button.titleLabel setFont:FONT_B16];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    if (style == BarButtonStyleCancel) {
        //[Utils setButton:button normalImage:@"white_btn_normal.png" pressedImage:@"white_btn_press.png"];
        [button setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
        [button setTitleColor:COLOR_NAV_BTN_TITLE_H forState:UIControlStateHighlighted];
    }
    else {
        //[Utils setButton:button normalImage:@"white_btn_press.png" pressedImage:@"white_btn_normal.png"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateHighlighted];
    }
    
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return buttonItem;
}


+ (id)navBarTwoButtonItemWithTarget:(id)target
                     leftButtonIcon:(NSString *)leftIconPath
                   leftButtonAction:(SEL)leftSelector
                          rightIcon:(NSString *)rightIconPath
                  rightButtonAction:(SEL)rightSelector {
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 44)];
    NSInteger offX = 3;
    // 左按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:target action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(offX, (buttonView.frame.size.height - NAVBAR_ITEM_HEIGHT) / 2, 46, NAVBAR_ITEM_HEIGHT);
    [leftBtn setImage:[UIImage imageNamed:leftIconPath] forState:UIControlStateNormal];
    
    // 右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(offX + NAVBAR_ITEM_WIDTH + 2, leftBtn.frame.origin.y, 35, NAVBAR_ITEM_HEIGHT);
    [rightBtn addTarget:target action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:rightIconPath] forState:UIControlStateNormal];
    
    [buttonView addSubview:leftBtn];
    [buttonView addSubview:rightBtn];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    return buttonItem;
}

+ (id)navBarTwoButtonItemWithTarget:(id)target
                     leftButtonIcon:(NSString *)leftIconPath
               selectLeftButtonIcon:(NSString *)selectLeftIconPath
                   leftButtonAction:(SEL)leftSelector
                          rightIcon:(NSString *)rightIconPath
                    selectRightIcon:(NSString *)selectRightIconPath
                  rightButtonAction:(SEL)rightSelector
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 44)];
    NSInteger offX = 3;
    // 左按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.exclusiveTouch = YES;
    [leftBtn addTarget:target action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(offX, (buttonView.frame.size.height - NAVBAR_ITEM_HEIGHT) / 2, NAVBAR_ITEM_WIDTH, NAVBAR_ITEM_HEIGHT);
    [leftBtn setImage:[UIImage imageNamed:leftIconPath] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:selectLeftIconPath] forState:UIControlStateSelected];
    
    // 右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.exclusiveTouch = YES;
    rightBtn.frame = CGRectMake(offX + NAVBAR_ITEM_WIDTH + 2,(buttonView.frame.size.height - NAVBAR_ITEM_HEIGHT) / 2, 35, NAVBAR_ITEM_HEIGHT);
    [rightBtn addTarget:target action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn setImage:[UIImage imageNamed:rightIconPath] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:selectRightIconPath] forState:UIControlStateSelected];
    [buttonView addSubview:leftBtn];
    [buttonView addSubview:rightBtn];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    return buttonItem;
}

@end


@implementation UINavigationItem (Public)

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem {
//    if (IOSVersion_7) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -12;
        
        if (_leftBarButtonItem) {
            [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem]];
        }else {
            [self setLeftBarButtonItems:@[spaceButtonItem]];
        }
//    }else {
//        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
//    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem {
//    if (IOSVersion_7) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -12;
        
        if (_rightBarButtonItem) {
            [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem]];
        }else {
            [self setRightBarButtonItems:@[spaceButtonItem]];
        }
//    }else {
//        [self setRightBarButtonItem:_rightBarButtonItem animated:NO];
//    }
}
#endif

@end


@interface ElongBaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) NavBarBtnStyle style;
@property (nonatomic, copy) NSString *teliconstring;
@property (nonatomic, copy) NSString* telSelectIconstring;
@property (nonatomic, strong) UILabel *emptyTipsLbl;
@property (nonatomic, strong) UIView *smallLoadingView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) ElongProgressIndicator *progressIndicator;
@end

@implementation ElongBaseViewController
#pragma mark - Init Methods

- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style params:(NSDictionary *)params{
    return [self initWithTitle:titleStr style:style];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)titleStr style:(NavBarBtnStyle)style
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.style = style;
        self.title = titleStr;
        switch (style) {
            case NavBarBtnStyleOlnyHotel: {
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:nil telSelectIcon:nil
                        homeicon:nil homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleNormalBtn: {
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:@"basevc_navtel_normal.png"
                   telSelectIcon:nil
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = @"basevc_navtel_normal.png";
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleNoBackBtn: {
                [self headerView:nil backSelectIcon:nil
                         telicon:@"basevc_navtel_normal.png"
                   telSelectIcon:nil
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = @"basevc_navtel_normal.png";
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleOnlyBackBtn:{
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:nil telSelectIcon:nil
                        homeicon:nil homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleOnlyHomeBtn: {
                [self headerView:nil
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleCalendarBtn: {
                //[self calendarHeaderView:@"basevc_navback_normal.png" backSelectIcon:nil
                //							   todayicon:@"btn_default3_normal.png" todaySelectIcon:@"btn_default3_press.png"];
            }
                break;
            case NavBarBtnStyleBackShareHomeTel: {
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:@"share"
                   telSelectIcon:@"share"
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = @"share";
                self.telSelectIconstring = @"share";
            }
                break;
            case NavBarBtnStyleNoTel: {
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleBackShare:{
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navshare_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleOnlyCloseBtn:{
                [self headerView:nil
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navtel_close"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleCloseBtnAndClearBtn:{
                [self headerView:nil
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navtel_close"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            default:
                break;
        }
        [self addTopImageAndTitle:nil andTitle:titleStr];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style {
    if (self = [super init]) {
        self.style = style;
        self.title = titleStr;
        switch (style) {
            case NavBarBtnStyleOlnyHotel: {
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:nil telSelectIcon:nil
                        homeicon:nil homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleNormalBtn: {
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:@"basevc_navtel_normal.png"
                   telSelectIcon:nil
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = @"basevc_navtel_normal.png";
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleNoBackBtn: {
                [self headerView:nil backSelectIcon:nil
                         telicon:@"basevc_navtel_normal.png"
                   telSelectIcon:nil
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = @"basevc_navtel_normal.png";
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleOnlyBackBtn:{
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:nil telSelectIcon:nil
                        homeicon:nil homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleOnlyHomeBtn: {
                [self headerView:nil
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleCalendarBtn: {
                //[self calendarHeaderView:@"basevc_navback_normal.png" backSelectIcon:nil
                //							   todayicon:@"btn_default3_normal.png" todaySelectIcon:@"btn_default3_press.png"];
            }
                break;
            case NavBarBtnStyleBackShareHomeTel: {
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:@"share"
                   telSelectIcon:@"share"
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = @"share";
                self.telSelectIconstring = @"share";
            }
                break;
            case NavBarBtnStyleNoTel: {
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navhome_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleBackShare:{
                [self headerView:@"basevc_navback_normal.png"
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navshare_normal.png"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleOnlyCloseBtn:{
                [self headerView:nil
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navtel_close"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            case NavBarBtnStyleCloseBtnAndClearBtn:{
                [self headerView:nil
                  backSelectIcon:nil
                         telicon:nil
                   telSelectIcon:nil
                        homeicon:@"basevc_navtel_close"
                  homeSelectIcon:nil];
                self.teliconstring = nil;
                self.telSelectIconstring = nil;
            }
                break;
            default:
                break;
        }
        [self addTopImageAndTitle:nil andTitle:titleStr];
    }
    
    return self;
}


#pragma mark - end

- (void)headerView:(NSString *)backicon
    backSelectIcon:(NSString *)backSelectIcon
           telicon:(NSString *)telicon
     telSelectIcon:(NSString *)telSelectIcon
          homeicon:(NSString *)homeicon
    homeSelectIcon:(NSString *)homeSelectIcon {
    if (backicon!=nil) {
        UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backbtn.frame = CGRectMake(0, 0, 48, 34);
        [backbtn setImage:[UIImage imageNamed:backicon] forState:UIControlStateNormal];
        [backbtn setImage:[UIImage imageNamed:backSelectIcon] forState:UIControlStateHighlighted];
        backbtn.exclusiveTouch = YES;
        [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backbarbuttonitem;
    } else {
        UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
        backbtn.exclusiveTouch = YES;
        if (self.style == NavBarBtnStyleCloseBtnAndClearBtn) {
            backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backbtn.frame = CGRectMake(0, 0, 70, 34);
            [backbtn setTitle:@"清除选项" forState:UIControlStateNormal];
            [backbtn setTitleColor:[UIColor colorWithHexStr:@"#ff5555"] forState:UIControlStateNormal];
            backbtn.titleLabel.font = FONT_14;
            backbtn.exclusiveTouch = YES;
            [backbtn addTarget:self action:@selector(clearData) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        }

        UIBarButtonItem * backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backbarbuttonitem;
        
    }
    
    if (telicon && homeicon) {
        // 多按钮情况
        NSString *leftIcon = nil;
        SEL leftBtnaction;
        if ([telicon isEqualToString:@"share"]) {
            //leftIcon = @"basevc_navshare_normal.png";
            //leftBtnaction = @selector(shareInfo);
        }else {
            leftIcon = telicon;
            leftBtnaction = @selector(calltel400);
        }
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarTwoButtonItemWithTarget:self leftButtonIcon:leftIcon leftButtonAction:leftBtnaction rightIcon:homeicon rightButtonAction:@selector(backhome)];
    }
    //只有返回主页的按钮
    else if (homeicon) {
        if (self.style == NavBarBtnStyleOnlyCloseBtn
            || self.style == NavBarBtnStyleCloseBtnAndClearBtn) {
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarTwoButtonItemWithTarget:self leftButtonIcon:nil leftButtonAction:nil rightIcon:homeicon rightButtonAction:@selector(close)];
        }
        else{
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarTwoButtonItemWithTarget:self leftButtonIcon:nil leftButtonAction:nil rightIcon:homeicon rightButtonAction:@selector(backhome)];
        }
    }
}

- (void)clickNavRightBtn{
    
    
}

/**
 *  关闭本页
 */
- (void)close{

}

/**
 *  清除数据
 */
- (void)clearData{
    
}

- (void)cancelButtonPressed{
    [self.navigationController  popViewControllerAnimated:YES];
}

- (void)alertHeaderView:(NSString *)backicon
         backSelectIcon:(NSString *)backSelectIcon
                btnicon:(NSString *)btnicon
          btnSelectIcon:(NSString *)btnSelectIcon
              btnstring:(NSString *)btnstring {
    if (backicon!=nil) {
        UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
        backbtn.imageEdgeInsets = EDGE_NAV_LEFTITEM;
        backbtn.exclusiveTouch = YES;
        [backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backbtn setBackgroundImage:[UIImage imageNamed:backicon] forState:UIControlStateNormal];
        if (backSelectIcon != nil) {
            [backbtn setBackgroundImage:[UIImage imageNamed:backSelectIcon] forState:UIControlStateHighlighted];
        }
        UIBarButtonItem * backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backbarbuttonitem;
    } else {
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, 30)];
        cancelButton.exclusiveTouch = YES;
        [cancelButton.titleLabel setFont:FONT_B16];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:COLOR_BTN_TITLE forState:UIControlStateNormal];
        [cancelButton setTitleColor:COLOR_BTN_TITLE_H forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    
    if (btnicon!=nil) {
        UIButton *rightbtn;
        if ([btnstring length]<=2) {
            rightbtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
        }else if ([btnstring length]==3) {
            rightbtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 34)];
        }else {
            
            rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 34)];
        }
        
        rightbtn.exclusiveTouch = YES;
        [rightbtn setTitle:btnstring forState:UIControlStateNormal];
        [rightbtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
        [[rightbtn titleLabel] setFont:FONT_B16];
        
        [rightbtn addTarget:self action:@selector(clickNavRightBtn) forControlEvents:UIControlEventTouchUpInside];
        [rightbtn setBackgroundImage:[UIImage imageNamed:btnicon] forState:UIControlStateNormal];
        if (btnSelectIcon != nil) {
            [rightbtn setBackgroundImage:[UIImage imageNamed:btnSelectIcon] forState:UIControlStateHighlighted];
        }
        UIBarButtonItem * rightbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
        self.navigationItem.rightBarButtonItem = rightbarbuttonitem;
    }
    else {
        UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
        rightbtn.exclusiveTouch = YES;
        UIBarButtonItem *rightbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
        self.navigationItem.rightBarButtonItem = rightbarbuttonitem;
    }
    
}

- (void) back{
    @try {
        [self.view endEditing:YES];
    }
    @catch (NSException *ex){
        NSLog(@"%@", ex.reason);
    }
    if (self.progressIndicator) {
        [self.progressIndicator dismiss];
    }
    if (self.navigationController.viewControllers.count == 1) {
        [self backhome];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) calltel400{
    
}


- (void) backhome{
    if (self.progressIndicator) {
        [self.progressIndicator dismiss];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ELONBASEVC_NOTI_BACKHOME object:nil];
}

-(void) addTopImageAndTitle:(NSString *)imgPath andTitle:(NSString *)titleStr {
    UIView *topView = [[UIView alloc] init];
    
    int offX = 0;
    if ([imgPath notEmpty]) {
        UIImage *topImg = [UIImage imageNamed:imgPath];
        float imgWidth  = topImg.size.width;
        float imgHeight = topImg.size.height;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (44 - imgHeight)/2, imgWidth, imgHeight)];
        imgView.image = topImg;
        [topView addSubview:imgView];
        
        offX = imgWidth;
    }
    
    CGSize size = [titleStr sizeWithFont:FONT_B18];
    if (size.width >= 200) {
        size.width = 195;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 3, 12, size.width, 20)];
    label.tag = 101;
    label.backgroundColor	= [UIColor clearColor];
    label.font				= FONT_B18;
    label.textColor			= COLOR_NAV_TITLE;
    
    
    label.text				= titleStr;
    label.textAlignment		= NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 14.0f;
    
    topView.frame = CGRectMake(0, 0, size.width + offX + 5, 44);
    [topView addSubview:label];
    self.navigationItem.titleView = topView;
}

- (void)setNavTitle:(NSString *)title{
    
    CGSize size = [title sizeWithFont:FONT_B18];
    if (size.width >= 200) {
        size.width = 195;
    }
    
    if (self.navigationItem.titleView.frame.size.width < size.width) {
        self.navigationItem.titleView.frame = CGRectMake(self.navigationItem.titleView.frame.origin.x, self.navigationItem.titleView.frame.origin.y, size.width, self.navigationItem.titleView.frame.size.height);
    }
    
    UILabel *label = (UILabel *)[self.navigationItem.titleView viewWithTag:101];
    if (label.frame.size.width < size.width) {
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, label.frame.size.height);
    }
    label.text = title;
}

- (NSString *) getNavTitle{
    UILabel *label = (UILabel *)[self.navigationItem.titleView viewWithTag:101];
    return label.text;
}

- (void)setShowBackBtn:(BOOL)flag{
    if(flag){
        [self headerView:@"basevc_navback_normal.png" backSelectIcon:nil
                 telicon:nil telSelectIcon:nil
                homeicon:nil homeSelectIcon:nil];
    }else {
        [self headerView:nil backSelectIcon:nil
                 telicon:self.teliconstring telSelectIcon:self.telSelectIconstring
                homeicon:@"basevc_navhome_normal.png" homeSelectIcon:nil];
    }
    
}

-(void) setShowBackBtnWithNoHomeBtn:(BOOL)flag{
    if(flag){
        [self headerView:@"basevc_navback_normal.png" backSelectIcon:nil
                 telicon:nil telSelectIcon:nil
                homeicon:nil homeSelectIcon:nil];
    }else {
        [self headerView:nil backSelectIcon:nil
                 telicon:self.teliconstring telSelectIcon:self.telSelectIconstring
                homeicon:@"" homeSelectIcon:nil];
    }
}

-(void) setshowHome
{
    [self headerView:nil backSelectIcon:nil
             telicon:nil telSelectIcon:nil
            homeicon:@"basevc_navhome_normal.png" homeSelectIcon:nil];
}

- (void)setshowTelAndHome
{
    [self headerView:nil backSelectIcon:nil
             telicon:@"basevc_navtel_normal.png" telSelectIcon:nil
            homeicon:@"basevc_navhome_normal.png" homeSelectIcon:nil];
}

- (void)setshowShareAndHome
{
    [self headerView:nil backSelectIcon:nil
             telicon:@"share" telSelectIcon:@"share"
            homeicon:@"basevc_navhome_normal.png" homeSelectIcon:nil];
}

- (void)setshowNormaltpyewithouthtel
{
    [self headerView:@"basevc_navback_normal.png" backSelectIcon:nil
             telicon:nil telSelectIcon:nil
            homeicon:@"basevc_navhome_normal.png" homeSelectIcon:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        if (![[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault]) {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"basevc_navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
            [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"basevc_header_shadow.png"]];
        }
        
    }
#endif
    
    if (self.navigationController.navigationBar.tag == COLOR_NAV_WHITE_TAG) {
        NSLog(@"...................white.....................");

        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"basevc_dashed.png"]];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //iOS 7下，右滑返回手势打开 (由二级页面开始，防治页面假死现象)
//    if (IOSVersion_7) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            if ([self.navigationController.viewControllers count]==1) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }else{
                self.navigationController.interactivePopGestureRecognizer.enabled = YES;
                self.navigationController.interactivePopGestureRecognizer.delegate = self;
            }
        }
//    }
    
    //    if (IOSVersion_7 && ![self isKindOfClass:[MainPageController class]])
    //    {
    //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //        [self setNeedsStatusBarAppearanceUpdate];
    //    }
    
    if (self.navigationController.navigationBar.tag == COLOR_NAV_WHITE_TAG) {
        UILabel *label = (UILabel *)[self.navigationItem.titleView viewWithTag:101];
        label.textColor			= COLOR_NAV_TITLE_WHITE;

            UIBarButtonItem *item = self.navigationItem.leftBarButtonItem;
            if (item.customView) {
                UIView *customView = [item.customView viewWithTag:kBackBtnTag];
                if([customView isKindOfClass:[UIButton class]]){
                    UIButton *button = (UIButton *)customView;
                    [button setImage:[UIImage imageNamed:@"basevc_navback_normal_white.png"] forState:UIControlStateNormal];
                }
            }
    }
    
}

- (void) showEmptyTips:(NSString *)tips{
    if (!self.emptyTipsLbl) {
        self.emptyTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        self.emptyTipsLbl.backgroundColor = [UIColor clearColor];
        self.emptyTipsLbl.text = tips;
        self.emptyTipsLbl.textColor        = RGBACOLOR(93, 93, 93, 1);
        self.emptyTipsLbl.textAlignment = NSTextAlignmentCenter;
        [self.emptyTipsLbl setFont:[UIFont boldSystemFontOfSize:16] ];
        [self.view addSubview:self.emptyTipsLbl];
    }
    if (tips) {
        self.emptyTipsLbl.text = tips;
        self.emptyTipsLbl.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
        self.emptyTipsLbl.center = CGPointMake(SCREEN_WIDTH/2, MAINCONTENTHEIGHT/2);
        [self.view bringSubviewToFront:self.emptyTipsLbl];
        self.emptyTipsLbl.hidden = NO;
    }else{
        [self.view sendSubviewToBack:self.emptyTipsLbl];
        self.emptyTipsLbl.text = @"";
        self.emptyTipsLbl.hidden = YES;
    }
}

- (void) startLoading{
    if (!self.smallLoadingView) {
        self.smallLoadingView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-42)/2, (self.view.frame.size.height-42) / 2, 42, 42)];
        self.smallLoadingView.layer.cornerRadius = 5.0f;
        self.smallLoadingView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.smallLoadingView.center = CGPointMake(SCREEN_WIDTH/2, MAINCONTENTHEIGHT/2);
        [self.view addSubview:self.smallLoadingView];
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicatorView.hidesWhenStopped	= YES;
        self.indicatorView.center			= CGPointMake(self.smallLoadingView.frame.size.width / 2, self.smallLoadingView.frame.size.height / 2);
        [self.smallLoadingView addSubview:self.indicatorView];
    }
    [self.view bringSubviewToFront:self.smallLoadingView];
    self.smallLoadingView.center = CGPointMake(SCREEN_WIDTH/2, MAINCONTENTHEIGHT/2);
    
    if (self.smallLoadingView.hidden == YES) {
        self.smallLoadingView.hidden = NO;
        
    }
    [self.indicatorView startAnimating];
}

- (void) stopLoading {
    if (self.smallLoadingView.hidden == NO) {
        self.smallLoadingView.hidden = YES;
        
    }
    [self.indicatorView stopAnimating];
}

- (void)startBlockLoading {
    [self startLoading];
    self.view.userInteractionEnabled = NO;
}

- (void)stopBlockLoading {
    [self stopLoading];
    self.view.userInteractionEnabled = YES;
}

// 新版加载框
- (void)startAnimationLoading {
    if (!self.progressIndicator) {
        self.progressIndicator = [ElongProgressIndicator showWithView:self.view];
    }
    else {
        self.progressIndicator.overView = self.view;
    }
    [self.progressIndicator showLoading];
}

- (void)stopAnimationLoading {
    self.view.userInteractionEnabled = YES;
    if (self.progressIndicator) {
        [self.progressIndicator dismiss];
    }
}

- (void)startAnimationBlockLoading {
    if (!self.progressIndicator) {
        self.progressIndicator = [ElongProgressIndicator showClearWithView:self.view];
    }
    else {
        self.progressIndicator.overView = self.view;
    }
    [self.progressIndicator showClearLoading];
}

- (void)stopAnimationBlockLoading {
    self.view.userInteractionEnabled = YES;
    if (self.progressIndicator) {
        [self.progressIndicator dismiss];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
