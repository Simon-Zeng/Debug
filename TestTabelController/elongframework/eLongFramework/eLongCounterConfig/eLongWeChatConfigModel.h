//
//  eLongWeChatConfigModel.h
//  eLongFramework
//
//  Created by zhaoyingze on 16/3/4.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongWeChatConfigModel : NSObject

/**
 *  app的URL Scheme，调用微信SDK时使用，默认值为：elongIPhone
 */
@property (nonatomic, copy) NSString *urlScheme;

/**
 *  应用在微信申请的appId,默认值为艺龙旅行的appId
 */
@property (nonatomic, copy) NSString *appId;

/**
 *  应用在微信申请的appKey,默认值为艺龙旅行的appKey
 */
@property (nonatomic, copy) NSString *appKey;

+ (id)shared;

@end
