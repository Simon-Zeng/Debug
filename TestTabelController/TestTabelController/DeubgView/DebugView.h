//
//  DebugView.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/20.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugView : UIView
@property (nonatomic, assign)BOOL hidden;

@property (nonatomic, strong)UIViewController *root;

@property (nonatomic, strong)UIViewController *rootVc;

- (void)showOverWindow;

@end
