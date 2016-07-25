//
//  BubbleView.m
//  TestTabelController
//
//  Created by wzg on 16/7/22.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "BubbleView.h"


@interface BubbleView()
@property (nonatomic, strong)UIBezierPath *cutePath;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIDynamicAnimator *animator;
@property (nonatomic, strong)UIColor *fillColorForCute;

@property (nonatomic, assign) CGFloat r1;
@property (nonatomic, assign) CGFloat r2;
@property (nonatomic, assign) CGFloat x1;
@property (nonatomic, assign) CGFloat x2;
@property (nonatomic, assign) CGFloat y1;
@property (nonatomic, assign) CGFloat y2;
@property (nonatomic, assign) CGFloat centerDistance;
@property (nonatomic, assign) CGFloat cosDigree;
@property (nonatomic, assign) CGFloat sinDigree;

@property (nonatomic, assign) CGPoint pointA;
@property (nonatomic, assign) CGPoint pointB;
@property (nonatomic, assign) CGPoint pointC;
@property (nonatomic, assign) CGPoint pointD;
@property (nonatomic, assign) CGPoint pointO;
@property (nonatomic, assign) CGPoint pointP;
@property (nonatomic, assign) CGRect oldBackViewFrame;
@property (nonatomic, assign) CGPoint oldBackCenter;
@property (nonatomic, assign) CGPoint initialPoint;
@property (nonatomic, strong)CAShapeLayer *shapeLayer;
@end

@implementation BubbleView



#pragma mark - lifeCycle
- (instancetype)initWithPoint:(CGPoint)point superView:(UIView *)view
{
    self.bWidth = 10;
    self = [super initWithFrame:CGRectMake(point.x, point.y, self.bWidth, self.bWidth)];
    if (self) {
        self.containerView = view;
        self.initialPoint = point;
        [self.containerView addSubview:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)drawRect
{
    self.x1 = self.backView.center.x;
    self.y1 = self.backView.center.y;
    self.x2 = self.frontView.center.x;
    self.y2 = self.frontView.center.y;
    
    self.centerDistance = sqrtf((self.x1 - _x2)*(_x1-_x2) + (_y1 - _y2)*(_y1-_y2));
    if (self.centerDistance) {
        self.cosDigree = (_y2-_y1)/self.centerDistance;
        self.sinDigree = (_x2 - _x1)/self.centerDistance;
    }else{
        self.cosDigree = 1;
        self.sinDigree = 0;
    }
    
    self.r1 = self.oldBackViewFrame.size.width/2 - self.centerDistance * self.viscosity;
    
    _pointA = CGPointMake(_x1-_r1*self.cosDigree, _y1+_r1*self.sinDigree);
    _pointB = CGPointMake(_x1+_r1*self.cosDigree, _y1 - _r1*self.sinDigree);
    _pointC = CGPointMake(_x2 + _r2*self.cosDigree, _y2 - _r2*self.sinDigree);
    _pointD = CGPointMake(_x2 - _r2*self.cosDigree, _y2 + _r2*self.sinDigree);
    _pointO = CGPointMake(_pointA.x + (self.centerDistance/2) * self.sinDigree, _pointA.y+(self.centerDistance/2)*self.cosDigree);
    _pointP = CGPointMake(_pointB.x + (self.centerDistance/2) * self.sinDigree, _pointB.y+(self.centerDistance/2)*self.cosDigree);
    
    self.backView.center = self.oldBackCenter;
    self.backView.bounds = CGRectMake(0, 0, _r1*2, _r2*2);
    self.backView.layer.cornerRadius = self.r1;
    
    self.cutePath = [UIBezierPath bezierPath];
    [self.cutePath moveToPoint:_pointA];
    [self.cutePath addQuadCurveToPoint:_pointD controlPoint:_pointO];
    [self.cutePath addLineToPoint:_pointB];
    [self.cutePath addQuadCurveToPoint:_pointC controlPoint:_pointP];
    [self.cutePath moveToPoint:_pointA];
    
    if (!self.backView.hidden) {
        self.shapeLayer.path = self.cutePath.CGPath;
        self.shapeLayer.fillColor = self.fillColorForCute.CGColor;
        [self.containerView.layer insertSublayer:self.shapeLayer below:self.frontView.layer];
    }
}
#pragma mark - customApi

#pragma mark - nativeApi

#pragma mark - privateMethod
- (void)removeAllAnimation
{
    [self.frontView.layer removeAllAnimations];
}

- (void)addAnimateLikeCenterBubble
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 0.5;
    
    CGMutablePathRef curvePath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.frontView.frame, self.frontView.frame.size.width/2-3, self.frontView.frame.size.height/2-3);
    CGPathAddEllipseInRect(curvePath, NULL, circleContainer);
    pathAnimation.path = curvePath;
    CGPathRelease(curvePath);
    [self.frontView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.keyTimes = @[@0.0,@0.5,@1.0];
    scaleX.values = @[@1.0,@1.1,@1.0];
    scaleX.autoreverses = YES;
    scaleX.repeatCount = INFINITY;
    scaleX.duration = 1;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.frontView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.keyTimes = @[@0.0,@0.5,@1.0];
    scaleY.values = @[@1.0,@1.1,@1.0];
    scaleY.autoreverses = YES;
    scaleY.repeatCount = INFINITY;
    scaleY.duration = 1;
    scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.frontView.layer addAnimation:scaleX forKey:@"scaleYAnimation"];
}
#pragma mark - publicMethod
- (void)setup
{
    self.shapeLayer = [CAShapeLayer layer];
    self.backgroundColor = [UIColor clearColor];
    self.frontView = [[UIView alloc]initWithFrame:CGRectMake(self.initialPoint.x, self.initialPoint.y, self.bWidth, self.bWidth)];
    self.r2 = self.frontView.bounds.size.width/2;
    self.frontView.layer.cornerRadius = self.r2;
    self.frontView.backgroundColor = self.bColor;
    
    self.backView = [[UIView alloc]initWithFrame:self.frontView.frame];
    self.r1 = self.backView.frame.size.width/2;
    self.backView.layer.cornerRadius = self.r1;
    self.backView.backgroundColor = self.bColor;
    
    self.title = [UILabel new];
    self.title.frame = CGRectMake(0, 0, self.frontView.frame.size.width, self.frontView.frame.size.height);
    self.title.textColor = [UIColor whiteColor];
    self.title.textAlignment = NSTextAlignmentCenter;
    
    [self.frontView insertSubview:self.title atIndex:0];
    
    [self.containerView addSubview:self.backView];
    [self.containerView addSubview:self.frontView];
    
    _x1 = self.backView.center.x;
    _y1 = self.backView.center.y;
    _x2 = self.frontView.center.x;
    _y2 = self.frontView.center.y;
    _pointA = CGPointMake(_x1-_r1, _y1);
    _pointB = CGPointMake(_x1+_r1, _y1);
    _pointC = CGPointMake(_x2+_r2, _y2);
    _pointD = CGPointMake(_x2-_r2, _y2);
    _pointO = CGPointMake(_x1+_r1, _y1);
    _pointP = CGPointMake(_x2+_r2, _y2);
    
    self.oldBackViewFrame = self.backView.frame;
    self.oldBackCenter = self.backView.center;
    
    self.backView.hidden = YES;
    [self addAnimateLikeCenterBubble];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self.frontView addGestureRecognizer:pan];
}

- (void)removeAnimate:(BOOL)remove
{
    if (remove) {
        [self removeAllAnimation];
    }
}
#pragma mark - property

#pragma mark - action
- (void)panGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint drawPoint = [pan locationInView:self.containerView];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.backView.hidden = NO;
            self.fillColorForCute = self.bColor;
            [self removeAllAnimation];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.frontView.center = drawPoint;
            if (self.r1<=6) {
                self.fillColorForCute = [UIColor clearColor];
                self.backView.hidden = YES;
                [self.shapeLayer removeFromSuperlayer];
            }
            [self drawRect];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            self.backView.hidden = YES;
        self.fillColorForCute = [UIColor clearColor];
            [self.shapeLayer removeFromSuperlayer];
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.4f initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.frontView.center = self.oldBackCenter;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self addAnimateLikeCenterBubble];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}
@end
