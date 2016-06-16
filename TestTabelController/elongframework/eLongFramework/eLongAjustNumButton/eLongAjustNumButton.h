//
//  eLongAjustNumButton.h
//  数量增减控件
//
//  Created by dayu on 15/6/4.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    eLongAjustNumErrorMoreThanMax,
    eLongAjustNumErrorLessThanMin
}eLongAjustNumError;

@interface eLongAjustNumButton : UIView

/** 边框颜色，默认值是浅灰色 */
@property (nonatomic, assign) UIColor *lineColor;

@property (nonatomic, assign) BOOL allowInputNum;
/** 默认值 */
@property (nonatomic, assign) CGFloat defaultNum;

/** 最大值，默认无上限 */
@property (nonatomic, assign) CGFloat maxNum;

/** 最小值，默认为1 */
@property (nonatomic, assign) CGFloat minNum;

/** 增量，默认为1 */
@property (nonatomic, assign) CGFloat increment;

/** 文本框内容改变后的回调 */
@property (nonatomic, copy) void (^completionHandler) (NSString *currentNum);

/** 超出边界的回调 */
@property (nonatomic, copy) void (^errorHandler) (eLongAjustNumError errorType);

+ (eLongAjustNumButton *)ajustNumButtonWithDefaultNum:(CGFloat )defaultNum;
- (instancetype)initWithDefaultNum:(CGFloat)defaultNum;
@end
