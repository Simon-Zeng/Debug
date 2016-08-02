//
//  PasteBoard.m
//  TestTabelController
//
//  Created by wzg on 16/8/2.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "PasteBoard.h"
@implementation PasteBoard

#pragma mark - property
- (NSString *)content
{
    NSString *pasteStr;
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    if (paste.string) {
        NSLog(@"粘贴板文字:%@",paste.string);
        [paste setValue:[paste.string stringByAppendingString:@"自定义后"] forPasteboardType:@"public.utf8-plain-text"];
        NSLog(@"修改后的粘贴板:%@",paste.string);
    }
    
    return pasteStr;
}


#pragma mark - public method
- (UIPasteboard *)createCustomerPasteBoardWithName
{
    UIPasteboard *paste = [UIPasteboard pasteboardWithName:@"myPasteBoard" create:YES];
    
    return paste;
}

@end
