//
//  PhotoDataCase.h
//  TestTabelController
//
//  Created by wzg on 16/8/8.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

// This little block can probably go away with the next version of developer tools:
#ifndef NS_REQUIRES_SUPER
# if __has_attribute(objc_requires_super)
#  define NS_REQUIRES_SUPER __attribute((objc_requires_super))
# else
#  define NS_REQUIRES_SUPER
# endif
#endif

@interface PhotoDataCase : XCTestCase

- (void)setUp NS_REQUIRES_SUPER;

- (void)tearDown NS_REQUIRES_SUPER;

/// Returns the URL for a resource that's been added to the test target.
- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)extension;

/// Calls +[OCMockObject mockForClass:] and adds the mock and call -verify on it during -tearDown
- (id)autoVerifiedMockForClass:(Class)aClass;
/// C.f. -autoVerifiedMockForClass:
- (id)autoVerifiedPartialMockForObject:(id)object;

/// Calls -verify on the mock during -tearDown
- (void)verifyDuringTearDown:(id)mock;


@end
