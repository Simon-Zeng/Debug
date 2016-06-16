//
//  eLongMyElongImageUploadItem.m
//  ElongClient
//
//  Created by Dawn on 14-7-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongMyElongImageUploadItem.h"

@implementation eLongMyElongImageUploadItem

- (void) dealloc{
    self.images = nil;
    self.title = nil;
    self.content = nil;
    self.info = nil;
    self.fileName = nil;
    self.uploadCompleted = nil;
    self.uploadProcess = nil;
 
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInt:self.itemType] forKey:@"itemType"];
    [aCoder encodeObject:self.images forKey:@"images"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.completed] forKey:@"completed"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.info forKey:@"info"];
    [aCoder encodeObject:self.fileName forKey:@"file"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.tryNum] forKey:@"trynum"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
        self.itemType = [[aDecoder decodeObjectForKey:@"itemType"] intValue];
        self.images = [aDecoder decodeObjectForKey:@"images"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.completed = [[aDecoder decodeObjectForKey:@"completed"] boolValue];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.info = [aDecoder decodeObjectForKey:@"info"];
        self.fileName = [aDecoder decodeObjectForKey:@"file"];
        self.tryNum = [[aDecoder decodeObjectForKey:@"trynum"] intValue];
    }
    
    return self;
}



@end
