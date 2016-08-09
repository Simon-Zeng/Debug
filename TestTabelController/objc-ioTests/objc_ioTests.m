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

//- (void)testRex
//{
//    NSString *string = @"#系统BUG#\r\n公司名称：安徽天健环保股份有限公司\r\n联系人：耿博    13759541668";
//    
//    NSRange range = NSMakeRange(0, string.length);
//    
//    NSMutableArray *linkRanges = [NSMutableArray array];
//    
//    XCTAssert(range.location != NSNotFound,@"字符串出错");
//    
//        NSString *highlightedPattern = @"\13759541668|\#系统BUG#|((http|https)://([a-zA-Z]|[0-9])*(\.([a-zA-Z]|[0-9])*)*(\/([a-zA-Z]|[0-9]|[#?+=-]|[\.&%_;])*)*)";
//        NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:highlightedPattern
//                                                                      options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
//    
//    XCTAssertNil(matches,@"匹配数组不纯在");
//    XCTAssert(matches.count > 0,@"结果是存在的");
//        for(NSTextCheckingResult* match in matches.reverseObjectEnumerator) {
//            
//        }
//    
//}


- (void)testAssert{
    //     XCTFail(format…) 生成一个失败的测试；
    //    XCTFail(@"Fail");
    
    
    // XCTAssertNil(a1, format...) 为空判断， a1 为空时通过，反之不通过；
    //    XCTAssertNil(@"not nil string", @"string must be nil");
    
    
    // XCTAssertNotNil(a1, format…) 不为空判断，a1不为空时通过，反之不通过；
    //    XCTAssertNotNil(@"not nil string", @"string can not be nil");
    
    
    // XCTAssert(expression, format...) 当expression求值为TRUE时通过；
    //    XCTAssert((2 > 2), @"expression must be true");
    
    
    // XCTAssertTrue(expression, format...) 当expression求值为TRUE时通过；
    //    XCTAssertTrue(1, @"Can not be zero");
    
    
    // XCTAssertFalse(expression, format...) 当expression求值为False时通过；
    //    XCTAssertFalse((2 < 2), @"expression must be false");
    
    
    // XCTAssertEqualObjects(a1, a2, format...) 判断相等， [a1 isEqual:a2] 值为TRUE时通过，其中一个不为空时，不通过；
    //    XCTAssertEqualObjects(@"1", @"1", @"[a1 isEqual:a2] should return YES");
    //    XCTAssertEqualObjects(@"1", @"2", @"[a1 isEqual:a2] should return YES");
    
    
    //     XCTAssertNotEqualObjects(a1, a2, format...) 判断不等， [a1 isEqual:a2] 值为False时通过，
    //    XCTAssertNotEqualObjects(@"1", @"1", @"[a1 isEqual:a2] should return NO");
    //    XCTAssertNotEqualObjects(@"1", @"2", @"[a1 isEqual:a2] should return NO");
    
    
    // XCTAssertEqual(a1, a2, format...) 判断相等（当a1和a2是 C语言标量、结构体或联合体时使用,实际测试发现NSString也可以）；
    // 1.比较基本数据类型变量
    //    XCTAssertEqual(1, 2, @"a1 = a2 shoud be true"); // 无法通过测试
    //    XCTAssertEqual(1, 1, @"a1 = a2 shoud be true"); // 通过测试
    
    // 2.比较NSString对象
    //    NSString *str1 = @"1";
    //    NSString *str2 = @"1";
    //    NSString *str3 = str1;
    //    XCTAssertEqual(str1, str2, @"a1 and a2 should point to the same object"); // 通过测试
    //    XCTAssertEqual(str1, str3, @"a1 and a2 should point to the same object"); // 通过测试
    
    // 3.比较NSArray对象
    //    NSArray *array1 = @[@1];
    //    NSArray *array2 = @[@1];
    //    NSArray *array3 = array1;
    //    XCTAssertEqual(array1, array2, @"a1 and a2 should point to the same object"); // 无法通过测试
    //    XCTAssertEqual(array1, array3, @"a1 and a2 should point to the same object"); // 通过测试
    
    
    // XCTAssertNotEqual(a1, a2, format...) 判断不等（当a1和a2是 C语言标量、结构体或联合体时使用）；
    
    
    // XCTAssertEqualWithAccuracy(a1, a2, accuracy, format...) 判断相等，（double或float类型）提供一个误差范围，当在误差范围（+/- accuracy ）以内相等时通过测试；
    //    XCTAssertEqualWithAccuracy(1.0f, 1.5f, 0.25f, @"a1 = a2 in accuracy should return YES");
    
    
    // XCTAssertNotEqualWithAccuracy(a1, a2, accuracy, format...) 判断不等，（double或float类型）提供一个误差范围，当在误差范围以内不等时通过测试；
    //    XCTAssertNotEqualWithAccuracy(1.0f, 1.5f, 0.25f, @"a1 = a2 in accuracy should return NO");
    
    
    // XCTAssertThrows(expression, format...) 异常测试，当expression发生异常时通过；反之不通过；（很变态）
    
    
    // XCTAssertThrowsSpecific(expression, specificException, format...) 异常测试，当expression发生 specificException 异常时通过；反之发生其他异常或不发生异常均不通过；
    
    // XCTAssertThrowsSpecificNamed(expression, specificException, exception_name, format...) 异常测试，当expression发生具体异常、具体异常名称的异常时通过测试，反之不通过；
    
    
    // XCTAssertNoThrow(expression, format…) 异常测试，当expression没有发生异常时通过测试；
    
    
    // XCTAssertNoThrowSpecific(expression, specificException, format...)异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过；
    
    
    // XCTAssertNoThrowSpecificNamed(expression, specificException, exception_name, format...) 异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过
}

- (void)testExample {

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
