//
//  eLongHTTPGNUzipEncoding.m
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongHTTPGNUzipEncoding.h"
#import <zlib.h>
@implementation eLongHTTPGNUzipEncoding
- (NSString *)decoding:(NSData *)data
{
    NSData *uncompressData = [self decodingData:data];
    if (uncompressData) {
        return [[NSString alloc] initWithData:uncompressData encoding:NSUTF8StringEncoding] ;
    }
    return nil;
}

- (NSData *)decodingData:(NSData *)data
{
    if ([data length] == 0)
        return nil;
    
    // gzip数据格式判断
    if (data.length >= 2) {
        Byte *byteData = (Byte *)[data bytes];
        if(byteData[0] == 0x1f && byteData[1] == 0x8b){
            NSLog(@"gzip压缩");
        }else{
            return nil;
        }
    }
    unsigned full_length = (uInt)[data length];
    unsigned half_length = (uInt)[data length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = (uInt)[data length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK)
        return nil;
    while (!done){
        // 确保空间足够
        if (strm.total_out >= (uInt)[decompressed length]){
            [decompressed increaseLengthBy:half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out =(uInt)([decompressed length] - strm.total_out);
        
        // 扩充空间
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END){
            done = YES;
        }else if (status != Z_OK){
            break;
        }
    }
    
    if (inflateEnd (&strm) != Z_OK){
        return nil;
    }
    
    // Set real length.
    if (done){
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData:decompressed];
    }else{
        return nil;
    }
}
@end
