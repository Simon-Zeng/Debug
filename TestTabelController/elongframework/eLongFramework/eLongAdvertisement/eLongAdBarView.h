//
//  eLongAdBarView.h
//  ElongClient
//
//  Created by Dawn on 14-8-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongAdBusiness.h"
#import "eLongAdvInfoModel.h"
@protocol eLongAdBarViewDelegate;
@interface eLongAdBarView : UIView
//用包含eLongAdvInfoModel的模型数组加载视图
- (void) loadAdsWithAdvInfo:(NSArray<eLongAdvInfoModel> *)advInfoArray
               defaultImage:(UIImage *)image;

//一般直接使用此方法即可(包含请求banner)
- (void) loadAdsWitCountry:(NSString *)country
                      city:(NSString *)city
                  pageType:(AdPageType)pageType
              defaultImage:(UIImage *)image;

@property (nonatomic,assign) id<eLongAdBarViewDelegate> delegate;
@property (nonatomic,assign) NSTimeInterval timeInterval;
@property (nonatomic,strong) UIPageControl *pageControl;

@end

@protocol eLongAdBarViewDelegate <NSObject>

@optional
/**
 *  若返回No 不跳转H5
 *
 *  @param infoModel 点击的model
 *
 */
- (BOOL) eLongAdBarView:(eLongAdBarView *)AdBarView
         didSelectIndex:(NSUInteger)index
         andAdInfoModel:(eLongAdvInfoModel *)infoModel;

@end