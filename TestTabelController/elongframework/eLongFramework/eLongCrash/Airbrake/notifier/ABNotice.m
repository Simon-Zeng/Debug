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

#import <objc/runtime.h>

#import "ABNotice.h"
#import "ABNotifierFunctions.h"

#import "ABNotifier.h"

#import "eLongAccountManager.h"
#import "eLongCrashRequestModel.h"
#import "NSString+eLongExtension.h"

// library constants
NSString * const ABNotifierOperatingSystemVersionKey    = @"Operating System";
NSString * const ABNotifierApplicationVersionKey        = @" App Version";
NSString * const ABNotifierPlatformNameKey              = @"System Platform";
NSString * const ABNotifierEnvironmentNameKey           = @"System Environment";
NSString * const ABNotifierBundleVersionKey             = @"Bundle Version";
NSString * const ABNotifierExceptionNameKey             = @"Exception Name";
NSString * const ABNotifierExceptionReasonKey           = @"Exception Reason";
NSString * const ABNotifierCallStackKey                 = @"Call Stack";
NSString * const ABNotifierControllerKey                = @"Crash Controller";
NSString * const ABNotifierExecutableKey                = @"Executable";
NSString * const ABNotifierExceptionParametersKey       = @"Exception Parameters";
NSString * const ABNotifierNoticePathExtension          = @"abnotice";
NSString * const ABNotifierExceptionPathExtension       = @"abexception";

const int ABNotifierNoticeVersion         = 5;
const int ABNotifierSignalNoticeType      = 1;
const int ABNotifierExceptionNoticeType   = 2;

@interface ABNotice ()
@property (nonatomic, copy) NSString        *environmentName;
@property (nonatomic, copy) NSString        *bundleVersion;
@property (nonatomic, copy) NSString        *exceptionName;
@property (nonatomic, copy) NSString        *exceptionReason;
@property (nonatomic, copy) NSString        *controller;
@property (nonatomic, copy) NSString        *action;
@property (nonatomic, copy) NSString        *executable;
@property (nonatomic, copy) NSArray         *callStack;
@property (nonatomic, strong) NSNumber      *noticeVersion;
@property (nonatomic, copy) NSDictionary    *environmentInfo;
@property (nonatomic, copy) NSString        *userName;
@property (nonatomic, strong) NSString      *dataPath;

// 增加属性 callStackText
@property (nonatomic, copy) NSString         *callStackText;
@end

@implementation ABNotice

@synthesize noticeVersion = __noticeVersion;
@synthesize environmentName = __environmentName;
@synthesize bundleVersion = __bundleVersion;
@synthesize exceptionName = __exceptionName;
@synthesize exceptionReason = __exceptionReason;
@synthesize controller  = __controller;
@synthesize callStack = __callStack;
@synthesize environmentInfo = __environmentInfo;
@synthesize action = __action;
@synthesize executable = __executable;
@synthesize userName =__userName;

- (id)initWithContentsOfFile:(NSString *)path {
    self = [super init];
    if (self) {
        @try {
            
            // check path
            NSString *extension = [path pathExtension];
            if (![extension isEqualToString:ABNotifierExceptionPathExtension]) {
                [NSException
                 raise:NSInvalidArgumentException
                 format:@"%@ is not a valid notice", path];
            }
            
            // setup
            NSData *data = [NSData dataWithContentsOfFile:path];
            self.dataPath = path;
            NSData *subdata = nil;
            NSDictionary *dictionary = nil;
            unsigned long location = 0;
            unsigned long length = 0;
            
            // get version
            int version;
            [data getBytes:&version range:NSMakeRange(location, sizeof(int))];
            location += sizeof(int);
            if (version < 5) {
                [NSException
                 raise:NSInternalInconsistencyException
                 format:@"The notice at %@ is not compatible with this version of the notifier", path];
            }
            self.noticeVersion = [NSNumber numberWithInt:version];
            
            // get type
            int type;
            [data getBytes:&type range:NSMakeRange(location, sizeof(int))];
            location += sizeof(int);
            
            // get notice payload
            [data getBytes:&length range:NSMakeRange(location, sizeof(unsigned long))];
            location += sizeof(unsigned long);
            subdata = [data subdataWithRange:NSMakeRange(location, length)];
            location += length;
            dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:subdata];
            self.environmentName = [dictionary objectForKey:ABNotifierEnvironmentNameKey];
            self.bundleVersion = [dictionary objectForKey:ABNotifierBundleVersionKey];
            self.executable = [dictionary objectForKey:ABNotifierExecutableKey];
            
            // get user data
            [data getBytes:&length range:NSMakeRange(location, sizeof(unsigned long))];
            location += sizeof(unsigned long);
            subdata = [data subdataWithRange:NSMakeRange(location, length)];
            location += length;
            self.environmentInfo = [NSKeyedUnarchiver unarchiveObjectWithData:subdata];
            
            // signal notice
            if (type == ABNotifierSignalNoticeType) {
                
                // signal
                int signal;
                [data getBytes:&signal range:NSMakeRange(location, sizeof(int))];
                location += sizeof(int);
                
                // exception name
                self.exceptionName = [NSString stringWithUTF8String:strsignal(signal)];
                self.exceptionReason = @"Application recieved signal";
                self.controller = [self.environmentInfo objectForKey:ABNotifierControllerKey];

                // call stack
                length = [data length] - location;
                char *string = malloc(length + 1);
                const char *bytes = [data bytes];
                for (unsigned long i = 0; location < [data length]; location++) {
                    if (bytes[location] != '\0') {
                        string[i++] = bytes[location];
                    }
                }
                NSArray *lines = [[NSString stringWithUTF8String:string] componentsSeparatedByString:@"\n"];
                NSPredicate *lengthPredicate = [NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
                    return ([object length] > 0);
                }];
                self.callStack = [lines filteredArrayUsingPredicate:lengthPredicate];
                free(string);
                
            }
            
            // exception notice
            else if (type == ABNotifierExceptionNoticeType) {
                
                // exception payload
                [data getBytes:&length range:NSMakeRange(location, sizeof(unsigned long))];
                location += sizeof(unsigned long);
                subdata = [data subdataWithRange:NSMakeRange(location, length)];
                dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:subdata];
                self.exceptionName = [dictionary objectForKey:ABNotifierExceptionNameKey];
                self.exceptionReason = [dictionary objectForKey:ABNotifierExceptionReasonKey];
                self.callStack = [dictionary objectForKey:ABNotifierCallStackKey];
               
                //增加赋值
                [self setCallStackText:[dictionary description]];
                
                self.controller = [dictionary objectForKey:ABNotifierControllerKey];
                NSMutableDictionary * mutableInfo = [self.environmentInfo mutableCopy];
                [mutableInfo addEntriesFromDictionary:[dictionary objectForKey:ABNotifierExceptionParametersKey]];
                self.environmentInfo = mutableInfo;
                
            }
            
            // finish up call stack stuff
            self.callStack = ABNotifierParseCallStack(self.callStack);
            self.action = ABNotifierActionFromParsedCallStack(self.callStack, self.executable);
            if (type == ABNotifierSignalNoticeType && self.action != nil) {
                self.exceptionReason = self.action;
            }
            
        }
        @catch (NSException *exception) {
            ABLog(@"%@", exception);
            return nil;
        }
    }
    return self;
}
+ (ABNotice *)noticeWithContentsOfFile:(NSString *)path {
    return [[ABNotice alloc] initWithContentsOfFile:path];
}

- (void)setPOSTUserName:(NSString *)theUserName
{
    if (theUserName) {
        self.userName = theUserName;
    }
}

- (NSData *)JSONString {
    NSData *jsonData;
    NSError *jsonSerializationError = nil;
    NSDictionary *dictionary = [self getNoticeDictionary];
    if (!dictionary) {
        jsonData = nil;
        ABLog(@"ERROR: JSONString has empty notice dictionary.");
        return jsonData;
    }
    jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    if(jsonSerializationError) {
        jsonData = nil;
        ABLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    return jsonData;
}

- (NSDictionary *)JSONDic {
    
    //获取params字典
    NSDictionary * dictionary = [self getSpecificNoticDictionary];
    
    //调整格式
    NSString * finalJsonString = [self adjustFormatOfDic:dictionary];
    
    NSData * jsonData = [finalJsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dic =  [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    return dic;
}
 
#pragma mark -- eLongSpecificNoticeDictionary -- start
- (NSDictionary *)getSpecificNoticDictionary {//构造noticeDictionary,转换成data后作为后续请求服务器的body
    eLongCrashRequestModel * crashReqModel = [[eLongCrashRequestModel alloc]init];
    crashReqModel.pageName =self.controller;
    
    NSString *message = [NSString stringWithFormat:@"%@: %@", self.exceptionName, self.exceptionReason];
    crashReqModel.exceptionName = message;
    crashReqModel.exceptionType = 0;
    
    //设置crashModel的异常堆栈详细信息
    if ([_callStackText empty]) { // crash详细信息
        // 获取异常信息描述
        NSString *stackText = [self.callStack description];
        if ([stackText notEmpty]) {
            [self setCallStackText:stackText];
        }
    }
    NSString *modifyString = [_callStackText stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    modifyString = [modifyString stringByReplacingOccurrencesOfString:@"\%" withString:@""];
    if (!modifyString) {
        modifyString = @"";
    }
    NSMutableString *callstack = [NSMutableString string];
    [callstack appendString:modifyString];
    // 代替空格缩进
    NSString *modifyCallStack = [callstack stringByReplacingOccurrencesOfString:@" " withString:@"."];
    crashReqModel.exceptionsStackDetail = modifyCallStack;
    crashReqModel.appVersion = self.bundleVersion;
    crashReqModel.osVersion = [self.environmentInfo objectForKey:@"Operating System"];
    crashReqModel.deviceModel = [self.environmentInfo objectForKey:@"System Platform"];
    crashReqModel.netWorkType = 3;
    crashReqModel.deviceStatus = [NSString stringWithFormat:@"CPU:%@;%@", [self.environmentInfo objectForKey:@"CPU Information"], [self.environmentInfo objectForKey:@"Memory Information"]];
    crashReqModel.channelId = [ABNotifier shared].channelID;
    crashReqModel.clientType = [[ABNotifier shared].appType integerValue];
    crashReqModel.netWorkCarrier = @"";
    crashReqModel.crashTime = [self.environmentInfo objectForKey:@"Error Occured Time"];
    crashReqModel.appName = @"";
    crashReqModel.eLongAccount = @"";
    
    // 添加手机号
    NSString * phoneNumber = [[eLongAccountManager userInstance] phoneNo];
    if([phoneNumber empty]){
        phoneNumber = @"user didnot login!";
    }
    crashReqModel.phoneNumber = phoneNumber;
    crashReqModel.deviceId = @"";
    
    if([ABNotifier shared].debugSwitch) {//记录crash到本地
        [self beginCrash:crashReqModel];
        [[eLongDebugManager crashInstance] endCrash];
    }
    
    NSDictionary * params = [crashReqModel requestParams];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:params forKey:@"AppCrashDetail"];
    
    return dictionary;
}

- (NSString *)adjustFormatOfDic:(NSDictionary *)dictionary{ //调整jsonString格式
    
    NSError *jsonSerializationError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //添加换行
    NSString * modifyJsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\n" withString:@"<br />"];
    
    return  modifyJsonString;
}

- (void)beginCrash:(eLongCrashRequestModel *)model {
    eLongDebugCrashModel *crashModel = [[eLongDebugManager crashInstance] beginCrash];
    crashModel.page = model.pageName;
    crashModel.name = model.exceptionName;
    crashModel.version = model.appVersion;
    crashModel.osversion = model.osVersion;
    crashModel.device = model.deviceModel;
    crashModel.network = [NSString stringWithFormat:@"%ld",(long)model.netWorkType];
    crashModel.channel = model.channelId;
    
    //crash时间
    NSDateFormatter *crashDateFormatter = [[NSDateFormatter alloc] init];
    [crashDateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *crashDate= [crashDateFormatter dateFromString:model.crashTime];
    //加上差的八小时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:crashDate];
    crashDate = [crashDate dateByAddingTimeInterval:interval];
    crashModel.date = crashDate;
    
    crashModel.mark = model.deviceStatus;
    crashModel.stack = model.exceptionsStackDetail;
}
//---end ---

-(NSDictionary *)getNoticeDictionary
{
    NSMutableArray *backtrace = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSArray *item in self.callStack) {
        if ([item count]&& [item count]>4) {
            [backtrace addObject:@{@"line":@([item[1] intValue]),@"file":item[2],@"function":item[3]}];
        } else {
            //if we can't format the backtrace to the format matching with server API, return nil instead.  
            return nil;
        }
    }
    NSDictionary *notice = @{@"notifier": @{@"name":self.executable, @"version":ABNotifierApplicationVersion(), @"url":self.executable},@"errors":@[@{@"type":self.exceptionName,@"message":self.exceptionReason, @"backtrace":backtrace}], @"context":@{@"os": ABNotifierOperatingSystemVersion(),@"language":ABNotifierPlatformName(), @"environment":self.environmentName,@"version":ABNotifierApplicationVersion(),@"userName":self.userName},@"environment":@{@"name": self.environmentName},@"params":self.environmentInfo};
    return notice;
}

- (NSDictionary *)getDictionaryFromProperty
{
    unsigned int count;
	objc_property_t *properties = class_copyPropertyList([self class], &count);
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:count];
	for (unsigned int i = 0; i < count; i++) {
		NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
		NSString *value = [self valueForKey:name];
        if (value) { [dictionary setObject:value forKey:name]; }
        else { [dictionary setObject:[NSNull null] forKey:name]; }
	}
	free(properties);
    return dictionary;
}

- (NSString *)description {
	NSDictionary *dictionary = [self getDictionaryFromProperty];
    return [NSString stringWithFormat:@"%@ %@", [super description], [dictionary description]];  
}

@end
