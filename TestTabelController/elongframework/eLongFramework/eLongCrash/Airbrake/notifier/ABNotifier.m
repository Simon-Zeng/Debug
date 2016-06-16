/*
 
 Copyright (C) 2011 GUI Cocoa, LLC.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */



#import "ABNotifier.h"
#import "ABCrashReport.h"
#import "ABNotice.h"
#import "ABNotifierFunctions.h"
#import <unistd.h>
#import "eLongAccountManager.h"
#import "UIDevice+Hardware.h"
#import "eLongNetworking.h"
#import "NSString+eLongExtension.h"
#import "eLongServices.h"

// internal
static SCNetworkReachabilityRef __reachability = nil;
static id<ABNotifierDelegate> __delegate = nil;
static NSMutableDictionary *__userData;
static NSString * __APIKey = nil;
static BOOL __useSSL = NO;
static BOOL __displayPrompt = YES;
static NSString *__userName = @"Anonymous";
static NSString *__envName = nil;
// constant strings
static NSString * const ABNotifierHostName                  = @"www.baidu.com";
static NSString * const ABNotifierAlwaysSendKey             = @"AlwaysSendCrashReports";
NSString * const ABNotifierWillDisplayAlertNotification     = @"ABNotifierWillDisplayAlert";
NSString * const ABNotifierDidDismissAlertNotification      = @"ABNotifierDidDismissAlert";
NSString * const ABNotifierWillPostNoticesNotification      = @"ABNotifierWillPostNotices";
NSString * const ABNotifierDidPostNoticesNotification       = @"ABNotifierDidPostNotices";
NSString * const ABNotifierVersion                          = @"4.1";
NSString * const ABNotifierDevelopmentEnvironment           = @"Development";
NSString * const ABNotifierAdHocEnvironment                 = @"Ad Hoc";
NSString * const ABNotifierAppStoreEnvironment              = @"App Store";
NSString * const ABNotifierReleaseEnvironment               = @"Release";
#if defined (DEBUG) || defined (DEVELOPMENT)
NSString * const ABNotifierAutomaticEnvironment             = @"Development";
#elif defined (TEST) || defined (TESTING)
NSString * const ABNotifierAutomaticEnvironment             = @"Test";
#else
NSString * const ABNotifierAutomaticEnvironment             = @"Production";
#endif

// reachability callback
void ABNotifierReachabilityDidChange(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info);

@interface ABNotifier ()

// get the path where notices are stored
+ (NSString *)pathForNoticesDirectory;

// get the path for a new notice given the file name
+ (NSString *)pathForNewNoticeWithName:(NSString *)name;

// get the paths for all valid notices
+ (NSArray *)pathsForAllNotices;

// post all provided notices to airbrake
+ (void)postNoticesWithPaths:(NSArray *)paths;

// post the given notice to server
+ (void)postNoticeWithContentsOfFile:(NSString *)path;

// caches user data to store that can be read at signal time
+ (void)cacheUserDataDictionary;

// pop a notice alert and perform necessary actions
+ (void)showNoticeAlertForNoticesWithPaths:(NSArray *)paths;

// determine if we are reachable with given flags
+ (BOOL)isReachable:(SCNetworkReachabilityFlags)flags;

@end

@implementation ABNotifier
static ABNotifier * sharedInstance = nil;
static dispatch_once_t predicate;

+ (ABNotifier *)shared {
    dispatch_once(&predicate, ^{
        sharedInstance = [[ABNotifier alloc] init];
    });
    return sharedInstance;
}


#pragma mark - initialize the notifier
+ (void)startNotifierWithAPIKey:(NSString *)key environmentName:(NSString *)name useSSL:(BOOL)useSSL delegate:(id<ABNotifierDelegate>)delegate {
    [self startNotifierWithAPIKey:key environmentName:name userName:__userName useSSL:useSSL delegate:delegate installExceptionHandler:YES installSignalHandler:YES displayUserPrompt:YES];
}
+ (void)startNotifierWithAPIKey:(NSString *)key environmentName:(NSString *)name useSSL:(BOOL)useSSL delegate:(id<ABNotifierDelegate>)delegate installExceptionHandler:(BOOL)exception installSignalHandler:(BOOL)signal {
    [self startNotifierWithAPIKey:key environmentName:name userName:__userName useSSL:useSSL delegate:delegate installExceptionHandler:exception installSignalHandler:signal displayUserPrompt:YES];
}

+ (void)startNotifierWithAPIKey:(NSString *)key
                environmentName:(NSString *)name
                       userName:(NSString *)username
                         useSSL:(BOOL)useSSL
                       delegate:(id<ABNotifierDelegate>)delegate {
    [self startNotifierWithAPIKey:key
                  environmentName:name
                         userName:username
                           useSSL:useSSL
                         delegate:delegate
          installExceptionHandler:YES
             installSignalHandler:YES
                displayUserPrompt:YES];
}


+ (void)startNotifierWithAPIKey:(NSString *)key
                environmentName:(NSString *)name
                       userName:(NSString *)username
                         useSSL:(BOOL)useSSL
                       delegate:(id<ABNotifierDelegate>)delegate
        installExceptionHandler:(BOOL)exception
           installSignalHandler:(BOOL)signal
              displayUserPrompt:(BOOL)display {
    @synchronized(self) {
        static BOOL token = YES;
        if (token) {
            // store username
            __userName = username;
            
            // change token5
            token = NO;
            
            // register defaults,修改设为总是发送错误报告（YES），原代码中设置本来为（NO）
            [[NSUserDefaults standardUserDefaults] registerDefaults:
             [NSDictionary dictionaryWithObject:@"YES" forKey:ABNotifierAlwaysSendKey]];
            
            // capture vars
            __userData = [[NSMutableDictionary alloc] init];
            __delegate = delegate;
            __useSSL = useSSL;
            __displayPrompt = display;
            
            // start crashreport
            [[ABCrashReport sharedInstance] startCrashReport];
            // switch on api key
            if ([key length]) {
                __APIKey = [key copy];
                __reachability = SCNetworkReachabilityCreateWithName(NULL, [ABNotifierHostName UTF8String]);
                if (SCNetworkReachabilitySetCallback(__reachability, ABNotifierReachabilityDidChange, nil)) {
                    if (!SCNetworkReachabilityScheduleWithRunLoop(__reachability, CFRunLoopGetMain(), kCFRunLoopDefaultMode)) {
                        ABLog(@"Reachability could not be configired. No notices will be posted.");
                    }
                }
            }
            else {
                ABLog(@"The API key must not be blank. No notices will be posted.");
            }
            
            // switch on environment name
            if ([name length]) {
                
                __envName = name;
                // vars
                unsigned long length;
                
                // cache signal notice file path
                NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
                
                const char *filePath = [[ABNotifier pathForNewExceptionWithName:fileName] UTF8String];
                
                length = (strlen(filePath) + 1);
                ab_signal_info.notice_path = malloc(length);
                memcpy((void *)ab_signal_info.notice_path, filePath, length);
                
                // cache notice payload

                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 name, ABNotifierEnvironmentNameKey,
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                 ABNotifierBundleVersionKey,
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"],
                                 ABNotifierExecutableKey,
                                 nil]];
                length = [data length];
                ab_signal_info.notice_payload = malloc(length);
                memcpy(ab_signal_info.notice_payload, [data bytes], length);
                ab_signal_info.notice_payload_length = length;
                
                // cache user data
                [self addEnvironmentEntriesFromDictionary:
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  ABNotifierPlatformName(), ABNotifierPlatformNameKey,
                  ABNotifierOperatingSystemVersion(), ABNotifierOperatingSystemVersionKey,
                  ABNotifierApplicationVersion(), ABNotifierApplicationVersionKey,
                  nil]];
                
                //only use the exception for custom exception log
                if (exception) {
                    ABNotifierStartExceptionHandler();
                }
                if (signal) {
                    ABNotifierStartSignalHandler();
                }
                
                // log
                ABLog(@"Notifier %@ ready to catch errors", ABNotifierVersion);
                ABLog(@"Environment \"%@\"", name);
            }
            else {
                ABLog(@"The environment name must not be blank. No new notices will be logged");
            }
            
        }
    }
}

#pragma mark - accessors
+ (id<ABNotifierDelegate>)delegate {
    @synchronized(self) {
        return __delegate;
    }
}
+ (NSString *)APIKey {
    @synchronized(self) {
        return __APIKey;
    }
}

#pragma mark - write data
+ (void)logException:(NSException *)exception parameters:(NSDictionary *)parameters {
    
    // force all activity onto main thread
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self logException:exception parameters:parameters];
        });
        return;
    }
    
    // get file handle
    NSString *name = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path = [self pathForNewExceptionWithName:name];
    int fd = ABNotifierOpenNewNoticeFile([path UTF8String], ABNotifierExceptionNoticeType);
    
    // write stuff
    if (fd > -1) {
        @try {
            
            // create parameters
            NSMutableDictionary *exceptionParameters = [NSMutableDictionary dictionary];
            if ([parameters count]) { [exceptionParameters addEntriesFromDictionary:parameters]; }
            [exceptionParameters setValue:ABNotifierResidentMemoryUsage() forKey:@"Resident Memory Size"];
            [exceptionParameters setValue:ABNotifierVirtualMemoryUsage() forKey:@"Virtual Memory Size"];
            
            [self setExceptionParameters:exceptionParameters];

            // write exception
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [exception name], ABNotifierExceptionNameKey,
                                        [exception reason], ABNotifierExceptionReasonKey,
                                        [exception callStackSymbols], ABNotifierCallStackKey,
                                        exceptionParameters, ABNotifierExceptionParametersKey,
#if TARGET_OS_IPHONE
                                        ABNotifierCurrentViewController(), ABNotifierControllerKey,
#endif
                                        nil];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
            unsigned long length = [data length];
            write(fd, &length, sizeof(unsigned long));
            write(fd, [data bytes], length);
            
            // delegate
            id<ABNotifierDelegate> delegate = [self delegate];
            if ([delegate respondsToSelector:@selector(notifierDidLogException:)]) {
                [delegate notifierDidLogException:exception];
            }
            
        }
        @catch (NSException *exception) {
            ABLog(@"Exception encountered while logging exception");
            ABLog(@"%@", exception);
        }
        @finally {
            close(fd);
        }
    }
    
}
+ (void)logException:(NSException *)exception {
    [self logException:exception parameters:nil];
}
+ (void)writeTestNotice {
    @try {
        NSArray *array = [NSArray array];
        [array objectAtIndex:NSUIntegerMax];
    }
    @catch (NSException *e) {
        [self logException:e];
    }
}

#pragma mark -- 设置其他异常属性 --
+ (void)setExceptionParameters:(NSMutableDictionary *)exceptionParameters {
    
    //添加手机号
    NSString *phoneNumber = [[eLongAccountManager userInstance] phoneNo];
    if([phoneNumber empty]){
        phoneNumber = @"user didnot login!";
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    
    [exceptionParameters setValue:dateStr forKey:@"Error Occured Time"];
    [exceptionParameters setValue:phoneNumber forKey:@"TelePhone"];
    
    [exceptionParameters setValue:[ABNotifier shared].macAddress forKey:@"macAddress"];
    
    // 实时更新资源使用情况
    UIDevice *device = [UIDevice currentDevice];
    NSArray *usage = [device cpuUsage];
    NSMutableString *usageStr = [NSMutableString stringWithFormat:@""];
    
    for (NSNumber *u in usage) {
        [usageStr appendString:[NSString stringWithFormat:@"%.1f%% ", [u floatValue]]];
    }
    
    NSString *memoryInfo = [NSString stringWithFormat:@"%.1f / %luM", [device freeMemoryBytes] / 1024.0 / 1024.0, [device totalMemoryBytes] / 1024 / 1024];
    NSString *diskInfo = [NSString stringWithFormat:@"%llu / %lluG", [device freeDiskSpaceBytes] / (1024*1024*1024),[device totalDiskSpaceBytes] / (1024*1024*1024)];
    [exceptionParameters setValue:usageStr forKey:@"CPU Information"];
    [exceptionParameters setValue:memoryInfo forKey:@"Memory Information"];
    [exceptionParameters setValue:diskInfo forKey:@"Disk Information"];
}

#pragma mark - environment variables
+ (void)setEnvironmentValue:(NSString *)value forKey:(NSString *)key {
    @synchronized(self) {
        [__userData setObject:value forKey:key];
        [ABNotifier cacheUserDataDictionary];
    }
}
+ (void)addEnvironmentEntriesFromDictionary:(NSDictionary *)dictionary {
    @synchronized(self) {
        [__userData addEntriesFromDictionary:dictionary];
        [ABNotifier cacheUserDataDictionary];
    }
}
+ (NSString *)environmentValueForKey:(NSString *)key {
    @synchronized(self) {
        return [__userData objectForKey:key];
    }
}
+ (void)removeEnvironmentValueForKey:(NSString *)key {
    @synchronized(self) {
        [__userData removeObjectForKey:key];
        [ABNotifier cacheUserDataDictionary];
    }
}
+ (void)removeEnvironmentValuesForKeys:(NSArray *)keys {
    @synchronized(self) {
        [__userData removeObjectsForKeys:keys];
        [ABNotifier cacheUserDataDictionary];
    }
}

#pragma mark - file utilities
+ (NSString *)pathForNoticesDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
#if TARGET_OS_IPHONE
        NSArray *folders = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        path = [folders objectAtIndex:0];
        if ([folders count] == 0) {
            path = NSTemporaryDirectory();
        }
        else {
            path = [path stringByAppendingPathComponent:@"AB Notices"];
        }
#else
        NSArray *folders = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        path = [folders objectAtIndex:0];
        if ([folders count] == 0) {
            path = NSTemporaryDirectory();
        }
        else {
            path = [path stringByAppendingPathComponent:ABNotifierApplicationName()];
            path = [path stringByAppendingPathComponent:@"AB Notices"];
        }
#endif
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            [manager
             createDirectoryAtPath:path
             withIntermediateDirectories:YES
             attributes:nil
             error:nil];
        }
    });
    return path;
}
+ (NSString *)pathForNewNoticeWithName:(NSString *)name {
    NSString *path = [self pathForNoticesDirectory];
    path = [path stringByAppendingPathComponent:name];
    return [path stringByAppendingPathExtension:ABNotifierNoticePathExtension];
}

+ (NSString *)pathForNewExceptionWithName:(NSString *)name {
    NSString *path = [self pathForNoticesDirectory];
    path = [path stringByAppendingPathComponent:name];
    return [path stringByAppendingPathExtension:ABNotifierExceptionPathExtension];
}

+ (NSArray *)pathsForAllNotices {
    NSString *path = [self pathForNoticesDirectory];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *paths = [NSMutableArray arrayWithCapacity:[contents count]];
    [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj pathExtension] isEqualToString:ABNotifierNoticePathExtension]) {
            NSString *noticePath = [path stringByAppendingPathComponent:obj];
            [paths addObject:noticePath];
        } else if ([[obj pathExtension] isEqualToString:ABNotifierExceptionPathExtension]) {
            NSString *noticePath = [path stringByAppendingPathComponent:obj];
            [paths addObject:noticePath];
        }
    }];
    return paths;
}

#pragma mark - post notices
+ (void)postNoticesWithPaths:(NSArray *)paths {
    
    // assert
    NSAssert(![NSThread isMainThread], @"This method must not be called on the main thread");
    NSAssert([paths count], @"No paths were provided");
    
    // get variables
    if ([paths count] == 0) { return; }
    id<ABNotifierDelegate> delegate = [ABNotifier delegate];
    
    // notify people 通知消息将被发送
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([delegate respondsToSelector:@selector(notifierWillPostNotices)]) {
            [delegate notifierWillPostNotices];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ABNotifierWillPostNoticesNotification object:self];
    });
    
    
#if TARGET_OS_IPHONE
    
    // start background task
    __block BOOL keepPosting = YES;
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier task = [app beginBackgroundTaskWithExpirationHandler:^{
        keepPosting = NO;
    }];
    
    // report each notice
    [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (keepPosting) { [self postNoticeWithContentsOfFile:obj]; }
        else { *stop = YES; }
    }];
    
    // end background task
    if (task != UIBackgroundTaskInvalid) {
        [app endBackgroundTask:task];
    }
    
#else
    
    // report each notice
    [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self postNoticeWithContentsOfFile:obj];
    }];
    
#endif
    
    // notify people 通知消息发送完成
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([delegate respondsToSelector:@selector(notifierDidPostNotices)]) {
            [delegate notifierDidPostNotices];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ABNotifierDidPostNoticesNotification object:self];
    });
	
}

+ (NSData *)JSONString:(NSString *)filePath {
    NSData *jsonData;
    NSError *error = NULL;
    NSError *jsonSerializationError = nil;
    NSString *dataStr = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (!dataStr) {
        jsonData = nil;
        ABLog(@"ERROR: Crash report data is not readable.");
        return jsonData;
    }
    NSDictionary *notice = @{@"report": dataStr, @"context":@{@"userName":__userName, @"environment":__envName}};
    jsonData = [NSJSONSerialization dataWithJSONObject:notice options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    if(jsonSerializationError) {
        jsonData = nil;
        ABLog(@"ERROR: JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    return jsonData;
}

+ (void)postNoticeWithContentsOfFile:(NSString *)path {
    ABNotice *notice = [ABNotice noticeWithContentsOfFile:path];
    [notice setPOSTUserName:__userName];
    NSDictionary * params = [notice JSONDic];
    if(params){
        NSURLRequest *crashReq = [[eLongNetworkRequest sharedInstance] javaRequest:@"hotel/saveCrash" params:params method:eLongNetworkRequestMethodPOST encoding:eLongNetworkEncodingGNUZip];
        
        [eLongHTTPRequest startRequest:crashReq success:^(eLongHTTPRequestOperation *operation, id responseObject) {
            
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            
        } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
    }else{
    
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    //如果debugSwtich打开，自动上传crash到禅道
    if([ABNotifier shared].debugSwitch) {
        //调服务
        [eLongServices callService:@"eLongBugManagerCrashCommit",params,nil];
    }
}

#pragma mark - cache methods
+ (void)cacheUserDataDictionary {
    @synchronized(self) {
        
        // free old cached value
        free(ab_signal_info.user_data);
        ab_signal_info.user_data_length = 0;
        ab_signal_info.user_data = nil;
        
        // cache new value
        if (__userData) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:__userData];
            unsigned long length = [data length];
            ab_signal_info.user_data = malloc(length);
            [data getBytes:ab_signal_info.user_data length:length];
            ab_signal_info.user_data_length = length;
        }
        
    }
}

#pragma mark - user interface
+ (void)showNoticeAlertForNoticesWithPaths:(NSArray *)paths {
    
    // assert
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread");
    NSAssert([paths count], @"No paths were provided");
    
    // get delegate
    id<ABNotifierDelegate> delegate = [self delegate];
    
    // alert title
    NSString *title = nil;
    if ([delegate respondsToSelector:@selector(titleForNoticeAlert)]) {
        title = [delegate titleForNoticeAlert];
    }
    if (title == nil) {
        title = ABLocalizedString(@"NOTICE_TITLE");
    }
    
    // alert body
    NSString *body = nil;
    if ([delegate respondsToSelector:@selector(bodyForNoticeAlert)]) {
        body = [delegate bodyForNoticeAlert];
    }
    if (body == nil) {
        body = [NSString stringWithFormat:ABLocalizedString(@"NOTICE_BODY"), ABNotifierApplicationName()];
    }
    
//    // declare blocks
//    void (^delegateDismissBlock) (void) = ^{
//        if ([delegate respondsToSelector:@selector(notifierDidDismissAlert)]) {
//            [delegate notifierDidDismissAlert];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:ABNotifierDidDismissAlertNotification object:self];
//    };
//    void (^delegatePresentBlock) (void) = ^{
//        if ([delegate respondsToSelector:@selector(notifierWillDisplayAlert)]) {
//            [delegate notifierWillDisplayAlert];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:ABNotifierWillDisplayAlertNotification object:self];
//    };
//    void (^postNoticesBlock) (void) = ^{
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self postNoticesWithPaths:paths];
//        });
//    };
//    void (^deleteNoticesBlock) (void) = ^{
//        NSFileManager *manager = [NSFileManager defaultManager];
//        [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [manager removeItemAtPath:obj error:nil];
//        }];
//    };
//    void (^setDefaultsBlock) (void) = ^{
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setBool:YES forKey:ABNotifierAlwaysSendKey];
//        [defaults synchronize];
//    };
    
#if TARGET_OS_IPHONE
    
//    GCAlertView *alert = [[GCAlertView alloc] initWithTitle:title message:body];
//    [alert addButtonWithTitle:ABLocalizedString(@"ALWAYS_SEND") block:^{
//        setDefaultsBlock();
//        postNoticesBlock();
//    }];
//    [alert addButtonWithTitle:ABLocalizedString(@"SEND") block:postNoticesBlock];
//    [alert addButtonWithTitle:ABLocalizedString(@"DONT_SEND") block:deleteNoticesBlock];
//    [alert setDidDismissBlock:delegateDismissBlock];
//    [alert setDidDismissBlock:delegatePresentBlock];
//    [alert setCancelButtonIndex:2];
//    [alert show];
    
#else
    
    // delegate
    delegatePresentBlock();
    
    // build alert
	NSAlert *alert = [NSAlert
                      alertWithMessageText:title
                      defaultButton:ABLocalizedString(@"ALWAYS_SEND")
                      alternateButton:ABLocalizedString(@"DONT_SEND")
                      otherButton:ABLocalizedString(@"SEND")
                      informativeTextWithFormat:body];
    
    // run alert
	NSInteger code = [alert runModal];
    
    // don't send
    if (code == NSAlertAlternateReturn) {
        deleteNoticesBlock();
    }
    
    // send
    else {
        if (code == NSAlertDefaultReturn) {
            setDefaultsBlock();
        }
        postNoticesBlock();
    }
    
    // delegate
	delegateDismissBlock();
    
#endif
    
}

#pragma mark - reachability
+ (BOOL)isReachable:(SCNetworkReachabilityFlags)flags {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return NO;
    }
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        return YES;
    }
    if (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
        ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            return YES;
        }
    }
    return NO;
}

@end

#pragma mark - reachability change
void ABNotifierReachabilityDidChange(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    if ([ABNotifier isReachable:flags]) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            NSArray *paths = [ABNotifier pathsForAllNotices];
            if ([paths count]) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:ABNotifierAlwaysSendKey] ||
                    !__displayPrompt) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [ABNotifier postNoticesWithPaths:paths];
                    });
                }
                else {
                    [ABNotifier showNoticeAlertForNoticesWithPaths:paths];
                }
            }
        });
    }
}
