//
//  eLongPhotoUploadServiceDelegate.h
//  eLongFramework
//
//  Created by 吕月 on 16/4/15.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongAssetModel.h"

@protocol  eLongPhotoUploadServiceDelegate <NSObject>

/**
 *  图片上传进度状态
 *
 *  @param assetModelStatusArray 装有状态model dic 的数组
 */
typedef void(^eLongPhotoUploadProgressStatus )(NSArray *assetModelStatusArray);

/**
 *  可爱的选中的图片们
 *
 *  @param assetModelArray 选中的图片数组
 */
typedef void(^eLongPhotoUploadImageModelArray)(NSArray *assetModelArray);

/**
 *  取消选择图片回调
 */
typedef void(^eLongPhotoUploadImageCancel)();


/**
 *  图片选择上传组件服务
 *
 *  @param retryAssetModel   重试的图片AssetArray
 *  @param maxSelectNumber   最大选择上传张数
 *  @param BussnisAPIAddress MAPI接口地址
 *  @param alreadySelectedImageArray  已经选择的图片AssetArry
 *  @param selectImageArray  返回的选择的图片AssetArry
 *  @param statusImageArray  图片的状态集
 *  @param cancel            取消回调
 */

- (void)eLongPhotoUploadRetryModelDic:(NSDictionary *) retryAssetModel
                 MaxPhotoSelectNumber:(NSNumber *) maxSelectNumber
                    BussnisAPIAddress:(NSString *) bussnisAPIAddress
            AlreadySelectedImageArray:(NSArray *) alreadySelectedImageArray
                     SelectImageArray:(eLongPhotoUploadImageModelArray) selectImageArrayBlock
                     ImageStatusArray:(eLongPhotoUploadProgressStatus) statusImageArrayBlock
                       CancelCallback:(eLongPhotoUploadImageCancel) cancelBlock;

@end