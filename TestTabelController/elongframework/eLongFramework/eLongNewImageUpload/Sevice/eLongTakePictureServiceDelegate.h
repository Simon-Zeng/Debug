//
//  eLongTakePictureServiceDelegate.h
//  eLongFramework
//
//  Created by 吕月 on 16/4/19.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongAssetModel.h"

@protocol  eLongTakePictureServiceDelegate <NSObject>

/**
 *  取消拍照回调
 */
typedef void(^eLongTabkePictureUploadImageCancelBlock)();


/**
 *  可爱的照完了的图片eLongAssetModel对象转化成的array
 *
 *  @param assetModelDic eLongAssetModel
 */
typedef void(^eLongTakePictureImageBlock)(NSArray *assetModelArray);

/**
 *  拍摄照片
 *
 *  @param bussnisAPIAddress 上传图片API
 *  @param selectImageBlock  选择图片成功回调
 *  @param cancelBlock       取消回调
 */

- (void)eLongTakePictureWithBussnisAPIAddress:(NSString *) bussnisAPIAddress
                     SelectImage:(eLongTakePictureImageBlock) selectImageBlock
                       CancelCallback:(eLongTabkePictureUploadImageCancelBlock) cancelBlock;

@end