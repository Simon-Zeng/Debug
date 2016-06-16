//
//  UIImageView.m
//  Pods
//
//  Created by chenggong on 15/5/27.
//
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

+ (UIImageView *)roundCornerViewWithFrame:(CGRect)rect {
    UIImageView *backView = [[UIImageView alloc] initWithFrame:rect];
    backView.image					= [[UIImage imageNamed:@"white_boder.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:12];
    backView.userInteractionEnabled = YES;
    return backView;
}


+ (UIImageView *)graySeparatorWithFrame:(CGRect)rect {
    UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"basevc_dashed.png"]];
    separatorLine.contentMode	= UIViewContentModeScaleAspectFill;
    separatorLine.clipsToBounds = YES;
    separatorLine.frame			= rect;
    
    return separatorLine;
}

+ (UIImageView *)graySplitWithFrame:(CGRect)rect{
    UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fillorder_cell_dashline.png"]];
    separatorLine.contentMode	= UIViewContentModeScaleAspectFill;
    separatorLine.clipsToBounds = YES;
    separatorLine.frame			= rect;
    return separatorLine;
}

+ (UIImageView *)dashedHalfLineWithFrame:(CGRect)rect
{
    UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed_half.png"]];
    separatorLine.contentMode	= UIViewContentModeScaleAspectFill;
    separatorLine.clipsToBounds = YES;
    separatorLine.frame			= rect;
    
    return separatorLine;
}

+(UIImageView *)separatorWithFrame:(CGRect)rect{
    UIImageView *separatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"basevc_dashed.png"]];
    separatorLine.contentMode	= UIViewContentModeScaleAspectFill;
    separatorLine.clipsToBounds = YES;
    separatorLine.frame			= CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height / [UIScreen mainScreen].scale);
    
    return separatorLine;
}


+ (UIImageView *)verticalSeparatorWithFrame:(CGRect)rect {
    UIImageView *graySeparator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray_separator.png"]];
    graySeparator.frame = rect;
    
    return graySeparator;
}


+ (UIImageView *)bottomSeparatorWithFrame:(CGRect)rect {
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBar_separator.png"]];
    separator.frame = rect;
    
    return separator;
}

@end
