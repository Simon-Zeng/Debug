//
//  eLongGeographySelectModel.h
//  ElongClient]
//
//  Created by chenggong on 15/9/8.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElongBaseViewController.h"

@interface eLongGeographySelectModel : NSObject

/**
 *  UINavigationBar上显示的名字.
 */
@property (nonatomic, copy) NSString *navBarDisplayName;

/**
 *  UINavigationBar上显示的Button style.
 */
@property (nonatomic, assign) NavBarBtnStyle navBarBtnStyle;

/**
 *  是否显示定位.
 */
@property (nonatomic, assign) BOOL isLocationDisplay;

/**
 *  是否显示历史.
 */
@property (nonatomic, assign) BOOL isHistoryDisplay;

/**
 *  是否显示热点.
 */
@property (nonatomic, assign) BOOL isHotDisplay;

/**
 *  保存城市历史数量.
 */
@property (nonatomic, assign) NSInteger historyCityCount;

/**
 *  存储目录名.
 */
@property (nonatomic, copy) NSString *persistanceDirectoryName;

/**
 *  存储文件名.
 */
@property (nonatomic, copy) NSString *persistanceFileName;

/**
 *  数据持久化历史名.
 */
@property (nonatomic, copy) NSString *persistanceHistoryName;

/**
 *  数据持久化热门名.
 */
@property (nonatomic, copy) NSString *persistanceHotName;

/**
 *  UISearchBar placeholder.
 */
@property (nonatomic, copy) NSString *searchBarPlaceholder;

/**
 *  eLong打点地理选择页面名称.
 */
@property (nonatomic, copy) NSString *eLongCountlyGeographyPageName;

/**
 *  eLong打点地理选择Suggestion页面名称.
 */
@property (nonatomic, copy) NSString *eLongCountlyGeographySuggestionPageName;


/**
 *  城市选择页面frame.
 */
@property (nonatomic, assign) CGRect geographySelectViewFrame;

@end
