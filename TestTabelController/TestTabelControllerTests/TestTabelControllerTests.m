//
//  TestTabelControllerTests.m
//  TestTabelControllerTests
//
//  Created by 王智刚 on 16/6/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VVStack.h"

@interface TestTabelControllerTests : XCTestCase
@property (nonatomic, strong)VVStack *stack;
@end

@implementation TestTabelControllerTests

- (void)setUp {
    [super setUp];
    _stack = [VVStack new];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    _stack = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPushStackAndGetIt{
    [_stack push:2.3];
    double num = [_stack stop];
    XCTAssertEqual(num, 2.3,@"stack push can use");
}

- (void)testStackExist{
    XCTAssertNotNil([VVStack class],@"should exist");
}

- (void)testCanCreateObject{
    VVStack *stack = [VVStack new];
    XCTAssertNotNil(stack,@"objcet exist");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        [self testCanCreateObject];
        // Put the code you want to measure the time of here.
    }];
}

@end
