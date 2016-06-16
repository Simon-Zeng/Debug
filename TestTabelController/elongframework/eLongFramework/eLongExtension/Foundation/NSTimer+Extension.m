//
//  NSTimer+Extension.m
//  Pods
//
//  Created by 李禹 on 16/3/26.
//
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)

+ (NSTimer *)eLongScheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(eLongBlockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)eLongBlockInvoke:(NSTimer*)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
