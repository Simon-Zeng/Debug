//
//  elongRefreshCustomHeader.m
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRefreshCustomHeader.h"

@interface eLongRefreshCustomHeader()

@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UIView *animationContentView;
@property (nonatomic, assign) float insetHeight;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic,strong) UIImageView *imageView0;
@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UIImageView *imageView2;

@end

@implementation eLongRefreshCustomHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.height = 44;
    self.offset = CGPointMake(0, -44);
    self.animationContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.offset.y, SCREEN_WIDTH, 44)];
    [self addSubview:self.animationContentView];
    self.animationContentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    self.animationContentView.clipsToBounds = YES;
    self.animationContentView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:self.animationContentView.bounds];
    self.imageView1 = imageView1;
    imageView1.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1];
    imageView1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    [self.animationContentView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -self.animationContentView.frame.size.height, self.animationContentView.bounds.size.width, self.animationContentView.bounds.size.height)];
    self.imageView2 = imageView2;
    imageView2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    imageView2.backgroundColor = [UIColor colorWithRed:252.0/255 green:37.0/255 blue:13.0/255 alpha:1];
    [self.animationContentView addSubview:imageView2];
    
    UIImageView *imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, self.animationContentView.frame.size.width, 46)];
    self.imageView0 = imageView0;
    if (SCREEN_35_INCH || SCREEN_4_INCH) {
        imageView0.image = [UIImage imageNamed:@"eLong_pull_refresh"];
    }else if(SCREEN_47_INCH){
        imageView0.image = [UIImage imageNamed:@"eLong_pull_refresh_6"];
    }else if(SCREEN_55_INCH){
        imageView0.image = [UIImage imageNamed:@"eLong_pull_refresh_6p"];
    }
    [self.animationContentView addSubview:imageView0];
    imageView0.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    
    self.animationView = imageView2;
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-44-20, 0, 44, 46)];
    self.loadingView.backgroundColor =  [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];;
    [self.animationContentView addSubview:self.loadingView];
    
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activeView.frame = CGRectMake(0, 0, 20, 20);
    [self.loadingView addSubview:activeView];
    activeView.center = CGPointMake(self.loadingView.frame.size.width/2, self.loadingView.frame.size.height/2 - 1);
    [activeView startAnimating];
    self.loadingView.hidden = YES;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.animationContentView.frame = self.bounds;
    self.imageView0.frame = CGRectMake(0, -1, self.animationContentView.frame.size.width, 46);
    self.imageView1.frame = self.animationContentView.bounds;
    self.imageView2.frame = CGRectMake(0, -self.animationContentView.frame.size.height, self.animationContentView.bounds.size.width, self.animationContentView.bounds.size.height);
    self.loadingView.frame = CGRectMake(SCREEN_WIDTH / 2 - 64, 0, 44, 46);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(refreshState)state
{
    refreshCheckState;
    
    switch (state) {
        case refreshStateIdle:
            self.loadingView.hidden = YES;
            break;
        case refreshStatePulling:
            break;
        case refreshStateRefreshing:
            self.loadingView.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    self.animationView.height = pullingPercent * 88;
}

@end
