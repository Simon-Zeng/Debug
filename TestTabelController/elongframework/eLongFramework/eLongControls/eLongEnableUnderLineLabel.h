//
//  eLongEnableUnderLineLabel.h
//  ElongClient
//
//  Created by zhaoyingze on 14-9-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eLongEnableUnderLineLabel : UILabel
{
    UIControl *_actionView;
    UIColor *_highlightedColor;
    BOOL _shouldUnderline;
}

@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, assign) BOOL shouldUnderline;

- (void)setText:(NSString *)text andCenter:(CGPoint)center;
- (void)addTarget:(id)target action:(SEL)action;

@end
