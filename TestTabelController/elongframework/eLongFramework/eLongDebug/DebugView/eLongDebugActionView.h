//
//  eLongDebugActionView.h
//  ElongClient
//
//  Created by Dawn on 15/3/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eLongDebugActionView : UIView
@property (nonatomic,strong,readonly) UIView *contentView;
- (void) showOverWindow;
- (void)closeBtnClick:(id)sender;
@end
