//
//  elongRefreshFooter.h
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRefreshFooter.h"

@interface eLongRefreshAutoFooter : eLongRefreshFooter

/** 是否自动刷新(默认为YES) */
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh;

@end
