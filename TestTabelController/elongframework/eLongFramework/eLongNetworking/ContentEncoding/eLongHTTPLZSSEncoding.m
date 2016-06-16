//
//  eLongHTTPLZSSEncoding.m
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongHTTPLZSSEncoding.h"
#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <ctype.h>

#define F                  18   // upper limit for match_length
#define N                4096   /* size of ring buffer */
#define THRESHOLD       2   /* encode string into position and length if match_length is greater than this */
#define MAXLENGTH		10048000 //

@interface eLongHTTPLZSSEncoding()
{
    unsigned char text_buf[N + F - 1];
}
@end
@implementation eLongHTTPLZSSEncoding
- (NSData *)decodingData:(NSData *)data
{
    int  i, j, k, r, c,readoff,writeoff,inlength;
    unsigned int  flags;
    Byte *instream ,*outstream;
    
    inlength = (uint)data.length;
    instream = (Byte *)malloc(inlength);
    memcpy(instream, [data bytes], inlength);
    if(inlength <= 8){
        free(instream);
        return nil;
    }
    readoff = writeoff = 0;
    
    outstream = (Byte *)malloc(MAXLENGTH);
    
    for (i = 0; i < N - F; i++) text_buf[i] = ' ';
    r = N - F;  flags = 0;
    for ( ; ; ) {
        if (((flags >>= 1) & 256) == 0) {
            if (readoff == inlength) break;
            c = instream[readoff++];
            flags = c | 0xff00;            // uses higher byte cleverly to count eight
        }
        if (flags & 1) {
            if (readoff == inlength) break;
            c = instream[readoff++];
            outstream[writeoff++] = c; text_buf[r++] = c;  r &= (N - 1);//!!!
        } else {
            if (readoff == inlength) break;
            i = instream[readoff++];
            if (readoff == inlength) break;
            j = instream[readoff++];
            i |= ((j & 0xf0) << 4);
            j = (j & 0x0f) + THRESHOLD;
            for (k = 0; k <= j; k++) {
                c = text_buf[(i + k) & (N - 1)];
                outstream[writeoff++] = c;	text_buf[r++] = c;  r &= (N - 1);//!!!
            }
        }
    }
 
    NSData *outData = [[NSData alloc] initWithBytes:outstream length:writeoff];
    free(instream);
    free(outstream);
   
    return outData ;
}

- (NSString *)decoding:(NSData *)data
{
    NSString  *outStr= nil;
    outStr = [[NSString  alloc]initWithData:[self  decodingData:data] encoding:NSUTF8StringEncoding]; 
  
    return outStr;
}
@end
