
// Countly.h
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import <Foundation/Foundation.h>

#define LOG_ID                  @"logid"



@class CountlyEventQueue;

@interface Countly : NSObject
{
	double unsentSessionLength;
	NSTimer *timer;
	double lastTime;
	BOOL isSuspended;
    CountlyEventQueue *eventQueue;
}
/**
 *  用户登录状态，登录为1，非登录为2
 */
@property (nonatomic,assign) NSInteger status;
/**
 *  渠道号
 */
@property (nonatomic,copy) NSString *channelId;
/**
 *  客户端类型
 */
@property (nonatomic,copy) NSString *appt;
/**
 *  app key
 */
@property (nonatomic,copy) NSString *appKey;
/**
 *  app host
 */
@property (nonatomic,copy) NSString *appHost;
/**
 *  logid，统计所有打点事件数量，自增
 */
@property (nonatomic, assign) NSUInteger eventid;

+ (instancetype)sharedInstance;

- (void)start:(NSString *)appKey withHost:(NSString *)appHost;

- (void)startOnCloudWithAppKey:(NSString *)appKey;

- (void)recordEvent:(NSString *)key count:(int)count;

- (void)recordEvent:(NSString *)key count:(int)count sum:(double)sum;

- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSInteger)count;

- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(int)count sum:(double)sum;

@end


