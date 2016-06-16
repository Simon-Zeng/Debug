//
//  eLongParticleEmitter.m
//  ElongClient
//
//  Created by chenggong on 15/11/17.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongParticleEmitter.h"
#import "elongDefine.h"
#import <CoreMotion/CoreMotion.h>

@interface eLongParticleEmitter()

@property (nonatomic, strong) CALayer *rootLayer;
@property (nonatomic, copy) NSString *particleImageName;
@property (nonatomic, assign) CGFloat lifeTime;
@property (nonatomic, strong) CAEmitterLayer *emitterLayer;
@property (nonatomic, strong) CAEmitterCell *emitterCell;
@property (nonatomic, strong) CAEmitterCell *smallEmitterCell;
@property (nonatomic, strong) CMMotionManager * motionManager;
@property (nonatomic, assign) BOOL cancelStopEmit;
@property (nonatomic, copy) CustomViewBlock customViewBlock;
@property (nonatomic, copy) CustomLifetimeEndBlock customLifetimeEndBlock;

@end

@implementation eLongParticleEmitter

- (void)dealloc {
    [_motionManager stopDeviceMotionUpdates];
}

- (instancetype)initWithRootLayer:(CALayer *)rootLayer withParticleImageName:(NSString *)particleImageName withLifeTime:(CGFloat)lifeTime withCustomViewBlock:(CustomViewBlock)customViewBlock withCustomLifetimeEndBlock:(CustomLifetimeEndBlock)customLifetimeEndBlock{
    if (self = [super init]) {
        self.rootLayer = rootLayer;
        self.particleImageName = particleImageName;
        self.lifeTime = lifeTime;
        self.customViewBlock = [customViewBlock copy];
        self.customLifetimeEndBlock = [customLifetimeEndBlock copy];
        
        [self createCAEmitterLayer];
        
        if (_customViewBlock) {
            _customViewBlock();
        }
    }
    
    return self;
}

- (void)createCAEmitterLayer {
    self.emitterLayer = [CAEmitterLayer layer];
    // 从屏幕顶端生成线状发射器
    _emitterLayer.emitterPosition = CGPointMake(SCREEN_WIDTH / 2, 20);
    _emitterLayer.emitterSize = CGSizeMake(SCREEN_WIDTH, 0);
    _emitterLayer.emitterMode = kCAEmitterLayerSurface;
    _emitterLayer.emitterShape = kCAEmitterLayerLine;
    
    // Create CAEmitterCell on CAEmitterLayer.
    [self createCAEmitterCell:_emitterLayer];
}

- (void)createCAEmitterCell:(CAEmitterLayer *)emitterLayer {
    //创建粒子
    self.emitterCell = [CAEmitterCell emitterCell];
    _emitterCell.name = _particleImageName;
//    if (IOSVersion_7) {
        _emitterCell.birthRate = 1.0;
//    }
//    else {
//        _emitterCell.birthRate = 5.0;
//    }
    _emitterCell.lifetime = 120.0;
//    if (IOSVersion_7) {
        _emitterCell.velocity = 10.0;
//    }
//    else {
//        _emitterCell.velocity = -50.0;
//    }
    _emitterCell.velocityRange = 10;
//    if (IOSVersion_7) {
        _emitterCell.yAcceleration = 5.0f;
//    }
//    else {
//        _emitterCell.yAcceleration = 0.0f;
//    }
    
    _emitterCell.emissionRange = 0.5 * M_PI;
    _emitterCell.spinRange = 0.25 * M_PI;
    _emitterCell.scale = 1 / [UIScreen mainScreen].scale;
    _emitterCell.contents = (id)[[UIImage imageNamed:_particleImageName] CGImage];
    
    self.smallEmitterCell = [CAEmitterCell emitterCell];
    _smallEmitterCell.name = _particleImageName;
    _smallEmitterCell.birthRate = 2.0;
    _smallEmitterCell.lifetime = 120.0;
//    if (IOSVersion_7) {
        _smallEmitterCell.velocity = 10.0;
//    }
//    else {
//        _smallEmitterCell.velocity = -50.0;
//    }
    _smallEmitterCell.velocityRange = 10;
//    if (IOSVersion_7) {
        _smallEmitterCell.yAcceleration = 5.0f;
//    }
//    else {
//        _smallEmitterCell.yAcceleration = 0.0f;
//    };
    _smallEmitterCell.emissionRange = 0.5 * M_PI;
    _smallEmitterCell.spinRange = 0.25 * M_PI;
    _smallEmitterCell.scale = 1 / ([UIScreen mainScreen].scale * 2);
    _smallEmitterCell.contents = (id)[[UIImage imageNamed:_particleImageName] CGImage];
    
    emitterLayer.emitterCells = @[_emitterCell, _smallEmitterCell];
}

- (void)commandEmit {
    // Emit.
    [_rootLayer addSublayer:_emitterLayer];
    [self startMotionManager];
    [self startLifeTimeTimer];
}

- (void)startLifeTimeTimer {
    if ((NSUInteger)_lifeTime == 0 ) {
        return;
    }
    double delayInSeconds = _lifeTime;
    dispatch_time_t endTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(endTime, dispatch_get_main_queue(), ^(void){
        [self endEmit];
    });
}

- (void)endEmit {
    if (_cancelStopEmit) {
        return;
    }
    
    [_motionManager stopDeviceMotionUpdates];
    [_emitterLayer removeFromSuperlayer];
    if (_customLifetimeEndBlock) {
        _customLifetimeEndBlock();
    }
}

- (void)forceEndEmit {
    [_motionManager stopDeviceMotionUpdates];
    [_emitterLayer removeFromSuperlayer];
    if (_customLifetimeEndBlock) {
        _customLifetimeEndBlock();
    }
}

- (void)commandCancelStopEmit {
    self.cancelStopEmit = YES;
}

- (void)startMotionManager{
    if (_motionManager == nil) {
        self.motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        NSLog(@"No device motion on device.");
        [self setMotionManager:nil];
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    NSString *emitterCellsxAccelerationKeyPathName = [NSString stringWithFormat:@"emitterCells.%@.xAcceleration", _particleImageName];
    
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            // UIDeviceOrientationPortraitUpsideDown;
        }
        else{
            // UIDeviceOrientationPortrait;
        }
        [_emitterLayer setValue:@0.0f forKeyPath:emitterCellsxAccelerationKeyPathName];
    }
    else
    {
        if (x >= 0){
            // UIDeviceOrientationLandscapeRight;
            [_emitterLayer setValue:@10.0f forKeyPath:emitterCellsxAccelerationKeyPathName];
        }
        else{
            // UIDeviceOrientationLandscapeLeft;
            [_emitterLayer setValue:@-10.0f forKeyPath:emitterCellsxAccelerationKeyPathName];
        }
    }
}

@end
