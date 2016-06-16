//
//  eLongAdBarView.m
//  ElongClient
//
//  Created by Dawn on 14-8-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongAdBarView.h"
#import "UIButton+WebCache.h"
#import "UIButton+eLongLoadImage.h"
#import "eLongDefine.h"
#import "UIImageView+Extension.h"
#import "eLongAdvInfoModel.h"
#import "eLongRoutes.h"
#import "NSTimer+Extension.h"

typedef enum {
    NavBarBtnStyleNormalBtn = 0,
    NavBarBtnStyleNoBackBtn,
    NavBarBtnStyleOnlyBackBtn,
    NavBarBtnStyleOnlyHomeBtn,
    NavBarBtnStyleCalendarBtn,
    NavBarBtnStyleBackShareHomeTel,
    NavBarBtnStyleNoTel,
    NavBarBtnStyleBackShare,
    NavBarBtnStyleOlnyHotel
}NavBarBtnStyle;      // 顶部导航栏样式
@interface eLongAdBarView()<UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *advInfoArray;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton *leftImageView;
@property (nonatomic,strong) UIButton *centerImageView;
@property (nonatomic,strong) UIButton *rightImageView;
@property (nonatomic,assign) NSInteger currentImageIndex;
@property (nonatomic,assign) NSInteger imageCount;
@property (nonatomic,strong) UIImage *placImage;


@end

@implementation eLongAdBarView

- (void) dealloc{
    self.advInfoArray = nil;
    [self.timer invalidate];
    self.timer = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexStr:@"ff5555"];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (UIButton *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_leftImageView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_leftImageView];
    }
    return _leftImageView;
}
- (UIButton *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerImageView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [_centerImageView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_centerImageView];
    }
    return _centerImageView;
}
- (UIButton *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightImageView.frame = CGRectMake(2 * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [_rightImageView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_rightImageView];
        
    }
    return _rightImageView;
}
- (void)loadAdsWitCountry:(NSString *)country city:(NSString *)city pageType:(AdPageType)pageType defaultImage:(UIImage *)image{
    __weak typeof(self) weakSelf = self;
    [eLongAdBusiness getAdvInfoWithCountry:country city:city pageType:pageType adInfoBlock:^(NSArray<eLongAdvInfoModel> *adInfos) {
        [weakSelf loadAdsWithAdvInfo:adInfos defaultImage:image];
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)loadAdsWithAdvInfo:(NSArray *)advInfoArray defaultImage:(UIImage *)image{
    self.advInfoArray = advInfoArray;
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    self.placImage = image;
    if (advInfoArray.count > 1) {
        eLongAdvInfoModel *leftModel = [advInfoArray objectAtIndex:(advInfoArray.count - 1)];
        eLongAdvInfoModel *centerModel = [advInfoArray objectAtIndex:0];
        eLongAdvInfoModel *rightModel = [advInfoArray objectAtIndex:1];
        [self.leftImageView eLongLoadBackgroundImageWithURL:[[NSURL alloc] initWithString:leftModel.picUrl] forState:UIControlStateNormal placeholderImage:image];
        [self.centerImageView eLongLoadBackgroundImageWithURL:[[NSURL alloc] initWithString:centerModel.picUrl] forState:UIControlStateNormal placeholderImage:image];
        [self.rightImageView eLongLoadBackgroundImageWithURL:[[NSURL alloc] initWithString:rightModel.picUrl] forState:UIControlStateNormal placeholderImage:image];
        
        self.currentImageIndex=0;
        //设置当前页
        self.pageControl.numberOfPages = advInfoArray.count;
        self.pageControl.currentPage=_currentImageIndex;
        self.pageControl.hidden = NO;
        self.pageControl.frame = CGRectMake(0, height - 20, width, 20);
        self.imageCount = advInfoArray.count;
        self.scrollView.contentSize=CGSizeMake((advInfoArray.count+1)*self.frame.size.width, self.frame.size.height) ;
        [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        [self startAutoPage];
    }else{
        eLongAdvInfoModel *leftModel = [advInfoArray firstObject];
        [self.leftImageView eLongLoadBackgroundImageWithURL:[[NSURL alloc] initWithString:leftModel.picUrl] forState:UIControlStateNormal placeholderImage:image];
        self.pageControl.hidden = YES;
        self.scrollView.contentSize=CGSizeMake(self.frame.size.width, self.frame.size.height) ;
        self.currentImageIndex = 0;
    }
    
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, width, SCREEN_SCALE)]];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, self.frame.size.height - SCREEN_SCALE, width, SCREEN_SCALE)]];
}

- (void) btnClick:(id)sender{
    eLongAdvInfoModel *infoModel = [self.advInfoArray objectAtIndex:self.currentImageIndex];
    if ([self.delegate respondsToSelector:@selector(eLongAdBarView:didSelectIndex:andAdInfoModel:)] && ![self.delegate eLongAdBarView:self didSelectIndex:self.currentImageIndex andAdInfoModel:infoModel]) {//有代理并设置不跳转
        return;
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:infoModel.jumpLink forKey:@"webUrl"];
        [dic setObject:infoModel.adName forKey:@"titleStr"];
        [dic setObject:@(NavBarBtnStyleOnlyBackBtn) forKey:@"style"];
        [eLongRoutes routeURL:[NSURL URLWithString:@"eLongWebViewJSBridge/webPage"] withParameters:dic];
        
    }
}
- (void)reloadImages{
    CGPoint offset=[self.scrollView contentOffset];
    if (offset.x>SCREEN_WIDTH) { //向右滑动
        self.currentImageIndex=(self.currentImageIndex+1)%self.imageCount;
    }else if(offset.x<SCREEN_WIDTH){ //向左滑动
        self.currentImageIndex=(self.currentImageIndex+self.imageCount-1)%self.imageCount;
    }
    eLongAdvInfoModel *centerModel = [self.advInfoArray objectAtIndex:self.currentImageIndex];
    eLongAdvInfoModel *leftModel = [self.advInfoArray objectAtIndex:(self.currentImageIndex+self.imageCount-1)%self.imageCount];
    eLongAdvInfoModel *rightModel = [self.advInfoArray objectAtIndex:(self.currentImageIndex+1)%self.imageCount];
    [self.leftImageView eLongLoadBackgroundImageWithURL:[[NSURL alloc] initWithString:leftModel.picUrl] forState:UIControlStateNormal placeholderImage:self.placImage];
    [self.centerImageView eLongLoadBackgroundImageWithURL:[[NSURL alloc] initWithString:centerModel.picUrl] forState:UIControlStateNormal placeholderImage:self.placImage];
    [self.rightImageView eLongLoadBackgroundImageWithURL:[[NSURL alloc] initWithString:rightModel.picUrl] forState:UIControlStateNormal placeholderImage:self.placImage];
}
- (void) startAutoPage{
    if (self.advInfoArray.count <= 1) {
        return;
    }
    if (self.timer) {
        [self.timer invalidate];
    }
    if (self.timeInterval <= 0) {
        self.timeInterval = 5.0f;
    }
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer eLongScheduledTimerWithTimeInterval:self.timeInterval block:^{
        [weakSelf timer];
    } repeats:YES];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerWork) userInfo:nil repeats:YES];
}
- (void)timerWork{
    //    return;
    if (self.advInfoArray.count <= 1) {
        return;
    }

    if(self.scrollView){
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.frame.size.width, 0) animated:YES];
    }
}

- (void) stopAutoPage{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
-(void) pageToIndex:(NSInteger)index{
    if (self.advInfoArray.count <= 1) {
        return;
    }
    
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self reloadImages];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    if (self.pageControl.numberOfPages >= 0 && self.pageControl.numberOfPages >= _currentImageIndex) {
        self.pageControl.currentPage = self.currentImageIndex;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self reloadImages];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    if (self.pageControl.numberOfPages >= 0 && self.pageControl.numberOfPages >= _currentImageIndex) {
        self.pageControl.currentPage = self.currentImageIndex;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopAutoPage];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startAutoPage];
}
@end
