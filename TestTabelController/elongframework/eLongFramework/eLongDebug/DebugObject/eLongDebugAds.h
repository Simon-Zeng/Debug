//
//  eLongDebugAds.h
//  ElongClient
//
//  Created by Dawn on 15/4/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugObject.h"
#import "eLongDebugAdsModel.h"

@interface eLongDebugAds : eLongDebugObject
@property (nonatomic,strong,readonly) eLongDebugAdsModel *adsModel;
@property (nonatomic,strong,readonly) NSString *adsUrl;
/**
 *  添加广告
 *
 *  @param name 名字
 *  @param url  地址
 *
 *  @return 
 */
- (eLongDebugAdsModel *) addAdsName:(NSString *)name url:(NSString *)url;
/**
 *  移除广告
 *
 *  @param businessModel 广告Model
 */
- (void) removeAd:(eLongDebugAdsModel *)adsModel;
/**
 *  返回所有的业务线
 */
- (NSArray *) ads;
/**
 *  保存
 *
 *  @param 广告Model
 */
- (void) saveAds:(eLongDebugAdsModel *)adsModel;
@end
