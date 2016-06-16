//
//  eLongImageUploadManager.m
//  eLongFramework
//
//  Created by 吕月 on 16/4/19.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongImageUploadManager.h"
#import "eLongHTTPRequest.h"

static NSString * eLongImageUploadManagerQueue = @"elong.image_upload.queue";

static dispatch_queue_t _elongImageUploadManagerOperationQueue ;

@interface eLongImageUploadManager ()

@property (nonatomic,strong)NSMutableDictionary *defaultRequestParmas;

@property (nonatomic,strong)NSMutableDictionary *defualtRequestHeader;

@property (nonatomic,strong)NSString     *defaultHostUrl;

@property (nonatomic,strong)NSString     *defaultPath;

@property (nonatomic,strong)NSMutableArray *taskArray;

@property (nonatomic,strong)NSMutableDictionary *observerActionDict;

//@property (nonatomic,strong)AFHTTPRequestOperationManager *requestOperationManager;

/* 当前位于前台执行的观察者唯一标示 */
@property (nonatomic,strong)NSString *currentForegroundObserverUniqueIdenfier;

@end


@implementation eLongImageUploadManager

+ (eLongImageUploadManager*)sharedInstance
{
    static eLongImageUploadManager *_imageUploadManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _elongImageUploadManagerOperationQueue = dispatch_queue_create(eLongImageUploadManagerQueue.UTF8String, NULL);
        _imageUploadManager = [[self alloc]init];
    });
    return _imageUploadManager;
}


- (instancetype)initWithOwner:(id)owner
{
    if (self = [super init]) {
        
        self.taskArray = [[NSMutableArray alloc]init];
        self.observerActionDict = [[NSMutableDictionary alloc]init];
        

    }
    return self;
}


@end
