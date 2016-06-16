//
//  eLongNewLoadingView.m
//  eLongFramework
//
//  Created by zhaoyingze on 15/10/9.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "eLongNewLoadingView.h"

@implementation eLongNewLoadingView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 42)/2, (frame.size.height - 42) / 2, 42, 42)];
        bgView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        bgView.layer.cornerRadius = 5;
        [self addSubview:bgView];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidesWhenStopped	= YES;
        indicatorView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self addSubview:indicatorView];
        
        self.hidden = YES;
    }
    
    return self;
}


- (void)startLoading {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.hidden)
        {
            self.hidden = NO;
            
            if (![indicatorView isAnimating]) {
                
                [indicatorView startAnimating];
            }
        }
        
    });
}


- (void)stopLoading {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.hidden) {
            
            self.hidden = YES;
        }
        
    });
}

@end
