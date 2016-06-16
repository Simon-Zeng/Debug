//
//  eLongHttpUploadImage.m
//  ElongClient
//
//  Created by chenggong on 14-3-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongHttpUploadImage.h"

#define TWOMB 2097152

@interface eLongHttpUploadImage()

@property (nonatomic, copy) NSString *paramsJson;
@property (nonatomic, strong) ALAsset *imageAsset;
@property (nonatomic, strong) NSURLConnection *uploadConnection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSMutableData *postData;
@property (nonatomic, strong) __block NSMutableData *postImageData;

@end

@implementation eLongHttpUploadImage

- (void)dealloc
{
    self.paramsJson = nil;
    self.imageAsset = nil;
    
    [_uploadConnection cancel];
    self.uploadConnection = nil;
    
    self.receivedData = nil;
    self.postData = nil;
    self.postImageData = nil;
}

- (id)initWithParamsJsonString:(NSString *)params imageAssets:(ALAsset *)asset imageData:(NSData *)data
{
	if (self = [super init]) {
        self.paramsJson = params;
        self.imageAsset = asset;
        self.postImageData = [NSMutableData dataWithData:data];
	}
    
	return self;
}

- (void)startUpload
{
    const char *cJson = [_paramsJson UTF8String];
    NSInteger jsonLength = strlen(cJson);
    NSString *jsonHeader = [NSString stringWithFormat:@"%03ld", (long)jsonLength];
    const char *cJsonHeader = [jsonHeader UTF8String];
    
    // Post NSData format. prepare for stream.
    self.postData = [NSMutableData dataWithCapacity:0];
    
    [_postData appendData:[NSData dataWithBytes:cJsonHeader length:strlen(cJsonHeader)]];
    [_postData appendData:[NSData dataWithBytes:cJson length:strlen(cJson)]];

//    @autoreleasepool {
//        UIImage *postImage = [UIImage imageWithCGImage:[[_imageAsset defaultRepresentation] fullResolutionImage]];
//        NSString *imageName = [[_imageAsset defaultRepresentation] filename];
//        imageName = [imageName lowercaseString];
//        NSData *imageData;
//        ImageType imageType;
//        if ([imageName rangeOfString:@"jpg"].location != NSNotFound) {
//            imageData = UIImageJPEGRepresentation(postImage, 1.0);
//            imageType = ImageTypeJPEG;
//        }
//        else if ([imageName rangeOfString:@"png"].location != NSNotFound) {
//            imageData = UIImagePNGRepresentation(postImage);
//            imageType = ImageTypePNG;
//        }
//        
//        NSUInteger imageFileSize = [imageData length];
//        if (imageFileSize > TWOMB) {
//            //        postImage = [postImage compressImageWithSize:CGSizeMake(1936, 2592)];
//            postImage = [postImage compressImageWithSize:CGSizeMake(968, 1296)];
//            NSData *compressImageData = [NSMutableData dataWithCapacity:0];
//            if (imageType == ImageTypeJPEG) {
//                compressImageData = UIImageJPEGRepresentation(postImage, 1.0);
//            }
//            else if (imageType == ImageTypePNG) {
//                compressImageData = UIImagePNGRepresentation(postImage);
//            }
//            [_postData appendData:compressImageData];
//        }
//        else {
//            [_postData appendData:imageData];
//        }
//    }
    [_postData appendData:_postImageData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.receivedData = [NSMutableData dataWithCapacity:0];
        // Post stream.
        NSInputStream *inputStream = [NSInputStream inputStreamWithData:_postData];
        [self sendRequestWithStream:inputStream postData:_postData];
    });
}

- (void)sendRequestWithStream:(NSInputStream *)inputStream postData:(NSData *)data
{
    NSURL *url = [NSURL URLWithString:HOTEL_UPLOAD_IMAGE_URL];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:50];
    [request setHTTPBodyStream:inputStream];
    [request setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    
    // 请求
    self.uploadConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)stopUpload
{
    [_uploadConnection cancel];
    self.uploadConnection = nil;
    self.delegate = nil;
//    self.delegate = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
//    NSMutableData *returnInfoData = [[NSMutableData alloc] init];
//    long long totalSize = [aResponse expectedContentLength];
//    NSHTTPURLResponse * httpResponse;
//    httpResponse = (NSHTTPURLResponse *)aResponse;
//    if ((httpResponse.statusCode / 100) != 2) {
//        NSLog(@"连接失败");
//    } else {
//        NSLog(@"连接成功");
//    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(imageUploadError:error:)]) {
        [_delegate imageUploadError:[NSIndexPath indexPathForRow:_tag inSection:0] error:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_delegate && [_delegate respondsToSelector:@selector(imageUploadDone:returnData:)]) {
        [_delegate imageUploadDone:[NSIndexPath indexPathForRow:_tag inSection:0] returnData:_receivedData];
    }
    self.receivedData = nil;
}

@end
