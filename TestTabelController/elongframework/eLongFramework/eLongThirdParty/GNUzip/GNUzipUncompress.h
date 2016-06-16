//
//  GNUzipUncompress.h
//  ElongClient
//
//  Created by Dawn on 14-10-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//
//  完成gzip的解压过程

#import <Foundation/Foundation.h>

@interface GNUzipUncompress : NSObject
/**
 *  解压gzip压缩的数据，以NSString形式返回
 *
 *  @param data gzip压缩的数据
 *
 *  @return gzip解压后的字符串
 */
- (NSString *) uncompress: (NSData *) data;

/**
 *  解压gzip压缩的数据，以NSData形式返回
 *
 *  @param data gzip压缩的数据
 *
 *  @return gzip解压后的数据
 */
- (NSData *)uncompressData:(NSData *)data;
@end
