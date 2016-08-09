//
//  ArrayDataSourceCase.m
//  TestTabelController
//
//  Created by wzg on 16/8/9.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ArrayDataSource.h"
#import "PhotoDataCase.h"

@interface ArrayDataSourceCase : PhotoDataCase

@end

@implementation ArrayDataSourceCase

- (void)setUp {
    [super setUp];
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
    tableViewCellConfigureBlock block = ^(UITableViewCell *cell,id b){};
    id obj1 = [[ArrayDataSource alloc]initWithItems:@[] cellIdentifier:@"foo" configureCellBlock:block];
    XCTAssertNotNil(obj1,@"");
}

- (void)testCellConfiguration{
    __block UITableViewCell *configcell = nil;
    __block id configuredObject = nil;
    tableViewCellConfigureBlock block = ^(UITableViewCell *cell,id b){
        configcell = cell;
        configuredObject = b;
    };
    
    ArrayDataSource *data = [[ArrayDataSource alloc]initWithItems:@[@"a",@"c"] cellIdentifier:@"foo" configureCellBlock:block];
    id mockTable = [self autoVerifiedMockForClass:[UITableView class]];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[[mockTable expect] andReturn:cell] dequeueReusableCellWithIdentifier:@"foo" forIndexPath:indexPath];
    id result = [data tableView:mockTable cellForRowAtIndexPath:indexPath];
    XCTAssertEqual(result, cell,@"should return the dummy cell");
    XCTAssertEqual(configcell, cell,@"should have been passed to the block");
    XCTAssertEqualObjects(configuredObject, @"a",@"this should have benn passed the block");
    
}

- (void)testNumOfRows
{
    id mockTable = [self autoVerifiedMockForClass:[UITableView class]];
        ArrayDataSource *data = [[ArrayDataSource alloc]initWithItems:@[@"a",@"c"] cellIdentifier:@"foo" configureCellBlock:nil];
    XCTAssertEqual([data tableView:mockTable numberOfRowsInSection:0], 2,@"数量不对");
}



@end
