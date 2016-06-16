// Countly.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#pragma mark - Directives

#if __has_feature(objc_arc)
#error This is a non-ARC class. Please add -fno-objc-arc flag for Countly.m, Countly_OpenUDID.m and CountlyDB.m under Build Phases > Compile Sources
#endif

#ifndef COUNTLY_DEBUG
#define COUNTLY_DEBUG 0
#endif

#ifndef COUNTLY_IGNORE_INVALID_CERTIFICATES
#define COUNTLY_IGNORE_INVALID_CERTIFICATES 0
#endif

#if COUNTLY_DEBUG
#   define COUNTLY_LOG(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#else
#   define COUNTLY_LOG(...)
#endif

#define COUNTLY_VERSION "2.0"
#define COUNTLY_DEFAULT_UPDATE_INTERVAL 60.0
#define COUNTLY_EVENT_SEND_THRESHOLD 10

#import "Countly.h"
#import "Countly_OpenUDID.h"
#import "CountlyDB.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#endif

#include <sys/types.h>
#include <sys/sysctl.h>

#import "eLongNetworkReachability.h"
#import "eLongLocation.h"
#import "eLongAccountManager.h"
#import "eLongKeyChain.h"
#import "NSString+eLongExtension.h"
#import "eLongDefine.h"
#import "eLongFileIOUtils.h"

#pragma mark - Helper Functions

NSString* CountlyJSONFromObject(id object);
NSString* CountlyURLEscapedString(NSString* string);
NSString* CountlyURLUnescapedString(NSString* string);

NSString* CountlyJSONFromObject(id object)
{
	NSError *error = nil;
	NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
	
	if (error)
        COUNTLY_LOG(@"%@", [error description]);
	
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

NSString* CountlyURLEscapedString(NSString* string)
{
	// Encode all the reserved characters, per RFC 3986
	// (<http://www.ietf.org/rfc/rfc3986.txt>)
	CFStringRef escaped =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)string,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
	return [(NSString*)escaped autorelease];
}

NSString* CountlyURLUnescapedString(NSString* string)
{
	NSMutableString *resultString = [NSMutableString stringWithString:string];
	[resultString replaceOccurrencesOfString:@"+"
								  withString:@" "
									 options:NSLiteralSearch
									   range:NSMakeRange(0, [resultString length])];
	return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


#pragma mark - CountlyDeviceInfo

@interface CountlyDeviceInfo : NSObject

+ (NSString *)udid;
+ (NSString *)device;
+ (NSString *)osName;
+ (NSString *)osVersion;
+ (NSString *)carrier;
+ (NSString *)resolution;
+ (NSString *)locale;
+ (NSString *)appVersion;
+ (NSString *)appName;
+ (NSString *)wirelessInternet;

+ (NSString *)metrics;

@end

@implementation CountlyDeviceInfo

+ (NSString *)udid
{
    return [eLongKeyChain macAddress]; //return [Countly_OpenUDID value];
}

+ (NSString *)device
{
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    char *modelKey = "hw.machine";
#else
    char *modelKey = "hw.model";
#endif
    size_t size;
    sysctlbyname(modelKey, NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname(modelKey, model, &size, NULL, 0);
    NSString *modelString = [NSString stringWithUTF8String:model];
    free(model);
    return modelString;
}

+ (NSString *)osName
{
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	return @"iOS";
#else
	return @"OS X";
#endif
}

+ (NSString *)osVersion
{
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	return [[UIDevice currentDevice] systemVersion];
#else
    SInt32 majorVersion, minorVersion, bugFixVersion;
    Gestalt(gestaltSystemVersionMajor, &majorVersion);
    Gestalt(gestaltSystemVersionMinor, &minorVersion);
    Gestalt(gestaltSystemVersionBugFix, &bugFixVersion);
    if (bugFixVersion > 0)
    {
    	return [NSString stringWithFormat:@"%d.%d.%d", majorVersion, minorVersion, bugFixVersion];
    }
    else
    {
    	return [NSString stringWithFormat:@"%d.%d", majorVersion, minorVersion];
    }
#endif
}

+ (NSString *)carrier
{
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	if (NSClassFromString(@"CTTelephonyNetworkInfo"))
	{
		CTTelephonyNetworkInfo *netinfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
		CTCarrier *carrier = [netinfo subscriberCellularProvider];
		return [carrier carrierName];
	}
#endif
	return nil;
}

+ (NSString *)resolution
{
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	CGRect bounds = [[UIScreen mainScreen] bounds];
	CGFloat scale = [[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.f;
	CGSize res = CGSizeMake(bounds.size.width * scale, bounds.size.height * scale);
	NSString *result = [NSString stringWithFormat:@"%gx%g", res.width, res.height];
    
	return result;
#else
    NSRect screenRect = NSScreen.mainScreen.frame;
    return [NSString stringWithFormat:@"%.1fx%.1f", screenRect.size.width, screenRect.size.height];
#endif
}

+ (NSString *)locale
{
	return [[NSLocale currentLocale] localeIdentifier];
}

+ (NSString *)appVersion
{
    NSString *result = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([result length] == 0)
        result = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    return result;
}

+ (NSString *)appName{
    NSString *result = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if ([result length] == 0){
        result = @"艺龙旅行";
    }
    
    return result;
}

+ (NSString *)wirelessInternet{
    //CFAbsoluteTime begin1 = CFAbsoluteTimeGetCurrent();
    eLongNetworkReachability *reachability = [eLongNetworkReachability reachabilityForInternetConnection];
    if (reachability.currentReachabilityStatus == eLongNetworkReachabilityStatusReachableViaWiFi) {
        //CFAbsoluteTime begin2 = CFAbsoluteTimeGetCurrent();
        //[[ElongMemoryCache sharedInstance] setObject:@"" forKey:[NSString stringWithFormat:@"%.0f:%f",[[NSDate date] timeIntervalSince1970],begin2 - begin1]];
        return @"wifi";
    }else if(reachability.currentReachabilityStatus == eLongNetworkReachabilityStatusReachableViaWWAN){
        //CFAbsoluteTime begin2 = CFAbsoluteTimeGetCurrent();
        //[[ElongMemoryCache sharedInstance] setObject:@"" forKey:[NSString stringWithFormat:@"%.0f:%f",[[NSDate date] timeIntervalSince1970],begin2 - begin1]];
        return @"2g/3g";
    }
    return @"";
}

+ (NSString *)metrics
{
    NSMutableDictionary* metricsDictionary = [NSMutableDictionary dictionary];
	[metricsDictionary safeSetObject:CountlyDeviceInfo.device forKey:@"_device"];
	[metricsDictionary safeSetObject:CountlyDeviceInfo.osName forKey:@"_os"];
	[metricsDictionary safeSetObject:CountlyDeviceInfo.osVersion forKey:@"_os_version"];
    
	NSString *carrier = CountlyDeviceInfo.carrier;
	if (carrier)
        [metricsDictionary safeSetObject:carrier forKey:@"_carrier"];

	[metricsDictionary safeSetObject:CountlyDeviceInfo.resolution forKey:@"_resolution"];
	[metricsDictionary safeSetObject:CountlyDeviceInfo.locale forKey:@"_locale"];
	[metricsDictionary safeSetObject:CountlyDeviceInfo.appVersion forKey:@"_app_version"];
    [metricsDictionary safeSetObject:CountlyDeviceInfo.appName forKey:@"_app_name"];
    [metricsDictionary safeSetObject:CountlyDeviceInfo.wirelessInternet forKey:@"_wireless_internet"];
    [metricsDictionary safeSetObject:[Countly sharedInstance].appKey forKey:@"_app_key"];
    
    NSString *deviceId = [eLongKeyChain macAddress];
    if (deviceId) {
        [metricsDictionary safeSetObject:deviceId forKey:@"_device_id"];
    }
    [metricsDictionary safeSetObject:@"1" forKey:@"_site"];
    [metricsDictionary safeSetObject:@"1" forKey:@"_appt"];
    [metricsDictionary safeSetObject:[Countly sharedInstance].channelId forKey:@"_channelid"];
    
    eLongLocation *location = [eLongLocation sharedInstance];
    [metricsDictionary safeSetObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"_userlongitude"];
    [metricsDictionary safeSetObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"_userlatitude"];
    
    NSString *account = [[eLongAccountManager userInstance] phoneNo];
    [metricsDictionary safeSetObject:([account notEmpty]?account:@"") forKey:@"_account"];
    NSString *cardNo = [[eLongAccountManager userInstance] cardNo];
    [metricsDictionary safeSetObject:([cardNo notEmpty]?cardNo:@"") forKey:@"_cardno"];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefaults objectForKey:@"DeviceToken"];
    [metricsDictionary safeSetObject:([deviceToken notEmpty]?deviceToken:@"") forKey:@"_push_id"];
	return CountlyURLEscapedString(CountlyJSONFromObject(metricsDictionary));
}

@end


#pragma mark - CountlyEvent

@interface CountlyEvent : NSObject
{
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, retain) NSDictionary *segmentation;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) double sum;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, assign) NSUInteger eventid;

@end

@implementation CountlyEvent

- (void)dealloc
{
    self.key = nil;
    self.segmentation = nil;
    [super dealloc];
}

+ (CountlyEvent*)objectWithManagedObject:(NSManagedObject*)managedObject
{
	CountlyEvent* event = [[CountlyEvent new] autorelease];
	
	event.key = [managedObject valueForKey:@"key"];
	event.count = [[managedObject valueForKey:@"count"] doubleValue];
	event.sum = [[managedObject valueForKey:@"sum"] doubleValue];
	event.timestamp = [[managedObject valueForKey:@"timestamp"] doubleValue];
	event.segmentation = [managedObject valueForKey:@"segmentation"];
    event.eventid = [[managedObject valueForKey:@"eventid"] unsignedIntegerValue];
    return event;
}

- (NSDictionary*)serializedData
{
	NSMutableDictionary* eventData = NSMutableDictionary.dictionary;
	[eventData setObject:self.key forKey:@"key"];
	if (self.segmentation)
    {
		[eventData setObject:self.segmentation forKey:@"segmentation"];
	}
	[eventData setObject:@(self.count) forKey:@"count"];
	[eventData setObject:@(self.sum) forKey:@"sum"];
	[eventData setObject:@(self.timestamp) forKey:@"timestamp"];
    [eventData setObject:@(self.eventid) forKey:@"eventid"];
	return eventData;
}

@end


#pragma mark - CountlyEventQueue

@interface CountlyEventQueue : NSObject

@end


@implementation CountlyEventQueue

- (void)dealloc
{
    [super dealloc];
}

- (NSUInteger)count
{
    @synchronized (self)
    {
        return [[CountlyDB sharedInstance] getEventCount];
    }
}


- (NSString *)events
{
    NSMutableArray* result = [NSMutableArray array];
    
	@synchronized (self)
    {
		NSArray* events = [[[[CountlyDB sharedInstance] getEvents] copy] autorelease];
		for (id managedEventObject in events)
        {
			CountlyEvent* event = [CountlyEvent objectWithManagedObject:managedEventObject];
            
			[result addObject:event.serializedData];
            
            [CountlyDB.sharedInstance deleteEvent:managedEventObject];
        }
    }
    
	return CountlyURLEscapedString(CountlyJSONFromObject(result));
}

- (void)recordEvent:(NSString *)key count:(int)count
{
    @synchronized (self)
    {
        /*
        NSArray* events = [[[[CountlyDB sharedInstance] getEvents] copy] autorelease];
        for (NSManagedObject* obj in events)
        {
            CountlyEvent *event = [CountlyEvent objectWithManagedObject:obj];
            if ([event.key isEqualToString:key])
            {
                event.count += count;
                event.timestamp = (event.timestamp + time(NULL)) / 2;
                
                [obj setValue:@(event.count) forKey:@"count"];
                [obj setValue:@(event.timestamp) forKey:@"timestamp"];
                
                [[CountlyDB sharedInstance] saveContext];
                return;
            }
        }
         */
        
        CountlyEvent *event = [[CountlyEvent new] autorelease];
        event.key = key;
        event.count = count;
        event.timestamp = time(NULL);
        [[CountlyDB sharedInstance] createEvent:event.key count:event.count sum:event.sum segmentation:event.segmentation timestamp:event.timestamp];
    }
}

- (void)recordEvent:(NSString *)key count:(int)count sum:(double)sum
{
    @synchronized (self)
    {
        NSArray* events = [[[[CountlyDB sharedInstance] getEvents] copy] autorelease];
        for (NSManagedObject* obj in events)
        {
            CountlyEvent *event = [CountlyEvent objectWithManagedObject:obj];
            if ([event.key isEqualToString:key])
            {
                event.count += count;
                event.sum += sum;
                event.timestamp = (event.timestamp + time(NULL)) / 2;
                
                [obj setValue:@(event.count) forKey:@"count"];
                [obj setValue:@(event.sum) forKey:@"sum"];
                [obj setValue:@(event.timestamp) forKey:@"timestamp"];
                
                [[CountlyDB sharedInstance] saveContext];
                
                return;
            }
        }
        
        CountlyEvent *event = [[CountlyEvent new] autorelease];
        event.key = key;
        event.count = count;
        event.sum = sum;
        event.timestamp = time(NULL);
        
        [[CountlyDB sharedInstance] createEvent:event.key count:event.count sum:event.sum segmentation:event.segmentation timestamp:event.timestamp];
    }
}

- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSInteger)count;
{
    @synchronized (self)
    {
        NSArray* events = [[[[CountlyDB sharedInstance] getEvents] copy] autorelease];
        for (NSManagedObject* obj in events)
        {
            CountlyEvent *event = [CountlyEvent objectWithManagedObject:obj];
            if ([event.key isEqualToString:key] &&
                event.segmentation && [event.segmentation isEqualToDictionary:segmentation])
            {
                event.count += count;
                event.timestamp = (event.timestamp + time(NULL)) / 2;
                
                [obj setValue:@(event.count) forKey:@"count"];
                [obj setValue:@(event.timestamp) forKey:@"timestamp"];
                
                [[CountlyDB sharedInstance] saveContext];
                
                return;
            }
        }
        
        CountlyEvent *event = [[CountlyEvent new] autorelease];
        event.key = key;
        event.segmentation = segmentation;
        event.count = count;
        event.timestamp = time(NULL);
        
        [[CountlyDB sharedInstance] createEvent:event.key count:event.count sum:event.sum segmentation:event.segmentation timestamp:event.timestamp];
    }
}

- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(int)count sum:(double)sum;
{
    @synchronized (self)
    {
        NSArray* events = [[[[CountlyDB sharedInstance] getEvents] copy] autorelease];
        for (NSManagedObject* obj in events)
        {
            CountlyEvent *event = [CountlyEvent objectWithManagedObject:obj];
            if ([event.key isEqualToString:key] &&
                event.segmentation && [event.segmentation isEqualToDictionary:segmentation])
            {
                event.count += count;
                event.sum += sum;
                event.timestamp = (event.timestamp + time(NULL)) / 2;
                
                [obj setValue:@(event.count) forKey:@"count"];
                [obj setValue:@(event.sum) forKey:@"sum"];
                [obj setValue:@(event.timestamp) forKey:@"timestamp"];
                
                [[CountlyDB sharedInstance] saveContext];
                
                return;
            }
        }
        
        CountlyEvent *event = [[CountlyEvent new] autorelease];
        event.key = key;
        event.segmentation = segmentation;
        event.count = count;
        event.sum = sum;
        event.timestamp = time(NULL);
        
        [[CountlyDB sharedInstance] createEvent:event.key count:event.count sum:event.sum segmentation:event.segmentation timestamp:event.timestamp];
    }
}

@end

#pragma mark -
#pragma mark CountlyNSURLConnection
@interface CountlyNSURLConnection : NSURLConnection
@property (nonatomic, retain) NSManagedObjectID *managedObjectID;
@end

@implementation CountlyNSURLConnection
- (void)dealloc
{
    self.managedObjectID = nil;
    [super dealloc];
}
@end


#pragma mark - CountlyConnectionQueue

@interface CountlyConnectionQueue : NSObject

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appHost;
@property (nonatomic, retain) NSMutableArray *connectionList;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;
#endif

+ (instancetype)sharedInstance;

@end


@implementation CountlyConnectionQueue : NSObject

+ (instancetype)sharedInstance
{
    static CountlyConnectionQueue *s_sharedCountlyConnectionQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{s_sharedCountlyConnectionQueue = self.new;});
	return s_sharedCountlyConnectionQueue;
}

- (NSMutableArray *)connectionList
{
    if (_connectionList == nil) {
        _connectionList = [[NSMutableArray alloc] init];
    }
    return _connectionList;
}

- (void) tick
{
    NSArray* dataQueue = [[[[CountlyDB sharedInstance] getQueue] copy] autorelease];
    
    if ([dataQueue count] == 0)
        return;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    if (self.bgTask != UIBackgroundTaskInvalid)
        return;
    
    UIApplication *app = [UIApplication sharedApplication];
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
		[app endBackgroundTask:self.bgTask];
		self.bgTask = UIBackgroundTaskInvalid;
    }];
#endif
    NSManagedObject *managedObject = [dataQueue objectAtIndex:0];
    NSString *data = [managedObject valueForKey:@"post"];
    NSString *urlString = [NSString stringWithFormat:@"%@/mtools/countlyData", self.appHost];
    
//    NSString *urlString = [NSString stringWithFormat:@"%@/i?%@", self.appHost, data];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    CountlyNSURLConnection *connection = [[CountlyNSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    connection.managedObjectID = [managedObject objectID];
    [self.connectionList addObject:connection];
    [connection start];
    COUNTLY_LOG(@"Request Started \n %@", [dataQueue[0] description]);
}

- (void)beginSession
{
	NSString *data = [NSString stringWithFormat:@"app_key=%@&device_id=%@&timestamp=%ld&sdk_version="COUNTLY_VERSION"&begin_session=1&metrics=%@",
					  self.appKey,
					  [CountlyDeviceInfo udid],
					  time(NULL),
					  [CountlyDeviceInfo metrics]];
    
    [[CountlyDB sharedInstance] addToQueue:data];
    
	[self tick];
}

- (void)updateSessionWithDuration:(int)duration
{
	NSString *data = [NSString stringWithFormat:@"app_key=%@&device_id=%@&timestamp=%ld&session_duration=%d",
					  self.appKey,
					  [CountlyDeviceInfo udid],
					  time(NULL),
					  duration];
    
    [[CountlyDB sharedInstance] addToQueue:data];
    
	[self tick];
}

- (void)endSessionWithDuration:(int)duration
{
	NSString *data = [NSString stringWithFormat:@"app_key=%@&device_id=%@&timestamp=%ld&end_session=1&session_duration=%d",
					  self.appKey,
					  [CountlyDeviceInfo udid],
					  time(NULL),
					  duration];
    
    [[CountlyDB sharedInstance] addToQueue:data];
    
	[self tick];
}

- (void)recordEvents:(NSString *)events
{
	NSString *data = [NSString stringWithFormat:@"app_key=%@&device_id=%@&timestamp=%ld&events=%@",
					  self.appKey,
					  [CountlyDeviceInfo udid],
					  time(NULL),
					  events];
    
    [[CountlyDB sharedInstance] addToQueue:data];
	[self tick];
    
    NSLog(@"Countly Send Data:%@",data);
}

- (void)connectionDidFinishLoading:(CountlyNSURLConnection *)connection
{
    NSArray* dataQueue = [[[CountlyDB sharedInstance] getQueue] copy];
    
	COUNTLY_LOG(@"Request Completed\n");
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    UIApplication *app = [UIApplication sharedApplication];
    if (self.bgTask != UIBackgroundTaskInvalid)
    {
        [app endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }
#endif
    __block NSManagedObject *manageObject = nil;
    [dataQueue enumerateObjectsUsingBlock:^(NSManagedObject *obj, NSUInteger idx, BOOL *stop) {
        NSString *objURLStr = [obj.objectID URIRepresentation].absoluteString;
        NSString *urlStr = [connection.managedObjectID URIRepresentation].absoluteString;
        if ([objURLStr isEqualToString:urlStr] && objURLStr) {
            manageObject = obj;
            *stop = YES;
        }
    }];
    if (manageObject) {
        [[CountlyDB sharedInstance] removeFromQueue:manageObject];
    }

    if ([self.connectionList containsObject:connection]) {
        [self.connectionList removeObject:connection];
        connection = nil;
    }
    
    [dataQueue release];
    
    [self tick];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)err
{
    #if COUNTLY_DEBUG
        NSArray* dataQueue = [[[[CountlyDB sharedInstance] getQueue] copy] autorelease];
        COUNTLY_LOG(@"Request Failed \n %@: %@", [dataQueue[0] description], [err description]);
    #endif
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    UIApplication *app = [UIApplication sharedApplication];
    if (self.bgTask != UIBackgroundTaskInvalid)
    {
        [app endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }
#endif
    
    if ([self.connectionList containsObject:connection]) {
        [self.connectionList removeObject:connection];
        connection = nil;
    }
}

#if COUNTLY_IGNORE_INVALID_CERTIFICATES
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
}
#endif

- (void)dealloc
{
    for (CountlyNSURLConnection *connection in self.connectionList) {
        [connection cancel];
    }
    self.connectionList = nil;
	self.appKey = nil;
	self.appHost = nil;

	[super dealloc];
}

@end


#pragma mark - Countly Core

@implementation Countly

+ (instancetype)sharedInstance
{
    static Countly *s_sharedCountly = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{s_sharedCountly = self.new;});
	return s_sharedCountly;
}

- (id)init
{
	if (self = [super init])
	{
		timer = nil;
		isSuspended = NO;
		unsentSessionLength = 0;
        eventQueue = [[CountlyEventQueue alloc] init];

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didEnterBackgroundCallBack:)
													 name:UIApplicationDidEnterBackgroundNotification
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(willEnterForegroundCallBack:)
													 name:UIApplicationWillEnterForegroundNotification
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(willTerminateCallBack:)
													 name:UIApplicationWillTerminateNotification
												   object:nil];
#endif
	}
	return self;
}

- (void)start:(NSString *)appKey withHost:(NSString *)appHost
{
    /* 暂时不实用每隔一段时间发送的策略，修改为每次进入后台和从后台恢复发送
	timer = [NSTimer scheduledTimerWithTimeInterval:COUNTLY_DEFAULT_UPDATE_INTERVAL
											 target:self
										   selector:@selector(onTimer:)
										   userInfo:nil
											repeats:YES];
     */
	lastTime = CFAbsoluteTimeGetCurrent();
    self.appKey = appKey;
    self.appHost = appHost;
	[[CountlyConnectionQueue sharedInstance] setAppKey:appKey];
	[[CountlyConnectionQueue sharedInstance] setAppHost:appHost];
	[[CountlyConnectionQueue sharedInstance] beginSession];
}

- (void)startOnCloudWithAppKey:(NSString *)appKey
{
    [self start:appKey withHost:@"https://cloud.count.ly"];
}

- (void)recordEvent:(NSString *)key count:(int)count
{
    [eventQueue recordEvent:key count:count];
    
    if (eventQueue.count >= COUNTLY_EVENT_SEND_THRESHOLD)
        [[CountlyConnectionQueue sharedInstance] recordEvents:[eventQueue events]];
}

- (void)recordEvent:(NSString *)key count:(int)count sum:(double)sum
{
    [eventQueue recordEvent:key count:count sum:sum];
    
    if (eventQueue.count >= COUNTLY_EVENT_SEND_THRESHOLD)
        [[CountlyConnectionQueue sharedInstance] recordEvents:[eventQueue events]];
}

- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSInteger)count
{
    [eventQueue recordEvent:key segmentation:segmentation count:count];
    
    if (eventQueue.count >= COUNTLY_EVENT_SEND_THRESHOLD)
        [[CountlyConnectionQueue sharedInstance] recordEvents:[eventQueue events]];
}

- (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(int)count sum:(double)sum
{
    [eventQueue recordEvent:key segmentation:segmentation count:count sum:sum];
    
    if (eventQueue.count >= COUNTLY_EVENT_SEND_THRESHOLD)
        [[CountlyConnectionQueue sharedInstance] recordEvents:[eventQueue events]];
}

- (void)onTimer:(NSTimer *)timer
{
	if (isSuspended == YES)
		return;
    
	double currTime = CFAbsoluteTimeGetCurrent();
	unsentSessionLength += currTime - lastTime;
	lastTime = currTime;
    
	int duration = unsentSessionLength;
	[[CountlyConnectionQueue sharedInstance] updateSessionWithDuration:duration];
	unsentSessionLength -= duration;
    
    if (eventQueue.count > 0)
        [[CountlyConnectionQueue sharedInstance] recordEvents:[eventQueue events]];
}

- (void)suspend
{
	isSuspended = YES;
    
    if (eventQueue.count > 0)
        [[CountlyConnectionQueue sharedInstance] recordEvents:[eventQueue events]];
    
	double currTime = CFAbsoluteTimeGetCurrent();
	unsentSessionLength += currTime - lastTime;
    
	int duration = unsentSessionLength;
	[[CountlyConnectionQueue sharedInstance] endSessionWithDuration:duration];
	unsentSessionLength -= duration;
}

- (void)resume
{
	lastTime = CFAbsoluteTimeGetCurrent();
    
	[[CountlyConnectionQueue sharedInstance] beginSession];
    
	isSuspended = NO;
}

- (void)exit
{
}

- (void)dealloc
{
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
    
	if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    [eventQueue release];
    
    self.channelId = nil;
    self.appt = nil;
    self.appKey = nil;
    self.appHost = nil;
	
	[super dealloc];
}

- (void)didEnterBackgroundCallBack:(NSNotification *)notification
{
	COUNTLY_LOG(@"App didEnterBackground");
	[self suspend];
    
    // 进入后台发送数据发送数据
    [self onTimer:nil];
}

- (void)willEnterForegroundCallBack:(NSNotification *)notification
{
	COUNTLY_LOG(@"App willEnterForeground");
	[self resume];
    
    // 从后台恢复发送数据
    [self onTimer:nil];
}

- (void)willTerminateCallBack:(NSNotification *)notification
{
	COUNTLY_LOG(@"App willTerminate");
    [[CountlyDB sharedInstance] saveContext];
	[self exit];
}

#pragma mark -- eventID --
@synthesize eventid = _eventid;

- (NSUInteger)eventid {
    NSNumber *logidNumber = [eLongUserDefault objectForKey:LOG_ID];
    if (!logidNumber) {
        [eLongUserDefault setObject:[NSNumber numberWithUnsignedInteger:0] forKey:LOG_ID];
        _eventid = 0;
    }
    else {
        _eventid = [logidNumber unsignedIntegerValue];
    }
    return _eventid;
}

- (void)setEventid:(NSUInteger)eventid {
    _eventid = eventid;
    [eLongUserDefault setObject:[NSNumber numberWithUnsignedInteger:_eventid] forKey:LOG_ID];
}

@end
