//
//  ElongBaseViewControllerWithEmptyView.m
//  
//
//  Created by yangfan on 16/1/7.
//
//

#import "ElongBaseViewControllerWithEmptyView.h"
#import "eLongExtension.h"

@implementation ElongBaseViewControllerWithEmptyView

-(void) loadEmptyViewWithTip:(NSString *)tip{
    if (!self.emptyView && !self.emptyView.superview) {
        if (self.view.superview) {
            self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.superview.width, self.view.superview.height-44)];
        }
        else{
            self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
        }
        
        if (!self.emptyImage && !self.emptyImage.superview) {
            CGFloat OriginX = (self.emptyView.width - 90)/2;
            CGFloat OriginY = (self.emptyView.height - 90 - 56)/2;
            self.emptyImage = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX, OriginY, 90, 90 )];
            self.emptyImage.image = [UIImage imageNamed:@"basevc_whatDoYouLookingAt"];
            [self.emptyView addSubview:self.emptyImage];
        }
        if (!self.tipLabel && !self.tipLabel.superview) {
            self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.emptyImage.y + self.emptyImage.height + 16, self.emptyView.width, 12)];
            self.tipLabel.backgroundColor = [UIColor clearColor];
            self.tipLabel.text = tip;
            self.tipLabel.textColor = [UIColor colorWithHexStr:@"#858585"];
            self.tipLabel.font =  FONT_12;
            self.tipLabel.textAlignment = NSTextAlignmentCenter;
            [self.emptyView addSubview:self.tipLabel];
        }
        [self.view addSubview:self.emptyView];
    }
    
    if (STRINGHASVALUE(tip)) {
        self.tipLabel.text = tip;
        [self.view bringSubviewToFront:self.emptyView];
        self.emptyView.hidden = NO;
    }else{
        [self.view sendSubviewToBack:self.emptyView];
        self.emptyView.hidden = YES;
    }
}

@end
