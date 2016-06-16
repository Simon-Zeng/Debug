//
//  SearchBarView.m
//  ElongClient
//
//  Created by Dawn on 14-3-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongSearchBarView.h"
#import "eLongDefine.h"
#import "UIImage+eLongExtension.h"

@implementation eLongSearchBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.translucent	=  YES;
        
        
//        if (!IOSVersion_5) {
//            self.backgroundColor = RGBACOLOR(236, 236, 236, 1);
//            for (UIView *subview in self.subviews) {
//                if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                    subview.alpha = 0.0;
//                    break;
//                }
//            }
//        }else{
            self.backgroundColor = [UIColor clearColor];
            self.backgroundImage = [UIImage stretchableImageWithPath:@"searchbar_bg.png"];
            [self setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbar_field_bg.png"] forState:UIControlStateNormal];
//        }
    }
    return self;
}

-(void)startLoadingAtRightSide{
    [self showRightLoadingOrNot:YES];
}

-(void)stopLoadingAtRightSide{
    [self showRightLoadingOrNot:NO];
}


-(void)showRightLoadingOrNot:(BOOL)yes{

    if (!indicator) {
        indicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    UITextField *textField = nil;
//    if (IOSVersion_61) {
        for (UIView *subv in self.subviews) {
            for (UIView* view in subv.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                    textField = (UITextField*)view;
                    if (yes) {
                        textField.rightViewMode = UITextFieldViewModeAlways;
                        textField.rightView = indicator;
                        textField.rightView.contentMode = UIViewContentModeLeft;
                        [indicator startAnimating];
                    }else{
                        [indicator stopAnimating];
                        textField.rightView = nil;
                    }
                    break;
                }
            }
        }
//    }else{
//        for (UITextField *subv in self.subviews) {
//            if ([subv isKindOfClass:[UITextField class]]) {
//                textField = (UITextField*)subv;
//                if (yes) {
//                    textField.rightViewMode = UITextFieldViewModeAlways;
//                    textField.rightView = indicator;
//                    textField.rightView.contentMode = UIViewContentModeLeft;
//                    [indicator startAnimating];
//
//                }else{
//                    [indicator stopAnimating];
//                    indicator = nil;
//                    textField.rightView = nil;
//                }
//                break;
//            }
//        }
//    }
    
}

-(void)dealloc
{
}

@end
