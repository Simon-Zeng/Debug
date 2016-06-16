//
//  eLongUIUtil.m
//  MyElong
//
//  Created by yangfan on 15/6/25.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "eLongUIUtil.h"
#import "eLongHotelPromotionInfoRequest.h"
#import "eLongAlertView.h"
#import "eLongNavigationAction.h"
#import "eLongCONST.h"
#import "eLongExtension.h"
#import "eLongBus.h"
#import "eLongLocation.h"
#import "eLongFileIOUtils.h"
#import "UIApplication+openURL.h"
#import "eLongDefine.h"


typedef enum {
    AutoMapNavigation,              // 高德地图
    BaiduMapNavigation,             // 百度地图
    GoogleMapNavigation,            // 谷歌地图
    AppleMapNavigation,             // 系统地图
    TencentMapNavigation            // 腾讯地图
}NavigationMapType;

@implementation eLongUIUtil

+ (UIImage *)getImageWithURL:(NSString *)urlPath {
    UIImage *newimage;
    if (![urlPath isEqual:[NSNull null]] && STRINGHASVALUE(urlPath) && [urlPath hasPrefix:@"http://"]) {
        NSURL *url			= [NSURL URLWithString:urlPath];
        newimage			= [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        if (!newimage) {
            newimage = [UIImage noCacheImageNamed:@"bg_nohotelpic.png"];
        }
    }
    else {
        newimage = [UIImage noCacheImageNamed:@"bg_nohotelpic.png"];
    }
    
    return newimage;
}

+ (void)closeSesameInView:(UIView *)nowView {
    [[eLongBus bus].rootViewController popToRootViewControllerAnimated:YES];
    [[eLongBus bus].navigationController popToRootViewControllerAnimated:NO];
    [eLongBus bus].navigationController = nil;
    
    // 促销频道统计
    eLongHotelPromotionInfoRequest *promotion = [eLongHotelPromotionInfoRequest sharedInstance];
    [promotion clear];
}

+ (void) closeSesameAnimated:(BOOL)animated{
    if (animated) {
        [[eLongBus bus].rootViewController popToRootViewControllerAnimated:YES];
        [[eLongBus bus].navigationController popToRootViewControllerAnimated:NO];
        [eLongBus bus].navigationController = nil;
    }else{
        [[eLongBus bus].rootViewController popToRootViewControllerAnimated:NO];
        [[eLongBus bus].navigationController popToRootViewControllerAnimated:NO];
        [eLongBus bus].navigationController = nil;
    }
    
    
    // 促销频道统计
    eLongHotelPromotionInfoRequest *promotion = [eLongHotelPromotionInfoRequest sharedInstance];
    [promotion clear];
}


+ (void)pushToMapWithDestName:(NSString *)destination {
    if (0 == [[eLongLocation sharedInstance] coordinate].latitude && 0 == [[eLongLocation sharedInstance] coordinate].longitude)
    {
        [eLongAlertView showAlertTitle:@"无法获取当前位置" Message:@"请稍候再试"];
        return;
    }
    if ([destination isEqual:[NSNull null]] || !STRINGHASVALUE(destination)) {
        [eLongAlertView showAlertTitle:@"未获取酒店位置信息" Message:nil];
        return;
    }
    
    NSString *theString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
                           [[eLongLocation sharedInstance] coordinate].latitude,[[eLongLocation sharedInstance] coordinate].longitude,
                           destination];
    
    theString = [theString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:theString];
    
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        [eLongAlertView showAlertTitle:@"您未安装Google Map或已卸载" Message:@"请重新安装"];
    }
    else {
        [[UIApplication sharedApplication] newOpenURL:url];
    }
}

+ (void)pushToMapWithDesLat:(double)latitude Lon:(double)longitude {
    if (0 == [[eLongLocation sharedInstance] coordinate].latitude && 0 == [[eLongLocation sharedInstance] coordinate].longitude)
    {
        [eLongAlertView showAlertTitle:@"无法获取当前位置" Message:@"请稍候再试"];
        return;
    }
    
    NSString *theString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
                           [[eLongLocation sharedInstance] coordinate].latitude,[[eLongLocation sharedInstance] coordinate].longitude,
                           latitude, longitude];
    
    theString = [theString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:theString];
    
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        [eLongAlertView showAlertTitle:@"您未安装Map或已卸载" Message:@"请重新安装"];
    }
    else {
        [[UIApplication sharedApplication] newOpenURL:url];
    }
}

+ (void) openMapListToDestination:(CLLocationCoordinate2D)destination title:(NSString *)title{
    if (!title) {
        title = @"";
    }
    
    eLongLocation *poiManager = [eLongLocation sharedInstance];
    
    NSString *appname = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:(NSString *)kCFBundleNameKey];
    NSString *scheme = @"elongIPhone";
    NSMutableArray *navList = [NSMutableArray array];
    
    
    // 高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appname,scheme,destination.latitude,destination.longitude] forKey:@"Url"];
        [dict setObject:[NSNumber numberWithInt:AutoMapNavigation] forKey:@"MapType"];
        [dict setObject:@"高德地图" forKey:@"Title"];
        [dict setObject:[NSNumber numberWithFloat:destination.latitude] forKey:@"lat"];
        [dict setObject:[NSNumber numberWithFloat:destination.longitude] forKey:@"lng"];
        [dict setObject:title forKey:@"Name"];
        [navList addObject:dict];
    }
    
    // 百度地图
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //        [dict setObject:[NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=%@&coord_type=gcj02",poiManager.myCoordinate.latitude,poiManager.myCoordinate.longitude,destination.latitude,destination.longitude,appname] forKey:@"Url"];
        [dict setObject:[NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=%@&coord_type=gcj02",poiManager.coordinate.latitude,poiManager.coordinate.longitude,destination.latitude,destination.longitude,appname] forKey:@"Url"];
        [dict setObject:[NSNumber numberWithInt:BaiduMapNavigation] forKey:@"MapType"];
        [dict setObject:@"百度地图" forKey:@"Title"];
        [dict setObject:[NSNumber numberWithFloat:destination.latitude] forKey:@"lat"];
        [dict setObject:[NSNumber numberWithFloat:destination.longitude] forKey:@"lng"];
        [dict setObject:title forKey:@"Name"];
        [navList addObject:dict];
    }
    
    // 腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //        [dict setObject:[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f",poiManager.myCoordinate.latitude,poiManager.myCoordinate.longitude,destination.latitude,destination.longitude] forKey:@"Url"];
        [dict setObject:[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f",poiManager.coordinate.latitude,poiManager.coordinate.longitude,destination.latitude,destination.longitude] forKey:@"Url"];
        
        [dict setObject:[NSNumber numberWithInt:TencentMapNavigation] forKey:@"MapType"];
        [dict setObject:@"腾讯地图" forKey:@"Title"];
        [dict setObject:[NSNumber numberWithFloat:destination.latitude] forKey:@"lat"];
        [dict setObject:[NSNumber numberWithFloat:destination.longitude] forKey:@"lng"];
        [dict setObject:title forKey:@"Name"];
        [navList addObject:dict];
    }
    
    // Google地图
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //        [dict setObject:[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=driving",poiManager.myCoordinate.latitude,poiManager.myCoordinate.longitude,destination.latitude,destination.longitude] forKey:@"Url"];
        
        [dict setObject:[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=driving",poiManager.coordinate.latitude,poiManager.coordinate.longitude,destination.latitude,destination.longitude] forKey:@"Url"];
        
        [dict setObject:[NSNumber numberWithInt:GoogleMapNavigation] forKey:@"MapType"];
        [dict setObject:@"Google Maps" forKey:@"Title"];
        [dict setObject:[NSNumber numberWithFloat:destination.latitude] forKey:@"lat"];
        [dict setObject:[NSNumber numberWithFloat:destination.longitude] forKey:@"lng"];
        [dict setObject:title forKey:@"Name"];
        [navList addObject:dict];
    }
    
    
    // 系统地图
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
                     [[eLongLocation sharedInstance] coordinate].latitude,[[eLongLocation sharedInstance] coordinate].longitude,
                     [title URLEncodedString]] forKey:@"Url"];
    [dict setObject:[NSNumber numberWithInt:AppleMapNavigation] forKey:@"MapType"];
    [dict setObject:@"苹果自带地图" forKey:@"Title"];
    [dict setObject:[NSNumber numberWithFloat:destination.latitude] forKey:@"lat"];
    [dict setObject:[NSNumber numberWithFloat:destination.longitude] forKey:@"lng"];
    [dict setObject:title forKey:@"Name"];
    [navList addObject:dict];
    
    [eLongNavigationAction sharedInstance].navActions = navList;
    UIActionSheet *navActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:[eLongNavigationAction sharedInstance] cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSDictionary *dict in navList) {
        [navActionSheet addButtonWithTitle:[dict objectForKey:@"Title"]];
    }
    [navActionSheet addButtonWithTitle:@"取消"];
    navActionSheet.cancelButtonIndex = navList.count;
    
    [navActionSheet showInView:[self mainWindow]];
}

+ (UIView *)addView:(NSString *)string{
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, 160 * COEFFICIENT_Y, 250, 50)];
    
    //	UIView *av = [[UIView alloc] initWithFrame:CGRectMake(35, 160, 250, 50)];
    
    UILabel *addStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 240, 40)];
    addStringLabel.backgroundColor = [UIColor clearColor];
    addStringLabel.text = string;
    addStringLabel.textColor        = RGBACOLOR(93, 93, 93, 1);
    addStringLabel.textAlignment = NSTextAlignmentCenter;
    [addStringLabel setFont:[UIFont boldSystemFontOfSize:16] ];
    [targetView addSubview:addStringLabel];
    
    [targetView setBackgroundColor:[UIColor clearColor]];
    
    return targetView;
}

+ (UIWindow *)mainWindow{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]){
        return [app.delegate window];
    }
    else{
        return [app keyWindow];
    }
}

//根据字体获得高度
+(CGFloat)labelHeightWithString:(NSString *)text Width:(int)width font:(UIFont *)font{
    CGSize fontSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    NSInteger height = fontSize.height<=21?21:fontSize.height+4;
    return height;
}

+(CGFloat)stringWithHeight:(NSString *)text Width:(int)width font:(UIFont *)font{
    CGSize fontSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    NSInteger height = fontSize.height;
    return height;
}

+(CGSize)stringWithSize:(NSString *)text Width:(int)width font:(UIFont *)font{
    CGSize fontSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    return fontSize;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font {
    return [text sizeWithAttributes:@{NSFontAttributeName:font}];
}

//给Label根据文本调整大小
+ (CGSize)getRightLabelSizeByText:(NSString *)str
                          strFont:(UIFont *)font
                         maxWidth:(CGFloat)width{
    CGSize valueSize;
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGSize textSize = [str sizeWithAttributes:dic];
    valueSize = textSize;
    if(textSize.width < width){
        
        valueSize = textSize;
    }
    else{
        valueSize.width = width;
        valueSize.height =[self labelHeightWithString:str  Width:width attributes:dic];
    }
    
    return valueSize;
    
}
//根据字体获得高度
+ (CGFloat)labelHeightWithString:(NSString *)text
                           Width:(CGFloat)width
                      attributes:(NSDictionary *)dic{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil];
    CGFloat height = rect.size.height;
    return height;
}
//计算有属性字符串的label的size
+ (CGSize)boundingHeightForWidth:(CGFloat)inWidth
            withAttributedString:(NSAttributedString *)string
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(inWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size;
}


//屏蔽掉一行字符串中的空格、换行、回车
+(NSString *)dealWithStringForRemoveSpaces:(NSString *)aStr{
    NSString *result = [aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    result = [result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return result;
}

+ (void)setButton:(UIButton *)button normalImage:(NSString *)normalImageName pressedImage:(NSString *)pressedImageName {
    [button setBackgroundColor:[UIColor clearColor]];
    
    UIImage *nImg = [UIImage noCacheImageNamed:normalImageName];
    [button setBackgroundImage:[nImg stretchableImageWithLeftCapWidth:nImg.size.width/2 topCapHeight:nImg.size.height/2]
                      forState:UIControlStateNormal];
    
    UIImage *hImg = [UIImage noCacheImageNamed:pressedImageName];
    [button setBackgroundImage:[hImg stretchableImageWithLeftCapWidth:hImg.size.width/2 topCapHeight:hImg.size.height/2]
                      forState:UIControlStateHighlighted];
}

///view use animation
+ (void)animationView:(UIView *)aView fromFrame:(CGRect)fromFrame
              toFrame:(CGRect)toFrame
                delay:(float)delayTime
             duration:(float)durationTime {
    [aView setFrame:fromFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		//UIViewAnimationCurveEaseOut:  slow at end
    [UIView setAnimationDelay:delayTime];						//delay Animation
    [UIView setAnimationDuration:durationTime];
    [aView setFrame:toFrame];
    [UIView commitAnimations];
}

///view use animation
+ (void)animationView:(UIView *)aView
                fromX:(float)fromX
                fromY:(float)fromY
                  toX:(float)toX
                  toY:(float)toY
                delay:(float)delayTime
             duration:(float)durationTime {
    
    [aView setFrame:CGRectMake(fromX, fromY, aView.frame.size.width, aView.frame.size.height)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		//UIViewAnimationCurveEaseOut:  slow at end
    [UIView setAnimationDelay:delayTime];						//delay Animation
    [UIView setAnimationDuration:durationTime];
    [aView setFrame:CGRectMake(toX, toY, aView.frame.size.width, aView.frame.size.height)];
    [UIView commitAnimations];
}
@end
