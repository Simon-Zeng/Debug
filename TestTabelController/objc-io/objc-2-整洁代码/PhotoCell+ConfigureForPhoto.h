//
//  PhotoCell+ConfigureForPhoto.h
//  TestTabelController
//
//  Created by wzg on 16/8/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "PhotoCell.h"
@class Photo;

@interface PhotoCell (ConfigureForPhoto)
- (void)configurePhoto:(Photo *)photo;
@end
