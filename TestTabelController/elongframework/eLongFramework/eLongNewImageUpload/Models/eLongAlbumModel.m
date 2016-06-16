//
//  eLongAlbumModel.m
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/26.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import "eLongAlbumModel.h"

#import "eLongPhotoPickerDefines.h"

#import <Photos/PHFetchResult.h>
#import <AssetsLibrary/ALAssetsGroup.h>

#import "eLongDefine.h"
 
@interface eLongAlbumModel ()

/** 相册的名称 */
@property (nonatomic, copy)   NSString *name;

/** 照片的数量 */
@property (nonatomic, assign) NSUInteger count;

/** PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset> */
@property (nonatomic, strong) id fetchResult;

@end

@implementation eLongAlbumModel

#pragma mark - Methods

+ (eLongAlbumModel *)albumWithResult:(id)result name:(NSString *)name {
    eLongAlbumModel *model = [[eLongAlbumModel alloc] init];
    model.fetchResult = result;
    model.name = [self _albumNameWithOriginName:name];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        model.count = [gruop numberOfAssets];
#pragma clang diagnostic pop
    }
    return model;
}

+ (NSString *)_albumNameWithOriginName:(NSString *)name {
    if (IOSVersion_8) {
        NSString *newName;
        if ([name containsString:@"Roll"])         newName = @"相机胶卷";
        else if ([name containsString:@"Stream"])  newName = @"我的照片流";
        else if ([name containsString:@"Added"])   newName = @"最近添加";
        else if ([name containsString:@"Selfies"]) newName = @"自拍";
        else if ([name containsString:@"shots"])   newName = @"截屏";
//        else if ([name containsString:@"Videos"])  newName = @"视频";
        else newName = name;
        return newName;
    } else {
        return name;
    }
}


#pragma mark - Getters

- (NSString *)description {
    return [NSString stringWithFormat:@"\n-----album desc start--\nalbum :%@ have %ld photos \nresult :%@\n-----album desc end----",self.name,self.count,self.fetchResult];
}


@end
