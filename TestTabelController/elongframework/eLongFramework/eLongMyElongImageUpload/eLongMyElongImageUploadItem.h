//
//  eLongMyElongImageUploadItem.h
//  ElongClient
//
//  Created by Dawn on 14-7-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ImageUploadItemTypeHotelComment,
    ImageUploadItemTypeFeedBack,
    ImageUploadItemTypeHeadImage
}eLongMyElongImageUploadItemType;

@interface eLongMyElongImageUploadItem : NSObject<NSCoding>
@property (nonatomic,assign) eLongMyElongImageUploadItemType itemType;
@property (nonatomic,retain) NSArray *images;
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,copy)   NSString *content;
@property (nonatomic,copy)   NSDictionary *info;
@property (nonatomic,copy)   NSString *fileName;
@property (nonatomic,assign) BOOL completed;
@property (nonatomic,assign) NSInteger tryNum;
@property (nonatomic,copy) void (^uploadProcess)(NSInteger process,NSDictionary *result);
@property (nonatomic,copy) void (^uploadCompleted)(NSString *);

@end
