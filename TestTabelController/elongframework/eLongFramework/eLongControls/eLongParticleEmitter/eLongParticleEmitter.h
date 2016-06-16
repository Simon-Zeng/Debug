//
//  eLongParticleEmitter.h
//  ElongClient
//
//  Created by chenggong on 15/11/17.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef void (^CustomViewBlock)(void);
typedef void (^CustomLifetimeEndBlock)(void);

@interface eLongParticleEmitter : NSObject

// Initialize.
- (instancetype)initWithRootLayer:(CALayer *)rootLayer withParticleImageName:(NSString *)particleImageName withLifeTime:(CGFloat)lifeTime withCustomViewBlock:(CustomViewBlock)customViewBlock withCustomLifetimeEndBlock:(CustomLifetimeEndBlock)customLifetimeEndBlock;
// Start particle emit.
- (void)commandEmit;
// Cancel stop emit.
- (void)commandCancelStopEmit;
// End Emit
- (void)endEmit;
// Force end emit.
- (void)forceEndEmit;

@end
