//
//  Message.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "eLongMessage.h"

@implementation eLongMessage

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)dealloc
{
    _time = nil;
    _body = nil;
    _url = nil;
}

- (id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_body forKey:@"body"];
    [aCoder encodeObject:_url forKey:@"url"];
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeBool:_hasRead forKey:@"hasRead"];
    
    // add by yangfan 2016.3.25
    [aCoder encodeObject:_messageId forKey:@"messageId"];
    [aCoder encodeObject:_content forKey:@"content"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeInteger:_status forKey:@"status"];
    [aCoder encodeObject:_imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:_messagePushTime forKey:@"messagePushTime"];
    [aCoder encodeObject:_messageUrl forKey:@"messageUrl"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.body = [aDecoder decodeObjectForKey:@"body"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.hasRead = [aDecoder decodeBoolForKey:@"hasRead"];
        
        // add by yangfan 2016.3.25
        self.messageId = [aDecoder decodeObjectForKey:@"messageId"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.status = [aDecoder decodeIntegerForKey:@"status"];
        self.imgUrl = [aDecoder decodeObjectForKey:@"imgUrl"];
        self.messagePushTime = [aDecoder decodeObjectForKey:@"messagePushTime"];
        self.messageUrl = [aDecoder decodeObjectForKey:@"messageUrl"];
    }
                
    return self;
}

@end
