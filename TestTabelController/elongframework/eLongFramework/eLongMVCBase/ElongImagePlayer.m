//
//  elongImagePlayer.m
//  MyElong
//
//  Created by yongxue on 16/1/7.
//  Copyright © 2016年 lvyue. All rights reserved.
//

#import "ElongImagePlayer.h"

@implementation ElongImagePlayer

-(void)play{
	if (!self.playing) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 1; i <= 11; i ++) {
            NSString *imageName = [NSString stringWithFormat:@"Elong_loading_%ld",(long)i];
            UIImage *image = [UIImage imageNamed:imageName];
            if (image) {
                [array addObject:image];
            }
        }
        _images = array;
		timer = [NSTimer scheduledTimerWithTimeInterval:0.15
                                                 target:self
                                               selector:@selector(timerHandler:)
                                               userInfo:nil
                                                repeats:YES];
		_playing = YES;
	}
}

- (void)stop {
	[self pause];
	playIndex = 0;
}

- (void)pause {
	if (self.playing) {
		[timer invalidate];
		self.playing = NO;
	}
}

- (void)setFrames:(NSArray *)arr {
	self.image = [arr objectAtIndex:0];
	_images = arr;
}

- (void)timerHandler:(NSTimer *)timer {
	if (playIndex>[self.images count]-1) {
		playIndex=0;
	}
    if (self.images.count > playIndex) {
        self.image=[self.images objectAtIndex:playIndex];
        playIndex ++;
    }
}

@end
