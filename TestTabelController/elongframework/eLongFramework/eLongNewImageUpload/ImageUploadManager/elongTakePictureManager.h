//
//  elongTakePictureManager.h
//  Pods
//
//  Created by 吕月 on 16/4/19.
//
//

#import <Foundation/Foundation.h>
#import "eLongTakePictureServiceDelegate.h"

@interface elongTakePictureManager : NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) eLongTakePictureImageBlock imageBlock;

+ (elongTakePictureManager *)sharedInstance;

- (void) initWithBussnisAPIAddress:(NSString *) bussnisAPIAddress
                       SelectImage:(eLongTakePictureImageBlock) selectImageBlock
                    CancelCallback:(eLongTabkePictureUploadImageCancelBlock) cancelBlock;

@end
