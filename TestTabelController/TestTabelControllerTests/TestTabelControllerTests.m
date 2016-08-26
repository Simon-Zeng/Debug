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
#import "ReadAndWriteLock.h"


#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define angleNeed(x) (M_PI*(x))



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

- (void)testMockRequest
{
    
}



- (void)confusionPlist
{
    NSDictionary *student = @{
                              @"age":@(12),
                              @"name":@"小明",
                              @"school":@"家里蹲"
                              };
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Confuse" ofType:@"plist"];
    NSDictionary *confusePlist = [[NSDictionary alloc]initWithContentsOfFile:path];
    XCTAssertNil(confusePlist,@"字典不能为空");
    NSLog(@"%@",confusePlist);
}

- (void)tearDown {
    //    [self post];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}


- (void)testWriteLock
{
    for (NSUInteger i = 0; i<10; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"name:%@",[NSThread currentThread].name);
            
        });
    }
}

- (void)testRead
{
    
}

//- (void)transFormProcessToRadians:(CGFloat)process
//{
//    
//    CGFloat height = 100;//直径
//    CGFloat r = height/2;
////    CGFloat result = degreesToRadians(process * 360);
//    //超出半径的高度
//    CGFloat moreH = cosf(process) * r;
//}

- (void)test1{
    _stack = nil;
    
    DebugNetWork *net = [DebugManager networkInstance];
    NetWork *model = [net beginRequest];
    model.method = @"post";
    model.beginDate = [NSDate date];
    model.data = @"dadahdahdsjakhskdjhaj";
    [net endRequest:model];
    
    NSLog(@"%@",net.requests);
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

- (void)testLiteral
{
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    
    NSDictionary *dict = @{
                           nonNilKey : nilVal,
                           nilKey:nonNilVal
                           };
    
    XCTAssertEqualObjects([dict allKeys], @[nonNilKey]);
    XCTAssertNoThrow([dict objectForKey:nonNilKey]);
    id val = dict[nonNilKey];
    XCTAssertEqualObjects(val, [NSNull null]);
    XCTAssertNoThrow([val length]);
    XCTAssertNoThrow([val count]);
    XCTAssertNoThrow([val anyObject]);
    XCTAssertNoThrow([val integerValue]);
    XCTAssertNoThrow([val intValue]);
}

- (void)testKeyedSubscript
{
    
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
