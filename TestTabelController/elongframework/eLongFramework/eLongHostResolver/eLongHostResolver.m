//
//  eLongHostResolver.m
//  ElongClient
//
//  Created by Harry Zhao on 7/30/15.
//  Copyright (c) 2015 elong. All rights reserved.
//

#import "eLongHostResolver.h"
#import "eLongExtension.h"

@interface eLongHostResolver () <QCFHostResolverDelegate>

@property (nonatomic, assign, readwrite) NSUInteger runningResolverCount;

@property (nonatomic, strong) NSDictionary *validHosts;

@end

@implementation eLongHostResolver

+ (instancetype)sharedInstance
{
    static eLongHostResolver *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[eLongHostResolver alloc] init];
    });
    return singleton;
}

-(id)init{
    self = [super init];
    if (self) {
        self->_resolvers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(NSString *)validateDNS:(NSString *)host{
    if ([host isNotEmpty]) {
        QCFHostResolver *resolver = [self.resolvers objectForKey:host];
        NSArray *validIpAddress = [self.validHosts objectForKey:host];

        if (resolver != nil) {
            if (validIpAddress.count > 0) {
                
                BOOL result;
                
                if (resolver.resolvedAddressStrings.count>0) {
                    for (NSString *validIp in validIpAddress) {
                        for (NSString *ip in resolver.resolvedAddressStrings) {
                            if ([ip isEqualToString:validIp]) {
                                // 解析的IP在合法列表中
                                result = YES;
                                break;
                            } else {
                                result = NO;
                            }
                        }
                    }
                    
                    if (!result) {
                        // 解析结果不合法，从合法列表中读取
                        // TODO:按优先级检查合法列表里地址的可用性
//                        for (NSString *validIp in validIpAddress) {
//                            
//                        }
                        
                        return [validIpAddress firstObject];
                    }
                }
            }
        }
    }
    
    return host;
}

-(NSDictionary *)validHosts{
    if (_validHosts == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"server_ip" ofType:@"plist"];
        _validHosts = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    
    return _validHosts;
}

-(void)addHost:(NSString *)host{
    if ([host isNotEmpty]) {
        if ([self->_resolvers objectForKey:host]) {
            return;
        }
        
        QCFHostResolver *resolver = [[QCFHostResolver alloc] initWithName:host];
        [self->_resolvers setObject:resolver forKey:host];
    }
}

-(void)addIPAdress:(NSString *)ip{
    if ([ip isNotEmpty]) {
        if ([self->_resolvers objectForKey:ip]) {
            return;
        }
        
        QCFHostResolver *resolver = [[QCFHostResolver alloc] initWithAddressString:ip];
        [self->_resolvers setObject:resolver forKey:ip];
    }
}

- (void)run
{
    self.runningResolverCount = [self.resolvers count];
    
    // Start each of the resolvers.

    for (QCFHostResolver * resolver in self.resolvers.allValues) {
        resolver.delegate = self;
        [resolver start];
    }
    
    // Run the run loop until they are all done.
    
    while (self.runningResolverCount != 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
}

- (void)hostResolverDidFinish:(QCFHostResolver *)resolver
// A resolver delegate callback, called when the resolve completes successfully.
// Prints the results.
{
    NSString *      argument;
    NSString *      result;
    
    if (resolver.name != nil) {
        argument = resolver.name;
        result   = [resolver.resolvedAddressStrings componentsJoinedByString:@", "];
    
    } else {
        
        argument = resolver.addressString;
        result   = [resolver.resolvedNames componentsJoinedByString:@", "];
    }
    fprintf(stderr, "%s -> %s\n", [argument UTF8String], [result UTF8String]);
    self.runningResolverCount -= 1;
}

- (void)hostResolver:(QCFHostResolver *)resolver didFailWithError:(NSError *)error
// A resolver delegate callback, called when the resolve fails.  Prints the error.
{
    NSString *      argument;
    
    if (resolver.name != nil) {
        argument = resolver.name;
    } else {
        argument = resolver.addressString;
    }
    fprintf(stderr, "%s -> %s / %zd\n", [argument UTF8String], [[error domain] UTF8String], (ssize_t) [error code]);
    self.runningResolverCount -= 1;
}

@end
