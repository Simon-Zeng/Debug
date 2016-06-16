//
//  eLongNewLoadingView.h
//  eLongFramework
//
//  Created by zhaoyingze on 15/10/9.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eLongNewLoadingView : UIView {
    
@private
    UIActivityIndicatorView *indicatorView;
}

- (void)startLoading;
- (void)stopLoading;

@end
