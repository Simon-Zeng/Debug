//
//  PhotoViewControllerCase.m
//  TestTabelController
//
//  Created by wzg on 16/8/9.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PhotoDataCase.h"
#import "PhotoViewController.h"
#import "PhotoController.h"

@interface PhotoViewControllerCase : PhotoDataCase

@end

@implementation PhotoViewControllerCase

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

- (void)testLoading{
    id mockNavController = [self autoVerifiedMockForClass:[UINavigationController class]];
    PhotoController *photosvc = [[PhotoController alloc]init];
    id photosMock = [self autoVerifiedPartialMockForObject:photosvc];
    [[[photosMock stub] andReturn:mockNavController] navigationController];
    
    UIViewController *vc = [OCMArg checkWithBlock:^BOOL(id obj) {
        PhotoViewController *photoVc = obj;
        return [photoVc isKindOfClass:[PhotoViewController class]]&& photoVc.photo != nil;
    }];
    
    [[mockNavController expect] pushViewController:vc animated:YES];
    
    UIView *view = photosvc.view;
    XCTAssertNotNil(view,@"");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
