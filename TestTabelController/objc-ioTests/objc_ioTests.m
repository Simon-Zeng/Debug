//
//  objc_ioTests.m
//  objc-ioTests
//
//  Created by wzg on 16/8/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AFNetworking.h"
#import "STAlertView.h"
#import <OCMock/OCMock.h>

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface objc_ioTests : XCTestCase
@property (nonatomic, strong)STAlertView *alerView;
@end

@implementation objc_ioTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSLog(@"测试方法");
    int a = 0;
    XCTAssertTrue(a==0,"a不能等于0");
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testRequest{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    AFSecurityPolicy *sec = [[AFSecurityPolicy alloc]init];
    [sec setAllowInvalidCertificates:YES];
    [mgr setSecurityPolicy:sec];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"charset=utf-8",@"text/html",@"application/json",nil];
    [mgr GET:@"http://www.fsceshi.com/" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        XCTAssertNotNil(responseObject,@"返回错误");
        self.alerView = [[STAlertView alloc]initWithTitle:@"验证码" message:nil textFieldHint:@"请输入手机验证码" textFieldValue:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确定" cancelButtonBlock:^{
            //点击取消返回后执行
            [self testAlertViewCancel];
            NOTIFY //继续执行
        } otherButtonBlock:^(NSString *b) {
            //点击确定后执行
            [self alertViewComfirm:b];
            NOTIFY //继续执行
        }];
        [self.alerView show];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XCTAssertNil(error,@"出错错误");
        NOTIFY
    }];
    WAIT
}

- (void)testAssert
{

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

-(void)testAlertViewCancel{
    NSLog(@"取消");
}
-(void)testAlertViewComfirm{
    [self alertViewComfirm:nil];
}
-(void)alertViewComfirm:(NSString *)test{
    NSLog(@"手机验证码:%@",test);
}


@end
