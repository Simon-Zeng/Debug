//
//  eLongDebugAds.m
//  ElongClient
//
//  Created by Dawn on 15/4/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugAds.h"
#import "eLongDebugDB.h"

static NSString *adsDebugModelName = @"Ads";        // 广告储数据表名

@implementation eLongDebugAds
@synthesize adsModel = _adsModel;
/**
 *  添加广告
 *
 *  @param name 广告名
 *  @param tag  tag标识
 */
- (eLongDebugAdsModel *) addAdsName:(NSString *)name url:(NSString *)url{
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    
    // 先读取所有的ad标记为禁用状态
    NSArray *ads = [self ads];
    for (eLongDebugAdsModel *adModel in ads) {
        adModel.enabled = @(NO);
    }
    
    // 新增ads model
    eLongDebugAdsModel *adsModel = [debugDB insertEntity:adsDebugModelName];
    adsModel.name = name;
    adsModel.url = url;
    adsModel.enabled = @(YES);
    
    // 存储入库
    [debugDB saveContext];
    _adsModel = adsModel;
    return adsModel;
}

/**
 *  移除广告
 *
 *  @param 广告Model
 */
- (void) removeAd:(eLongDebugAdsModel *)adsModel{
    if (!self.enabled) {
        return;
    }
    if (_adsModel == adsModel) {
        _adsModel = nil;
    }
    
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB remove:adsModel];
    
    [debugDB saveContext];
}

/**
 *  返回所有的业务线
 */
- (NSArray *) ads{
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    NSArray *ads = [debugDB selectDataFromEntity:adsDebugModelName query:nil];
    if (ads && ads.count) {
        for (eLongDebugAdsModel *adsModel in ads) {
            if ([adsModel.enabled boolValue]) {
                _adsModel = adsModel;
            }
        }
        return ads;
    }else{
        return nil;
    }
}

- (NSString *)adsUrl{
    if (self.enabled) {
        if (self.adsModel) {
            return self.adsModel.url;
        }else{
            [self ads];
            if (self.adsModel) {
                return self.adsModel.url;
            }
            return nil;
        }
    }else{
        return nil;
    }
}


/**
 *  保存
 *
 *  @param 广告Model
 */
- (void) saveAds:(eLongDebugAdsModel *)adsModel{
    if (!self.enabled) {
        return;
    }
    if ([adsModel.enabled boolValue]) {
        _adsModel = adsModel;
    }else if(_adsModel == adsModel){
        _adsModel = nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB saveContext];
}
@end
