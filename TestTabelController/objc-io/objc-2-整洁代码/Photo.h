//
//  Photo.h
//  TestTabelController
//
//  Created by wzg on 16/8/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface Photo : NSObject
@property (nonatomic) int64_t identifier;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSDate* creationDate;
@property (nonatomic) double rating;

@property (nonatomic, weak) User* user;

- (NSString*)authorFullName;
- (double)adjustedRating;

@end
