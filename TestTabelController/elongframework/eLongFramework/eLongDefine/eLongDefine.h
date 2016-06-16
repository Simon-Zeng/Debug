//
//  eLongDefine.h
//  eLongFramework
//
//  Created by Kirn on 15/5/12.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "UIColor+eLongExtension.h"
#import "eLongUserDefault.h"
#import "RegexKitLite.h"
#import "UIImage+eLongExtension.h"

#ifndef eLongFramework_eLongDefine_h
#define eLongFramework_eLongDefine_h

#define NAVBAR_WORDBTN_WIDTH    70              // 顶栏纯文字按钮宽度
#define NAVBAR_ITEM_HEIGHT      34              // 顶栏按钮控件高度
#define NAVBAR_ITEM_WIDTH       36              // 顶栏按钮控件宽度
#define TABITEM_DEFALUT_HEIGHT	35
#define NAVIGATION_BAR_HEIGHT	44
#define COLOR_NAV_TITLE			[UIColor colorWithHexStr:@"#555555"]  // 导航栏标题颜色及导航栏按钮不可点击时的颜色
#define COLOR_NAV_WHITE_TAG     1134
#define BOTTOM_BUTTON_WIDTH		280
#define BOTTOM_BUTTON_HEIGHT    46
#define NAVIGATION_BAR_HEIGHT	44
#define COEFFICIENT_Y   (!SCREEN_35_INCH ? 1.183 : 1)     // 视图控件y轴偏移量系数
#define SHOW_WINDOWS_DEFAULT_DURATION 0.3f
#define DefaultLeftEdgeSpace    12      //视图默认左边的间隔像素
#define HSC_CELL_HEGHT			49				// 酒店条件搜索界面cell高度
#define BLACK_BANNER_HEIGHT     50

#define USERDEFAULT_APP_CHANNELID                   @"APP_CHANNELID"                // 渠道号

#define USERDEFAULT_H5_CHANNERLID                   @"H5_CHANNELID"                 // h5渠道号

#define USERDEFAULT_H5_CHANNERLID_IHOTEL            @"H5_CHANNELID_IHOTEL"          // 国际酒店h5渠道号

// 标准的顶部工具条大小
#define STANDARDTOPBARFRAME		CGRectMake(0, 0, 320, 55)

#define FONTBOLD1 [UIFont boldSystemFontOfSize:18]
#define FONT_B17 [UIFont boldSystemFontOfSize:17]
#define FONT_B16 [UIFont boldSystemFontOfSize:16]
#define FONT_B12 [UIFont boldSystemFontOfSize:12]
#define FONT_B13 [UIFont boldSystemFontOfSize:13]
#define FONT_B15 [UIFont boldSystemFontOfSize:15]
#define FONT_13 [UIFont systemFontOfSize:13]
#define FONT_16 [UIFont systemFontOfSize:16]
#define FONT_15 [UIFont systemFontOfSize:15]
#define FONT_14  [UIFont systemFontOfSize:14]
#define FONT_B14 [UIFont boldSystemFontOfSize:14]
#define FONT_12  [UIFont systemFontOfSize:12]
#define FONT_11  [UIFont systemFontOfSize:11]
#define FONT_10  [UIFont systemFontOfSize:10]
#define FONT_17  [UIFont systemFontOfSize:17]
#define FONT_18	 [UIFont systemFontOfSize:18]
#define FONT_B18 [UIFont boldSystemFontOfSize:18]
#define FONT_20  [UIFont systemFontOfSize:20]
#define FONT_B20 [UIFont boldSystemFontOfSize:20]

// 判断系统版本是否大于x.x
#define IOSVersion_8            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOSVersion_9            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOSVersion_92           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.2f)

// 获取程序版本
#define APP_VERSION             ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])

#define SCREEN_WIDTH			([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT			([[UIScreen mainScreen] bounds].size.height)
#define MAINCONTENTHEIGHT       (SCREEN_HEIGHT - 20 - 44)
#define SCREEN_35_INCH  (SCREEN_HEIGHT == 480)
#define SCREEN_4_INCH   (SCREEN_HEIGHT == 568)      // 4寸Retina iPhone5
#define SCREEN_47_INCH  (SCREEN_HEIGHT == 667)      // 4.7       iPhone6
#define SCREEN_55_INCH  (SCREEN_HEIGHT == 736)      // 5.5       iPhone6+
#define SCREEN_SCALE    (1.0f/[UIScreen mainScreen].scale)
#define FITSCALE       (SCREEN_WIDTH/320.0)
#define NUMBER(x)				[NSNumber numberWithInteger:x]

// 返回通用按钮按下效果图
#define COMMON_BUTTON_PRESSED_IMG	[UIImage stretchableImageWithPath:@"framework_cell_bg.png"]
#define COMMON_BUTTON_PRESSED_TRANSPARENT   [UIImage stretchableImageWithPath:@"btn_pressed_ transparent.png"]


#define STRINGHASVALUE(str)		(str && [str isKindOfClass:[NSString class]] && [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
#define OBJECTISNULL(obj)       [obj isEqual:[NSNull null]]
// 判断数组是否有值
#define ARRAYHASVALUE(array)    (array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
// 判断可变数组是否有值
#define MUTABLEARRAYHASVALUE(array)    (array && [array isKindOfClass:[NSMutableArray class]] && [array count] > 0)

// 判断字典是否有值
#define DICTIONARYHASVALUE(dic)    (dic && [dic isKindOfClass:[NSDictionary class]] && [dic count] > 0)

#define RGBCOLOR(r,g,b,a)       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]    // 便利的RGB构造方法
#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define COLOR_NAV_BTN_TITLE     [UIColor colorWithHexStr:@"#777777"]      //导航栏文字按钮文字颜色
#define COLOR_NAV_BTN_TITLE_H   [UIColor colorWithHexStr:@"#777777" alpha:0.6f]
#define COLOR_NAV_BTN_TITLE_DISABLE RGBCOLOR(137, 137, 137, 1)
#define COLOR_NAV_BTN_TITLE_BLUE [UIColor colorWithHexStr:@"#4499ff"]  //导航栏文字按钮蓝色文字颜色
#define COLOR_NAV_BTN_TITLE_BLUE_H   [UIColor colorWithHexStr:@"#4499ff"]   //导航栏文字按钮蓝色文字颜色

#define COLOR_BTN_TITLE         RGBCOLOR(210, 70, 36, 1)  //其他按钮，如确认、取消按钮文字颜色
#define COLOR_BTN_TITLE_H       RGBCOLOR(228, 144, 124, 1)
#define COLOR_NAV_TITLE_WHITE   [UIColor colorWithHexStr:@"#343434"]

#define COLOR_CELL_LABEL        [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

#define COLOR_BTN_TITLE         RGBCOLOR(210, 70, 36, 1)  //其他按钮，如确认、取消按钮文字颜色

#define EDGE_NAV_LEFTITEM   UIEdgeInsetsMake(0, -12, 0, 12)//IOSVersion_7 ? UIEdgeInsetsMake(0, -12, 0, 12) : UIEdgeInsetsMake(0, -2, 0, 2)
#define EDGE_NAV_RIGHTITEM  UIEdgeInsetsMake(0, 12, 0, -12)//IOSVersion_7 ? UIEdgeInsetsMake(0, 12, 0, -12) : UIEdgeInsetsMake(0, 2, 0, -2)

// 常用TAG
#define kTableTag				3001
#define kArrowTag				3002
#define kCellLabelTag			3003
#define kSeparatorTag			3004
#define kRequest_More			3005
#define kDashedTag				3006
#define kBackBtnTag				3007

#define kNetTypeNativeHotel     3101
#define kNetTypeInterHotel      3102
#define kNetTypeFlight          3103
#define kNetTypeGroupon         3104
#define kNetTypeTrain           3105
#define kNetTypeCheckPassword   3106

#define kNetTypeTrainCreditCardPay           3107
#define kNetTypeHotelCreditCardPay           3108

// Keychain
#define KEYCHAIN_GUID                           @"GUID"         // 替代UDID
#define USERDEFAULT_KEYCHAIN_GUID               @"ELONG_GUID"   // 存入userdefault
#define KEYCHAIN_ACCOUNT                        @"Account"      // 用户名
#define KEYCHAIN_PASSWORD                       @"Password"     // 密码

#define KEYCHAIN_12306_ACCOUNT                        @"Elong12306Account"      // 用户名
#define KEYCHAIN_12306_PASSWORD                       @"Elong12306Password"     // 密码
#define KEYCHAIN_12306_USERTOKEN                      @"Elong12306Usertoken"    // token

#define APP_NAME        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

#define _string(x)  NSLocalizedString(x, nil)

// 检查字符串是否为英文和数字组成的字符串
#define ENANDNUMISRIGHT(word) ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[A-Za-z0-9\\\\s\\n]+$'"] evaluateWithObject:word])

#define STRINGISNUMBER(str)		([[NSPredicate predicateWithFormat:@"SELF MATCHES '[0-9]+'"] evaluateWithObject:str])

#define MOBILEPHONEISHONGAOTAIRIGHT(phoneStr)  ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^1[0-9]{10}$'"] evaluateWithObject:phoneStr]||[[NSPredicate predicateWithFormat:@"SELF MATCHES '^852[0-9]{8}$'"] evaluateWithObject:phoneStr]||[[NSPredicate predicateWithFormat:@"SELF MATCHES '^853[0-9]{8}$'"] evaluateWithObject:phoneStr]||[[NSPredicate predicateWithFormat:@"SELF MATCHES '^886[0-9]{9}$'"] evaluateWithObject:phoneStr])
#define   MOBILEPHONEISONLYHONGAOTAIRIGHT(phoneStr)   ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^852[0-9]{8}$'"] evaluateWithObject:phoneStr]||[[NSPredicate predicateWithFormat:@"SELF MATCHES '^853[0-9]{8}$'"] evaluateWithObject:phoneStr]||[[NSPredicate predicateWithFormat:@"SELF MATCHES '^886[0-9]{9}$'"] evaluateWithObject:phoneStr])
// 判断手机号码是否正确
#define MOBILEPHONEISRIGHT(phoneStr) ([[NSPredicate predicateWithFormat:@"SELF MATCHES '1\\\\d{10}'"] evaluateWithObject:phoneStr])

// 检查字符串是否为有效的email地址
#define EMAILISRIGHT(emailStr) ([emailStr isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"])

#define USERDEFUALT_HOTEL_SEARCHKEYWORD             @"HOTEL_SEARCHKEYWORD"          // 记录酒店搜索历史
// 酒店关键词搜索历史记录数量
#define HOTEL_KEYWORDHISTORY_NUM    3
//团购最大价格
#define GrouponMaxMaxPrice 9999999

//app状态一系列通知
#define NOTI_ApplicationDidEnterBackgroundNotification       @"eLongUIApplicationDidEnterBackgroundNotification"
#define NOTI_ApplicationWillEnterForegroundNotification      @"eLongUIApplicationWillEnterForegroundNotification"
#define NOTI_ApplicationDidBecomeActiveNotification          @"eLongUIApplicationDidBecomeActiveNotification"
#define NOTI_ApplicationWillResignActiveNotification         @"eLongUIApplicationWillResignActiveNotification"
#define NOTI_ApplicationDidReceiveMemoryWarningNotification  @"eLongUIApplicationDidReceiveMemoryWarningNotification"
#define NOTI_ApplicationWillTerminateNotification            @"eLongUIApplicationWillTerminateNotification"
#define NOTI_ApplicationDidFinishLaunchingNotification       @"eLongUIApplicationDidFinishLaunchingNotification"

// 登录相关
#define NOTI_LOGINSUCCESS                       @"NOTI_LOGINSUCCESS"                    // 登录成功
#define NOTI_SESSIONTOKENEXPIRED                @"NOTI_SESSIONTOKENEXPIRED"             // sessionToken过期
#define NOTI_NOMEMBERBOOK                       @"NOTI_NOMEMBERBOOK"                    // 非会员预定通知
#define NOTI_LOGINCANCEL                        @"NOTI_LOGINCANCEL"                     // 取消登录
#define NOTI_LOGINSETTING                       @"NOTI_LOGINSETTING"                    // 登录设置
#define SESSION_TOKEN                           @"SessionToken"
#define NOTI_WEIXIN_OAUTHSUCCESS                @"NOTI_WEIXIN_OAUTHSUCCESS"             // 微信授权成功
#define NOTI_USERCASHINFOUPDATE                 @"NOTI_USERCASHINFOUPDATE"              // 现金账户更新

#define LOGIN_NOTI_LOGOUT                       @"LOGIN_NOTI_LOGOUT"
#define LOGIN_NOTI_LOGIN                        @"LOGIN_NOTI_LOGIN"
#define LOGIN_NOTI_EXPIRED                      @"LOGIN_NOTI_EXPIRED"

#define NOTI_WEIXIN_OAUTHSUCCESS                @"NOTI_WEIXIN_OAUTHSUCCESS"             // 微信授权成功
#define NOTI_USERCASHINFOUPDATE                 @"NOTI_USERCASHINFOUPDATE"              // 现金账户更新
#define NOTI_USERCENTERCOUNTCHANGED             @"NOTI_USERCENTERCOUNTCHANGED"          // 点评、可反馈酒店、消息数量发生变化

#define NOTI_USER_LEVEL_PUSH                     @"NOTI_USER_LEVEL_PUSH"          // 获取用户等级通知

//接收刷新红包请求
#define  NOTI_UPDATE_REDPACKET     @"noti_update_redpacket"

#define CANT_TEL_TIP				            @"当前设备不支持通话功能"

#define USERDEFAULT_SINAWB_UID                  @"SINAWB_UID"                   //新浪微博唯一识别码UID
#define USERDEFAULT_SINAWB_ACCESSTOKEN          @"SINAWB_ACCESSTOKEN"           //新浪微博 accessToken
#define USERDEFAULT_SINAWB_EXPIRATIONDATE       @"SINAWB_EXPIRATIONDATE"        //新浪微博 expirationDate accessToken 过期时间
#define USERDEFAULT_WEIXIN_OPENID               @"WEIXIN_OPENID"                // 微信授权码
#define USERDEFAULT_WEIXIN_ACCESSTOKEN          @"WEIXIN_ACCESSTOKEN"           // 微信接口调用凭证
#define USERDEFAULT_WEIXIN_UNIONID              @"WEIXIN_UNIONID"               // 微信用户信息中得unionID
#define USERDEFAULT_WEIXIN_NICKNAME             @"nickname"                     // 微信用户信息中得unionID
#define USERDEFAULT_WEIXIN_HEADIMAGEURL         @"headimgurl"                 // 微信用户信息中得unionID

#define WEIXIN_ID   @"wx2a5825d706b3bb6a"
#define WEIXIN_KEY  @"278f7c0cd5880644d322aaf214c8a4c6"


//国际酒店appKill保存城市选择通知
#define NOTI_APPKILLED_SAVECACHE_IHOTEL         @"NOTI_APPKILLED_SAVECACHE_IHOTEL"   



/**
 常用发票抬头回调操作类型宏定义字段
 */
#define INVOICE_OPTION_TYPE            @"invoice_option_type"

typedef enum : NSUInteger {
    elongMyElongInvoiceOptionType_add,
    elongMyElongInvoiceOptionType_modify,
    elongMyElongInvoiceOptionType_delete,
    elongMyElongInvoiceOptionType_select,
} elongMyElongInvoiceOptionType;

/**
 * 常用邮寄地址回调操作类型宏定义字段
 */
#define ADDRESS_OPTION_TYPE            @"address_option_type"

typedef enum : NSUInteger {
    elongMyElongAddressOptionType_add,
    elongMyElongAddressOptionType_modify,
    elongMyElongAddressOptionType_delete,
    elongMyElongAddressOptionType_select,
} elongMyElongAddressOptionType;

typedef NS_ENUM(NSUInteger, AccessTokenRequestType){
    FEEDBACK,       //入住反馈获取Token
    MODIFTYORDER    //修改订单获取Token
};

#endif
