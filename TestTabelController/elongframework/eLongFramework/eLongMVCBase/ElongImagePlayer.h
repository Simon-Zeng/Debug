//
//  elongImagePlayer.h
//  MyElong
//
//  Created by yongxue on 16/1/7.
//  Copyright © 2016年 lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElongImagePlayer : UIImageView {
	NSTimer *timer;
	NSInteger playIndex;
}

-(void)play;

-(void)stop;

-(void)pause;


@property (nonatomic,strong) NSArray *images;
@property (readwrite) BOOL playing;


@end
