//
//  eLongMyElongImageUploadManager.m
//  ElongClient
//
//  Created by Dawn on 14-7-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongMyElongImageUploadManager.h"
#import "eLongMyElongImageUploadItem.h"
#import "eLongHTTPEncryption.h"
#import "NSString+URLEncoding.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "eLongNetUtil.h"
#import "eLongSingletonDefine.h"
#import "eLongExtension.h"
#import "JSONKit.h"
#import "eLongNetUtil.h"
#import "eLongDeviceUtil.h"
#import <Photos/Photos.h>
#import "eLongPhotoManager.h"

#define CACHE_IMAGEUPLOAD       @"Documents/LocalCache/ImageUpload/"

@interface eLongMyElongImageUploadManager(){
    BOOL done;
    NSThread *uploadThread;
}
@property (nonatomic,retain) NSMutableArray *uploadQueue;
@property (nonatomic,retain) eLongMyElongImageUploadItem *uploadItem;
@end

@implementation eLongMyElongImageUploadManager
DEF_SINGLETON(MyElongImageUploadManager)

- (id) init{
    if (self = [super init]) {
        done = YES;
        self.uploadQueue = [NSMutableArray array];
        self.uploadItem = nil;
    }
    return self;
}

- (void) dealloc{
    self.uploadQueue = nil;
    self.uploadItem = nil;
    [uploadThread cancel];
    uploadThread = nil;
}

- (void) resume{
    self.uploadQueue = [NSMutableArray array];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *directoryPath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_IMAGEUPLOAD];
    BOOL isDir;
    
    if ([fileManager fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        // 读取
        NSArray *filesArray = [fileManager subpathsAtPath:directoryPath];//获取该目录下的所有文件名
        for (int i = 0; i < filesArray.count; i++) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:[filesArray objectAtIndex:i]];
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            if (fileData) {
                @try {
                    eLongMyElongImageUploadItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:fileData];
                    [self.uploadQueue addObject:item];
                }
                @catch (NSException *exception) {
                    
                }
            }
        }
    }
    [self upload];
    fileManager = nil;
}

- (void) restore{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *directoryPath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_IMAGEUPLOAD];
    BOOL isDir;
    
    if (![fileManager fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        // 没有suggest缓存目录时先创建目录
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 判断image文件夹大小是否在规定范围内
    if (self.uploadQueue.count) {
        for (eLongMyElongImageUploadItem *item in self.uploadQueue) {
            if (!item.completed) {
                NSString *filePath = [directoryPath stringByAppendingPathComponent:item.fileName];
                NSData *fileData = [NSKeyedArchiver archivedDataWithRootObject:item];
                [fileData writeToFile:filePath atomically:YES];
                NSLog(@"%@",filePath);
            }
        }
    }
    fileManager = nil;
}

- (void) addItem:(eLongMyElongImageUploadItem *)item{
    //item.fileName = [PublicMethods GUIDString];
    [self.uploadQueue addObject:item];
    [self upload];
}

- (void) upload{
    if (!done) {
        return;
    }
    done = NO;
    
    if (!uploadThread){
        uploadThread = [[NSThread alloc] initWithTarget:self selector:@selector(word) object:nil];
        [uploadThread start];
    }
    else{
        [uploadThread cancel];
        uploadThread = nil;
        uploadThread = [[NSThread alloc] initWithTarget:self selector:@selector(word) object:nil];
        [uploadThread start];
    }
}

- (void) word{
    if ([[NSThread currentThread] isCancelled]){
        [NSThread exit];
    }
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    while (self.uploadQueue.count > 0) {
        eLongMyElongImageUploadItem *item = [self.uploadQueue objectAtIndex:0];
        self.uploadItem = item;
        if (item.itemType == ImageUploadItemTypeHotelComment || item.itemType == ImageUploadItemTypeFeedBack || item.itemType == ImageUploadItemTypeHeadImage) {
            NSString *tips = [self commentUpload:item];
            NSLog(@"image upload completed %@",item.info);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadCompleted:tips];
            });
            [self.uploadQueue removeObject:item];
            
            //                if (success || item.tryNum > 0) {
            //                    item.completed = YES;
            //                    NSLog(@"image upload completed %@",item.info);
            //                    [self.uploadQueue removeObject:item];
            //                    NSString *filePath = [directoryPath stringByAppendingPathComponent:item.fileName];
            //                    [fileManager removeItemAtPath:filePath error:NULL];
            //                }else{
            //                    item.tryNum = item.tryNum + 1;
            //                }
        }
    }
    fileManager = nil;
    done = YES;
}

- (void) stop{
    if (uploadThread) {
        [uploadThread cancel];
        uploadThread = nil;
        done = YES;
    }
    
    [self.uploadQueue removeAllObjects];
}

- (void) uploadProcess:(int)process result:(NSDictionary *)result{
    if (self.uploadItem) {
        self.uploadItem.uploadProcess(process,result);
    }
}

- (void) uploadCompleted:(NSString *)tips{
    if (self.uploadItem) {
        //        self.uploadItem.uploadCompleted(tips);
        self.uploadItem = nil;
    }
}

//static NSInteger kBufferSize = 1024 * 10;

- (NSString *) commentUpload:(eLongMyElongImageUploadItem *)item{
    
    @autoreleasepool {
        int i = 0;
        //    BOOL isError = NO;
        // 保留item
        //sessionId
        
        for (id oneAsset in item.images) {
            if ([[NSThread currentThread] isCancelled]){
                [NSThread exit];
            }
            
            __block NSData *imageData = nil;
            NSString *filename = @"";
            NSString *documentsPath = @"";
            NSString *path = @"";
            __block UIImage *postImage = nil;
            __block NSInteger imageType = 0;
            
            if (oneAsset && [oneAsset isKindOfClass:[ALAsset class]]) {
                ALAsset *aAsset = (ALAsset *)oneAsset;
                [self dealWithImageData:aAsset];
                ALAssetRepresentation *representation = [aAsset defaultRepresentation];
                filename  = representation.filename;
                documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                path = [documentsPath stringByAppendingPathComponent:filename];
                postImage = [UIImage imageWithContentsOfFile:path];
                imageData = [NSData dataWithContentsOfFile:path];
                [self removeImageInDocument:path];
                filename = [filename lowercaseString];
                if ([[NSThread currentThread] isCancelled]){
                    [NSThread exit];
                }
                if ([filename rangeOfString:@"jpg"].location != NSNotFound) {
                    imageType = 0;
                }
                else if ([filename rangeOfString:@"png"].location != NSNotFound) {
                    imageType = 1;
                }
                
            }else if (oneAsset && [oneAsset isKindOfClass:[PHAsset class]]){
                PHAsset *pAsset = (PHAsset *)oneAsset;
                dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
                [[eLongPhotoManager sharedManager]getOriginImageWithAsset:pAsset completionBlock:^(UIImage * _Nullable image) {
                    if (image) {
                        postImage = image;
                        imageData = UIImagePNGRepresentation(image);
                        imageType = 1;
                        dispatch_semaphore_signal(semaphore);
                    }
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
            
            //            filename = [[[asset defaultRepresentation] url] absoluteString];
            
            if ([[NSThread currentThread] isCancelled]){
                [NSThread exit];
            }
            
            NSUInteger imageFileSize = [imageData length];
            CGFloat factor = 1.0;
            CGSize size = postImage.size;
            
            if (item.itemType == ImageUploadItemTypeHotelComment) {
                
                CGFloat mImageFactor = size.width > size.height ? size.width : size.height;
                
                NSInteger limitSize = 2097152;
                //图片比例限制
                CGFloat imageFactor = 1296.0f / (mImageFactor == 0?1:mImageFactor);
                imageFactor = MIN(imageFactor, 1);
                size = CGSizeMake(size.width * imageFactor, size.height * imageFactor);
                
                
                
                while (imageFileSize > limitSize) {
                    
                    @autoreleasepool {
                        postImage = [postImage compressImageWithSize:CGSizeMake(size.width * factor, size.height * factor)];
                        if (imageType == 0) {
                            imageData = UIImageJPEGRepresentation(postImage, 1.0);
                        }
                        else if (imageType == 1) {
                            imageData = UIImagePNGRepresentation(postImage);
                        }
                        imageFileSize = [imageData length];
                        
                        factor -= 0.1;
                    }
                }
            }else if (item.itemType == ImageUploadItemTypeFeedBack){
                CGFloat mImageFactor = size.width > size.height ? size.width : size.height;
                
                NSInteger limitSize = 2097152/2;
                //图片比例限制
                CGFloat imageFactor = 1296.0f / (mImageFactor == 0?1:mImageFactor);
                imageFactor = MIN(imageFactor, 1);
                size = CGSizeMake(size.width * imageFactor, size.height * imageFactor);
                
                
                
                while (imageFileSize > limitSize) {
                    
                    @autoreleasepool {
                        postImage = [postImage compressImageWithSize:CGSizeMake(size.width * factor, size.height * factor)];
                        if (imageType == 0) {
                            imageData = UIImageJPEGRepresentation(postImage, 1.0);
                        }
                        else if (imageType == 1) {
                            imageData = UIImagePNGRepresentation(postImage);
                        }
                        imageFileSize = [imageData length];
                        
                        factor -= 0.1;
                    }
                }
                
                
            }
            else if (item.itemType == ImageUploadItemTypeHeadImage) {
                while (imageFileSize > 2097152/2) {
                    postImage = [postImage compressImageWithSize:CGSizeMake(300 * factor, 300 * factor)];
                    if (imageType == 0) {
                        imageData = UIImageJPEGRepresentation(postImage, 1.0);
                    }
                    else if (imageType == 1) {
                        imageData = UIImagePNGRepresentation(postImage);
                    }
                    imageFileSize = [imageData length];
                    NSLog(@"head image size == %.2f k",imageFileSize / 1024.0);
                    factor -= 0.1;
                }
            }
            NSString *imageMD5 = [imageData md5Coding];
            if (!imageMD5) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self uploadProcess:i result:nil];
                });
                //return @"图片上传失败";
                continue;
            }
            
            if ([[NSThread currentThread] isCancelled]){
                [NSThread exit];
            }
            
            
            NSMutableDictionary *dictInfo = [NSMutableDictionary dictionary];
            [dictInfo safeSetObject:[item.info safeObjectForKey:@"CardNo"] forKey:@"cardNo"];
            [dictInfo safeSetObject:imageMD5 forKey:@"checkSum"];
            
            if (item.itemType == ImageUploadItemTypeHotelComment || item.itemType == ImageUploadItemTypeFeedBack) {
                [dictInfo safeSetObject:[item.info safeObjectForKey:@"DeviceId"] forKey:@"deviceId"];
                [dictInfo safeSetObject:[item.info safeObjectForKey:@"HotelId"] forKey:@"hotelId"];
                [dictInfo safeSetObject:[item.info safeObjectForKey:@"OrderId"] forKey:@"orderId"];
            }
            else if (item.itemType == ImageUploadItemTypeHeadImage) {
                [dictInfo safeSetObject:[item.info safeObjectForKey:@"userFrom"] forKey:@"userFrom"];// 头像上传 来源字段
            }
            //        [dictInfo setObject:guid forKey:@"sessionId"];
            
            
            const char *cJson = [[dictInfo JSONString] UTF8String];
            NSInteger jsonLength = strlen(cJson);
            NSString *jsonHeader = [NSString stringWithFormat:@"%03ld", (long)jsonLength];
            const char *cJsonHeader = [jsonHeader UTF8String];
            
            // Post NSData format. prepare for stream.
            NSMutableData *postData = [NSMutableData dataWithCapacity:0];
            [postData appendData:[NSData dataWithBytes:cJsonHeader length:strlen(cJsonHeader)]];
            [postData appendData:[NSData dataWithBytes:cJson length:strlen(cJson)]];
            [postData appendData:imageData];
            
            NSInputStream *inputStream = [NSInputStream inputStreamWithData:postData];
            NSURL *url;
            if (item.itemType == ImageUploadItemTypeHotelComment) {
                url = [NSURL URLWithString:[eLongNetUtil composeNetSearchUrl:@"mtools" forService:@"uploadHotelCommentImgV2"]];
            }else if (item.itemType == ImageUploadItemTypeFeedBack){
                url = [NSURL URLWithString:[eLongNetUtil composeNetSearchUrl:@"myelong" forService:@"uploadComplaintPic"]];
            }
            else if (item.itemType == ImageUploadItemTypeHeadImage) {
                url = [NSURL URLWithString:[eLongNetUtil composeNetSearchUrl:@"user" forService:@"upLoadPicture"]];
            }
            NSMutableURLRequest *request;
            request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setTimeoutInterval:30];
            [request setHTTPBodyStream:inputStream];
            [request setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
            
            // 请求
            NSURLResponse *response;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            //        NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if ([[NSThread currentThread] isCancelled]){
                [NSThread exit];
            }
            
            
            
            NSDictionary *responseInfo = [NSDictionary dictionary];
            if (data.length > 0) {
                NSError *error;
                responseInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            }else{
                [self uploadProcess:i result:nil];
                break;
                
            }
            
            if ([[responseInfo safeObjectForKey:@"IsError"] boolValue]) {
                NSLog(@"image upload error %@",responseInfo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (item.itemType == ImageUploadItemTypeHeadImage) {
                        [self uploadProcess:i result:responseInfo];
                    }
                    else {
                        [self uploadProcess:i result:nil];
                    }
                });
                break;
                //            return @"图片上传失败";
            }else if(!responseInfo){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self uploadProcess:i result:nil];
                });
                break;
                //            return @"网络异常，请稍后再试";
            }else{
                if (item.itemType == ImageUploadItemTypeHotelComment) {
                    NSDictionary *responseDic = [responseInfo safeObjectForKey:@"ImgInfo"];//
                    if (responseDic) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self uploadProcess:i result:responseDic];
                        });
                        //                NSMutableDictionary *localDraftDic = [NSMutableDictionary dictionaryWithDictionary:item.info];
                    }
                }else if (item.itemType == ImageUploadItemTypeFeedBack){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self uploadProcess:i result:responseInfo];
                    });
                }
                else if (item.itemType == ImageUploadItemTypeHeadImage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self uploadProcess:i result:responseInfo];
                    });
                }
                
            }
            i++;
            
        }
        
        if ([[NSThread currentThread] isCancelled]){
            [NSThread exit];
        }
    }
    return nil;
}

static NSInteger kBufferSize = 1024 * 10;
- (void)dealWithImageData:(ALAsset *)asset {
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    long long remaining = representation.size;
    NSString *filename = representation.filename;
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [documentsPath stringByAppendingPathComponent:filename];
    NSString *tempPath = [self pathForTemporaryFileWithPrefix:@"ALAssetDownload"];
    
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:tempPath append:NO];
    
    [outputStream open];
    
    long long representationOffset = 0ll;
    NSError *error;
    
    uint8_t buffer[kBufferSize];
    
    while (remaining > 0ll) {
        NSInteger bytesRetrieved = [representation getBytes:buffer fromOffset:representationOffset length:sizeof(buffer) error:&error];
        if (bytesRetrieved < 0) {
            [outputStream close];
            [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
            return;
        } else {
            remaining -= bytesRetrieved;
            representationOffset += bytesRetrieved;
            [outputStream write:buffer maxLength:bytesRetrieved];
        }
    }
    
    [outputStream close];
    
    if (![[NSFileManager defaultManager] moveItemAtPath:tempPath toPath:path error:&error]) {
        NSLog(@"Unable to move file: %@", error);
    }
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix {
    NSString *uuidString = [eLongDeviceUtil GUIDString];
    
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidString]];
}

- (BOOL)removeImageInDocument:(NSString *)path {
    BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    return isSuccess;
}

- (void)StopThreadIfCancelled{
    
    
    
    

}


@end
