//
//  TestTabelControllerTests.m
//  TestTabelControllerTests
//
//  Created by 王智刚 on 16/6/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VVStack.h"
#import "DebugHttpMonitor.h"
#import "DebugDB.h"
#import "DebugManager.h"
#import "DebugNetWork.h"
#import "NetWork.h"

@interface TestTabelControllerTests : XCTestCase<NSURLSessionDelegate>
@property (nonatomic, strong)VVStack *stack;
@property (nonatomic, strong)NSURLSession *session;
@property (nonatomic, strong)DebugDB *db;
@end

@implementation TestTabelControllerTests

- (void)setUp {
    [super setUp];
    _stack = [VVStack new];
    [DebugHttpMonitor setNetMonitorEnable:YES];
    
}

- (void)tearDown {
    _stack = nil;
    
    DebugNetWork *net = [DebugManager networkInstance];
    NetWork *model = [net beginRequest];
    model.method = @"post";
    model.beginDate = [NSDate date];
    [net endRequest:model];
    
    NSLog(@"%@",net.requests);
    
//    [self post];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)get
{
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    //    }];
    //    [task resume];
    
    NSURLSession *session2 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask *task2 = [session2 dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [task2 resume];
}

- (void)post
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/CocoaPods/Specs/master/Specs/AFNetworking/2.5.4/AFNetworking.podspec.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5;
    [request setAllHTTPHeaderFields:@{@"Content-Type":@"2"}];
    request.HTTPMethod = @"POST";
    //    request.allHTTPHeaderFields = @{
    //
    //                                    }
    NSData *postData = [@"key1=value1&key2=value2" dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = postData;
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        XCTAssert(!data,@"数据为空");
    }];
    
    [task resume];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        
        // Put the code you want to measure the time of here.
    }];
}

@end
