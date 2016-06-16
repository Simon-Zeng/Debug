//
//  eLongHTTPRequestOperation.h
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongHTTPRequestOperationDelegate.h"
#import "eLongDebugManager.h"

@interface eLongHTTPRequestOperation : NSOperation<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<eLongHTTPRequestOperationDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableURLRequest *currentReq;

/**
 *  记录网络请求日志
 */
@property (nonatomic, strong) eLongDebugNetworkModel *networkRequestModel;

- (id)initWithRequest:(NSURLRequest *)request;

@end
