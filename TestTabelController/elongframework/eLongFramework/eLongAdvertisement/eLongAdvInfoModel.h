//
//  eLongAdvInfoModel.h
//  eLongFramework
//
//  Created by Ning.liu on 15/8/17.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

@protocol eLongAdvInfoModel @end

#import "eLongResponseBaseModel.h"

@interface eLongAdvInfoModel : eLongResponseBaseModel

/**
 *  主键ID
 */
@property (nonatomic, copy) NSString *adId;
/**
 *  广告类型：1轮播，2酒店磁贴，3机票磁贴，4团购磁贴，5页面
 */
@property (nonatomic, copy) NSString *adType;
/**
 *  广告名称
 */
@property (nonatomic, copy) NSString *adName;
/**
 *  跳转类型：1为H5跳转，2为APP参数跳转
 */
@property (nonatomic, copy) NSString *jumpType;
/**
 *  图片URL地址
 */
@property (nonatomic, copy) NSString *picUrl;
/**
 *  跳转链接或跳转参数
 */
@property (nonatomic, copy) NSString *jumpLink;
/**
 *  0:默认,1:酒店查询,2:机票查询,3:火车票查询,4:酒店收银台,5:机票收银台,6:团购收银台,7:首页,8:酒店列表,9:公寓1,10:公寓2,11:公寓3,12:闪屏,13:H5钟点房,14:搜索页,15:公寓列表,16:H5活动,17:国际酒店列表页
 */
@property (nonatomic, copy) NSString *pageType;
/**
 *  广告顺序
 */
@property (nonatomic, copy) NSString *sort;
/**
 *  广告图片尺寸
 */
@property (nonatomic, copy) NSString *dimension;
/**
 *  渠道号
 */
@property (nonatomic, copy) NSString *channelId;
/**
 *  0:默认 1:版本 2:渠道
 */
@property (nonatomic, copy) NSString *isDefault;
/**
 *  广告分组
 */
@property (nonatomic, copy) NSString *adGroup;
/**
 *  客户端版本
 */
@property (nonatomic, copy) NSString *version;
/**
 *  广告开始时间
 */
@property (nonatomic, copy) NSString *putStartDate;
/**
 *  广告结束时间
 */
@property (nonatomic, copy) NSString *putEndDate;

/**
 *  存放一些额外的返回值，比如color,activeMaxValue啥的
 */
@property (nonatomic, copy) NSString *skinTemplate;


@end
