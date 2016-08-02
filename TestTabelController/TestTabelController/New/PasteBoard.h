//
//  PasteBoard.h
//  TestTabelController
//
//  Created by wzg on 16/8/2.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PasteBoard : NSObject

@property (nonatomic, copy,readonly) NSString *content;

- (UIPasteboard *)createCustomerPasteBoardWithName;

@end
