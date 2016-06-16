//
//  eLongAlertTipView.h
//  eLongFramework
//
//  Created by yangfan on 15/6/30.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eLongAlertTipView : UIView {
@private
    CGPoint startPoint;
}

@property (nonatomic, copy) NSString *tipString;
@property (nonatomic, retain) UIColor *stringColor;					// default red color

- (id)initWithFrame:(CGRect)frame startPoint:(CGPoint)point;		// 箭头起始点

@end
