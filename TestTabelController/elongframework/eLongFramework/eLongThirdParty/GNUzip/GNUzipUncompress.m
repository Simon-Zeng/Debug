//
//  GNUzipUncompress.m
//  ElongClient
//
//  Created by Dawn on 14-10-28.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GNUzipUncompress.h"
#import <zlib.h>

@implementation GNUzipUncompress
- (NSString *) uncompress: (NSData *) data{
    NSData *uncompressData = [self uncompressData:data];
    if (uncompressData) {
        return [[[NSString alloc] initWithData:uncompressData encoding:NSUTF8StringEncoding] autorelease];
    }
    return nil;
}

- (NSData *)uncompressData:(NSData *)data{
    
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
    

    NSUInteger full_length = [data length];
    NSUInteger half_length = [data length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = [data length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK)
        return nil;
    while (!done){
        // 确保空间足够
        if (strm.total_out >= [decompressed length]){
            [decompressed increaseLengthBy:half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        
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
