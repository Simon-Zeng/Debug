//
//  eLongHostResolver.h
//  ElongClient
//
//  Created by Harry Zhao on 7/30/15.
//  Copyright (c) 2015 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCFHostResolver.h"

@interface eLongHostResolver : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,strong,readonly) NSMutableDictionary *resolvers;

- (void)run;

- (void)addHost:(NSString *)host;

- (void)addIPAdress:(NSString *)ip;

- (NSString *)validateDNS:(NSString *)host;

@end
