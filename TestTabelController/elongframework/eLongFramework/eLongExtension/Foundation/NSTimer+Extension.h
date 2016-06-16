//
//  NSTimer+Extension.h
//  Pods
//
//  Created by 李禹 on 16/3/26.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)

+ (NSTimer *)eLongScheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats;
@end
