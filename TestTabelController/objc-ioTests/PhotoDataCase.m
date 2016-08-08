//
//  PhotoDataCase.m
//  TestTabelController
//
//  Created by wzg on 16/8/8.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "PhotoDataCase.h"
#import "ArrayDataSource.h"

@interface PhotoDataCase()
@property (nonatomic, strong)NSMutableArray *mocksToVerify;
@end

@implementation PhotoDataCase

- (void)setUp {
    [super setUp];
    self.mocksToVerify = nil;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
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

- (void)testInitializing
{
    XCTAssertNotNil([[ArrayDataSource alloc]init],@"should not be allowed");
}

/// Returns the URL for a resource that's been added to the test target.
- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)extension
{
    return nil;
}

/// Calls +[OCMockObject mockForClass:] and adds the mock and call -verify on it during -tearDown
- (id)autoVerifiedMockForClass:(Class)aClass
{
    return nil;
}
/// C.f. -autoVerifiedMockForClass:
- (id)autoVerifiedPartialMockForObject:(id)object
{
    return nil;
}

/// Calls -verify on the mock during -tearDown
- (void)verifyDuringTearDown:(id)mock
{

}

@end
