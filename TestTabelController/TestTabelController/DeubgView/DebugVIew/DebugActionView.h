//
//  DebugActionView.h
//  TestTabelController
//
//  Created by wzg on 16/6/29.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugActionView : UIView
@property (nonatomic,strong,readonly) UIView *contentView;
- (void) showOverWindow;
- (void)closeBtnClick:(id)sender;
@end
