//
//  eLongRoundCornerView+WebCache.m
//  eLongLogin
//
//  Created by zhaoyingze on 15/8/4.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRoundCornerView+WebCache.h"
#import "eLongImageManager.h"
#import "UIImageView+eLongLoadImage.h"
#import "UIView+TipMessage.h"
#import "eLongDefine.h"

@implementation eLongRoundCornerView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    self.image = nil;
    self.placeholder = placeholder;
    NSString *strUrl = [url absoluteString];
    if (STRINGHASVALUE(strUrl)) {
        if ([eLongImageManager diskImageExistsForURL:url] || [eLongImageManager cachedImageExistsForURL:url]) {
            self.image = [eLongImageManager diskImageForURL:url];
            [self endLoading];
        }else {
            __block typeof(self) weakSelf = self;
            [weakSelf.downLoadImageView eLongLoadImageWithURL:url
                                             placeholderImage:nil
                                                     progress:nil
                                                    completed:^(UIImage *image, NSURL *imageURL) {
                                                        if (image) {
                                                            weakSelf.alpha= 0.0;
                                                            weakSelf.image = image;
                                                            [UIView animateWithDuration:0.5 animations:^{
                                                                weakSelf.alpha = 1.0;
                                                            }];
                                                        }else{
                                                            weakSelf.image = placeholder;
                                                        }
                                                        [weakSelf setNeedsLayout];
                                                        [weakSelf endLoading];
                                                    }];
        }
    }else{
        self.image = placeholder;
        [self endLoading];
    }
}

@end
