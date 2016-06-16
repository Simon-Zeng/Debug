//
//  ElongBaseViewController.h
//  ElongClient
/*  替代原来项目里的DPNav，封装所有viewcontroller公共逻辑部分的代码；
 *  本类默认不实现viewDidUnload方法，由子类继承实现；
 *  默认使用ARC
 */
//
//  Created by 赵 海波 on 13-12-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "eLongDefine.h"
#import "UIColor+eLongExtension.h"

#define ELONBASEVC_NOTI_BACKHOME   @"ELONBASEVC_NOTI_BACKHOME"    // 返回首页


typedef enum {
    BarButtonStyleCancel,         // 取消风格(白底蓝字)
    BarButtonStyleConfirm         // 确认风格(蓝底白字)
}BarButtonStyle;

@interface UIBarButtonItem (Public)

// 返回新版本设计navigationBar中纯文字左边的buttonItem
+ (id)navBarLeftButtonItemWithTitle:(NSString *)title
                             Target:(id)target
                             Action:(SEL)selector;

// 返回新版本设计navigationBar中纯文字右边的buttonItem
+ (id)navBarRightButtonItemWithTitle:(NSString *)title
                              Target:(id)target
                              Action:(SEL)selector;

// 返回新版本设计navigationBar中纯文字右边蓝色的buttonItem
+ (id)navBarRightBlueButtonItemWithTitle:(NSString *)title
                                  Target:(id)target
                                  Action:(SEL)selector;

// 返回页面右上角有2个按钮的item
+ (id)navBarTwoButtonItemWithTarget:(id)target
                     leftButtonIcon:(NSString *)leftIconPath
                   leftButtonAction:(SEL)leftSelector
                          rightIcon:(NSString *)rightIconPath
                  rightButtonAction:(SEL)rightSelector;

/**
 *  @return 返回页面右上角有2个按钮的item -有传入高亮时图片路径参数
 */
+ (id)navBarTwoButtonItemWithTarget:(id)target
                     leftButtonIcon:(NSString *)leftIconPath
               selectLeftButtonIcon:(NSString *)selectLeftIconPath
                   leftButtonAction:(SEL)leftSelector
                          rightIcon:(NSString *)rightIconPath
                    selectRightIcon:(NSString *)selectRightIconPath
                  rightButtonAction:(SEL)rightSelector;

// 返回统一高宽字体的常用barbutton
+ (id)uniformWithTitle:(NSString *)title Style:(BarButtonStyle)style Target:(id)target Selector:(SEL)method;

@end


@interface UINavigationItem (Public)

@end

typedef enum {
    NavBarBtnStyleNormalBtn = 0,
    NavBarBtnStyleNoBackBtn,
    NavBarBtnStyleOnlyBackBtn,
    NavBarBtnStyleOnlyHomeBtn,
    NavBarBtnStyleCalendarBtn,
    NavBarBtnStyleBackShareHomeTel,
    NavBarBtnStyleNoTel,
    NavBarBtnStyleBackShare,
    NavBarBtnStyleOlnyHotel,
    NavBarBtnStyleOnlyCloseBtn,
    NavBarBtnStyleCloseBtnAndClearBtn,
}NavBarBtnStyle;      // 顶部导航栏样式

@interface ElongBaseViewController : UIViewController<UIActionSheetDelegate>{
    
}

/**
 *  通过Title和按钮样式初始化
 *
 *  @param titleStr 显示Title
 *  @param style    按钮样式
 *
 *  @return self
 */
- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style;
/**
 *  设置headerView的icon
 *
 *  @param backicon          返回icon
 *  @param backSelectIcon    选择状态下的返回icon
 *  @param telicon           电话icon
 *  @param telSelectIcon     选择状态下的电话icon
 *  @param homeicon          主页icon
 *  @param homeSelectIcon    选择状态下的主页icon
 */
- (void)headerView:(NSString *)backicon
    backSelectIcon:(NSString *)backSelectIcon
           telicon:(NSString *)telicon
     telSelectIcon:(NSString *)telSelectIcon
          homeicon:(NSString *)homeicon
    homeSelectIcon:(NSString *)homeSelectIcon;
/**
 *  通过Title和按钮样式初始化nib
 *
 *  @param nibName  xib名字
 *  @param bundle   bundle名字
 *  @param titleStr 显示Title
 *  @param style    按钮样式
 *
 *  @return self
 */
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)titleStr style:(NavBarBtnStyle)style;
/**
 *  支持路由协议的初始化
 *
 *  @param titleStr 显示title
 *  @param style    按钮样式
 *  @param params   参数列表
 *
 *  @return self
 */
- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style params:(NSDictionary *)params;
/**
 *  拨打客服电话
 */
- (void) calltel400;

/**
 *  设置Title
 *
 *  @param title 现实Title
 */
- (void)setNavTitle:(NSString *)title;

/**
 *  获取Title
 *
 *  @return 返回title
 */
- (NSString *)getNavTitle;

/**
 *  返回导航到上一级
 */
- (void)back;

/**
 *  返回首页
 */
- (void)backhome;

/**
 *  关闭本页
 */
- (void)close;

/**
 *  清除数据
 */
- (void)clearData;


/**
 *  在未请求到数据时显示在页面上的提示信息，如果tips=nil则隐藏
 *
 *  @param tips 提示信息
 */
- (void) showEmptyTips:(NSString *)tips;

/**
 *  开启默认加载符
 */
- (void) startLoading;

/**
 *  停止默认加载符
 */
- (void) stopLoading;

/**
 *  开启阻断式加载符
 */
- (void)startBlockLoading;

/**
 *  停止阻断式加载符
 */
- (void)stopBlockLoading;

#pragma mark - 新版加载框
/**
 *  新版开启默认加载符
 */
- (void)startAnimationLoading;

/**
 *  新版停止默认加载符
 */
- (void)stopAnimationLoading;

/**
 *  新版开启阻断式加载符
 */
- (void)startAnimationBlockLoading;

/**
 *  新版停止阻断式加载符
 */
- (void)stopAnimationBlockLoading;


-(void) addTopImageAndTitle:(NSString *)imgPath andTitle:(NSString *)titleStr;

- (void)setShowBackBtn:(BOOL)flag;

- (void)setshowTelAndHome;

-(void) setshowHome;

- (void)setshowShareAndHome;

- (void)setshowNormaltpyewithouthtel;

@end
