//
//  Message.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@protocol eLongMessage <NSObject> @end

@interface eLongMessage : JSONModel <NSSecureCoding>

@property (nonatomic, assign) BOOL hasRead;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *url;

//  add by yangfan 2016.3.25 push消息增加字段
@property (nonatomic, copy) NSString * messageId;   // 消息id
@property (nonatomic, copy) NSString * content;     // 消息内容
@property (nonatomic, copy) NSString * title;       // 消息标题
@property (nonatomic, assign) NSInteger status;      // 消息读取的状态，1：已读；0：未读
@property (nonatomic, copy) NSString * imgUrl;       // 图片url
@property (nonatomic, copy) NSString * messagePushTime;     // 消息推送的时间
@property (nonatomic, copy) NSString * messageUrl;      // 点击消息跳转的url

+ (BOOL)supportsSecureCoding;

@end
