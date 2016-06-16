//
//  eLongCustomPopView.h
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/16.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,eLongCustomPopViewStyle)
{
    /**
     *  从底部弹起
     */
    eLongCustomPopViewStyleFromBottom = 0,
    /**
     *  从顶部弹下
     */
    eLongCustomPopViewStyleFromTop = 1,
    /**
     *  从左边弹出
     */
    eLongCustomPopViewStyleFromLeft = 2,
    /**
     *  从右边弹出
     */
    eLongCustomPopViewStyleFromRight = 3
};

@interface eLongCustomPopView : UIView

// 公共方法
- (void)popViewWithStyle:(eLongCustomPopViewStyle)popStyle;

- (void)dismissView;

@end
