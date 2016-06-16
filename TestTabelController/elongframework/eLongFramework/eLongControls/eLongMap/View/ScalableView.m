//
//  ScalableView.m
//  ElongClient
//
//  Created by Wang Shuguang on 12-12-11.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "ScalableView.h"
#import "NSArray+CheckArray.h"

#define SCALABLEBUTTONTAG 1010

@interface ScalableView()

@property (nonatomic, assign) CGSize buttonSize;
@property (nonatomic, assign) int buttonSpace;
@property (nonatomic, assign) NSUInteger buttonCount;
@property (nonatomic, assign) BOOL expand;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, assign) float frameTime;
@property (nonatomic, assign) int bounceSpace;
@property (nonatomic, assign) NSInteger lastIndex;

@end

@implementation ScalableView

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images highlightedImages:(NSArray *)hImages{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = images;
        self.hightlightedArray = hImages;
        // Initialization code
        _buttons = [[NSMutableArray alloc] initWithCapacity:[images count]];
        _buttonSize = CGSizeMake(frame.size.height, frame.size.height);
        _buttonCount = [images count];
        _buttonSpace = (frame.size.width - _buttonSize.width + 0.0)/(_buttonCount - 1);
        _expand = NO;
        _frameTime = 0.8/(_buttonCount - 1);
        _bounceSpace = 16;
        
        for (int i = 0; i < [images count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(frame.size.width - _buttonSize.width, 0, _buttonSize.width, _buttonSize.height);
            [button setImage:[UIImage imageNamed:[images safeObjectAtIndex:i]] forState:UIControlStateNormal];
            if (hImages && [hImages count] > i) {
                [button setImage:[UIImage imageNamed:[hImages safeObjectAtIndex:i]] forState:UIControlStateHighlighted];
            }
            [self addSubview:button];
            [_buttons addObject:button];
            button.tag = i + SCALABLEBUTTONTAG;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setAdjustsImageWhenDisabled:NO];
        }
        
        UIButton *button =  (UIButton *)[self viewWithTag:0 + SCALABLEBUTTONTAG];
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bounceSpace, 5)];
        _lineView.center = CGPointMake(round(button.center.x),round(button.center.y));
        //lineView.image = [UIImage noCacheImageNamed:@"nav_line.png"];
        [self addSubview:_lineView];
        [self sendSubviewToBack:_lineView];
        
        _lastIndex = -1;
    }
    return self;
}
- (void) moveBack{
    if (_expand) {
        
        NSUInteger index = _imageArray.count - 1;
        UIButton *button = (UIButton *)[self viewWithTag:index + SCALABLEBUTTONTAG];
        [button setImage:[UIImage imageNamed:[self.imageArray safeObjectAtIndex:index]] forState:UIControlStateNormal];
        [self beginAnimation];
    }
}

- (void) moveOut{
    if (!_expand) {
        _frameTime = 0;
        NSUInteger index = _imageArray.count - 1;
        UIButton *button = (UIButton *)[self viewWithTag:index + SCALABLEBUTTONTAG];
        [button setImage:[UIImage imageNamed:[self.hightlightedArray safeObjectAtIndex:index]] forState:UIControlStateNormal];
        [self beginAnimation];
        _frameTime = 0.8/(_buttonCount - 1);
    }
}

- (void) buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if (_lastIndex != _imageArray.count - 1 && _lastIndex != -1) {
        UIButton *lastButton = (UIButton *)[self viewWithTag:_lastIndex + SCALABLEBUTTONTAG];
        [lastButton setImage:[UIImage imageNamed:[self.imageArray safeObjectAtIndex:_lastIndex]] forState:UIControlStateNormal];
    }
    _lastIndex = button.tag - SCALABLEBUTTONTAG;
    if (_lastIndex != _imageArray.count - 1 && _lastIndex != -1) {
        [button setImage:[UIImage imageNamed:[self.hightlightedArray safeObjectAtIndex:_lastIndex]] forState:UIControlStateNormal];
    }
    
    if (_lastIndex == _imageArray.count - 1) {
        if (!_expand) {
            [button setImage:[UIImage imageNamed:[self.hightlightedArray safeObjectAtIndex:_lastIndex]] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:[self.imageArray safeObjectAtIndex:_lastIndex]] forState:UIControlStateNormal];
        }
    }

    
    if (button.tag-SCALABLEBUTTONTAG == _buttonCount - 1) {
        // 最上层的触发按钮
        [self beginAnimation];
        if ([_delegate respondsToSelector:@selector(scalableViewDidMoveout:)]) {
            [_delegate scalableViewDidMoveout:self];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(scalableView:didSelectedAtIndex:)]) {
            [_delegate scalableView:self didSelectedAtIndex:button.tag - SCALABLEBUTTONTAG];
        }
    }
}

#pragma mark -
#pragma mark HitTest
-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIButton *baseButton =  (UIButton *)[self viewWithTag:SCALABLEBUTTONTAG + _buttonCount - 1];
    if (point.x > baseButton.frame.origin.x
        && point.x < baseButton.frame.origin.x + baseButton.frame.size.width
        && point.y > baseButton.frame.origin.y
        && point.y < baseButton.frame.origin.y + baseButton.frame.size.height) {
        return baseButton;
    }
    
    
    
    for (int i = 0; i < _buttonCount-1; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:SCALABLEBUTTONTAG + i];
        if (point.x > button.frame.origin.x
            && point.x < button.frame.origin.x + button.frame.size.width
            && point.y > button.frame.origin.y
            && point.y < button.frame.origin.y + button.frame.size.height) {
            return button;
        }
    }
    
    return nil;
}

- (void) beginAnimation{
   
    if (!_expand) {
        _expand = YES;
        
        CGPoint startPoint = CGPointZero;
        CGPoint endPoint = CGPointZero;
        for (int i = 0; i < _buttonCount - 1; i++) {
            startPoint = CGPointMake(self.frame.size.width - _buttonSize.width/2, _buttonSize.width/2);
            endPoint = CGPointMake(startPoint.x - (_buttonCount - i - 1) * _buttonSpace, _buttonSize.width/2);
            
            
            UIButton *button = (UIButton *)[_buttons safeObjectAtIndex:i];
            
            // 旋转
            float duration = (_buttonCount - i - 1) * _frameTime;
            CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotateAnimation.values = [NSArray arrayWithObjects:
                                      [NSNumber numberWithFloat:0],
                                      [NSNumber numberWithFloat:-M_PI],
                                      [NSNumber numberWithFloat:-M_PI * 2], nil];
            rotateAnimation.duration = duration;
            rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                        [NSNumber numberWithFloat:0],
                                        [NSNumber numberWithFloat:duration * 1/2],
                                        [NSNumber numberWithFloat:duration], nil];
            
            
            // 按轨迹移动
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
            for (int j = 0; j < _buttonCount - 1 - i; j++) {
                if (j == _buttonCount - 1 - i - 1) {
                    CGPathAddLineToPoint(path, NULL, startPoint.x - (_buttonCount - 1 - i) * _buttonSpace - _bounceSpace, startPoint.y);
                }else{
                    CGPathAddLineToPoint(path, NULL, startPoint.x - (j + 1) * _buttonSpace, startPoint.y);
                }
            }
            CGPathAddLineToPoint(path, NULL, startPoint.x - (_buttonCount - 1 - i) * _buttonSpace, startPoint.y);
            
            positionAnimation.path = path;
            CGPathRelease(path);
            positionAnimation.duration = duration;
            
            
            CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
//            if (IOSVersion_5) {
                animationgroup.animations = [NSArray arrayWithObjects:rotateAnimation,positionAnimation, nil];
//            }else{
//                animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
//            }
            
            animationgroup.duration = duration;
            animationgroup.fillMode = kCAFillModeForwards;
            animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [button.layer addAnimation:animationgroup forKey:@"out"];
            button.center = endPoint;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:_frameTime*(_buttonCount-1) - 0.22];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _lineView.frame = CGRectMake(startPoint.x - (_buttonCount - 1) * _buttonSpace - _buttonSize.width/2 + 6, round(_buttonSize.height/2 -2), (_buttonCount - 1) * _buttonSpace + _buttonSize.width - 12, 5);
        [UIView commitAnimations];
    }else{
        _expand = NO;
        CGPoint endPoint = CGPointZero;
        CGPoint startPoint = CGPointZero;
        for (int i = 0; i < _buttonCount - 1; i++) {
            endPoint = CGPointMake(self.frame.size.width - _buttonSize.width/2, _buttonSize.width/2);
            startPoint = CGPointMake(endPoint.x - (_buttonCount - i - 1) * _buttonSpace, _buttonSize.width/2);
            
            UIButton *button = (UIButton *)[_buttons safeObjectAtIndex:i];
            
            // 旋转
            float duration = (_buttonCount - i - 1) * _frameTime;
            CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotateAnimation.values = [NSArray arrayWithObjects:
                                      [NSNumber numberWithFloat:0],
                                      [NSNumber numberWithFloat:M_PI],
                                      [NSNumber numberWithFloat:M_PI * 2], nil];
            rotateAnimation.duration = duration;
            rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                        [NSNumber numberWithFloat:0],
                                        [NSNumber numberWithFloat:duration * 1/2],
                                        [NSNumber numberWithFloat:duration], nil];
            
            // 按轨迹移动
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
            CGPathAddLineToPoint(path, NULL, startPoint.x - _bounceSpace/2, startPoint.y);
            for (int j = 0; j < _buttonCount - 1 - i; j++) {
                CGPathAddLineToPoint(path, NULL, startPoint.x + (j + 1) * _buttonSpace, startPoint.y);
            }
            //CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
            positionAnimation.path = path;
            CGPathRelease(path);
            positionAnimation.duration = (_buttonCount - i - 1) * _frameTime;
            
            
            CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
            animationgroup.animations = [NSArray arrayWithObjects:rotateAnimation,positionAnimation, nil];
            animationgroup.duration = duration;
            animationgroup.speed = 2;
            animationgroup.fillMode = kCAFillModeForwards;
            animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [button.layer addAnimation:animationgroup forKey:@"in"];
            button.center = endPoint;

        }

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:_frameTime*(_buttonCount-1)/2];
        [UIView setAnimationDelay:0.01];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        _lineView.frame = CGRectMake(endPoint.x,round(_buttonSize.height/2 -2), _bounceSpace, 5);
        [UIView commitAnimations];
    }
   
}
@end
