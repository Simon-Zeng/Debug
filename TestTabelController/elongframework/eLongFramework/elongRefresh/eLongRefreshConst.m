//
//  elongRefreshConst.m
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

const CGFloat refreshHeaderHeight = 54.0;
const CGFloat refreshFooterHeight = 44.0;
const CGFloat refreshFastAnimationDuration = 0.25;
const CGFloat refreshSlowAnimationDuration = 0.4;

NSString *const refreshKeyPathContentOffset = @"contentOffset";
NSString *const refreshKeyPathContentInset = @"contentInset";
NSString *const refreshKeyPathContentSize = @"contentSize";
NSString *const refreshKeyPathPanState = @"state";

NSString *const refreshHeaderLastUpdatedTimeKey = @"refreshHeaderLastUpdatedTimeKey";

NSString *const refreshHeaderIdleText = @"下拉可以刷新";
NSString *const refreshHeaderPullingText = @"松开刷新";
NSString *const refreshHeaderRefreshingText = @"正在刷新数据中...";

NSString *const refreshAutoFooterIdleText = @"点击或上拉加载更多";
NSString *const refreshAutoFooterRefreshingText = @"正在加载...";
NSString *const refreshAutoFooterNoMoreDataText = @"亲，只有这么多了";

NSString *const refreshBackFooterIdleText = @"上拉可以加载更多";
NSString *const refreshBackFooterPullingText = @"松开立即加载更多";
NSString *const refreshBackFooterRefreshingText = @"正在加载更多的数据...";
NSString *const refreshBackFooterNoMoreDataText = @"亲，只有这么多了";