//
//  ViewController.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/6.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "ViewController.h"
#import "checkFeed.h"
#import "baoxiaoModel.h"
#import "qingjiaModel.h"
#import "feedState.h"
#import "feedFactory.h"
#import "feeData.h"
#import "DebugManager.h"
#import "DebugView.h"
#import "Aspects.h"
#import "NetWork.h"
#import "NetworkSerialization.h"
#import "DebugNetWork.h"
#import "DebugManager.h"
#import "NSString+Extension.h"
#import "DebugHttpMonitor.h"
#import "ProcessView.h"
#import "Masonry.h"
#import "BubbleView.h"

@interface ViewController ()<NSURLSessionTaskDelegate>
@property (nonatomic,strong) UIWindow *window;
@end

@implementation ViewController
- (IBAction)getClick:(id)sender {
    [self get];
}
- (IBAction)postClick:(id)sender {
    [self post];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [DebugHttpMonitor setNetMonitorEnable:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    DebugView *debug  = [[DebugView alloc]init];
//    debug.root = self;
//    [debug showOverWindow];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 100, 50);
    btn.titleLabel.text = @"get";
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(100, 200, 100, 50);
    btn1.titleLabel.text = @"post";
    btn1.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn1];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"改变" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(changeUrl) forControlEvents:UIControlEventTouchUpInside];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(300);
        make.height.width.mas_equalTo(50);
    }];
    
    BubbleView *bubble = [[BubbleView alloc]initWithPoint:CGPointMake(100, 400) superView:self.view];
    bubble.bWidth = 10;
    bubble.bColor = [UIColor redColor];
    bubble.title.text = @"99";
    bubble.viscosity = 0.6;

    self.view.backgroundColor = [UIColor whiteColor];
    self.window = [[[UIApplication sharedApplication] delegate] window];
    DebugView *debug = [[DebugView alloc]initWithFrame:CGRectZero];
    debug.rootVc = self.navigationController;
    [debug showOverWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:debug];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetWindow) name:UIWindowDidBecomeKeyNotification object:nil];
    
//    ProcessView *process = [[ProcessView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
//    [self.view addSubview:process];
    
//    [self aspectGet];
//    [self aspectPost];
    
}

- (void)changeUrl
{
    [DebugHttpMonitor exchangeRequestUrlWithNewUrl:@"www.wzg.com"];
}


//- (void)drawGradient
//{
//    CGFloat circelRadius = 100;
//    CGFloat lineWidth = 5;
//    size_t colorsCount = 2;
//    CGFloat colors[12] = {
//        0.01f, 0.99f, 0.01f, 1.0f,
//        0.01f, 0.99f, 0.99f, 1.0f,
//        0.99f, 0.99f, 0.01f, 1.0f
//    };
//    CGFloat locations[3] = {
//        0.0f,
//        0.5f,
//        1.0f
//    };
//    CGPoint beginP = CGPointMake(0, 0);
//    CGPoint endP = CGPointMake(320.f, 460.f);
//    //圆路径
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)
//                                                        radius:(circelRadius - lineWidth) / 2
//                                                    startAngle:degreesToRadians(-90)
//                                                      endAngle:degreesToRadians(270)
//                                                     clockwise:YES];
//    
//    [path addClip];
//    
//    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, colorsCount);
//    
//    //    CG_EXTERN CGGradientRef __nullable CGGradientCreateWithColorComponents(
//    //                                                                           CGColorSpaceRef __nullable space, const CGFloat * __nullable components,
//    //                                                                           const CGFloat * __nullable locations, size_t count)
//    //渐变
//    CGContextDrawLinearGradient(context, gradient, beginP, endP, 0);
//    
//    //    CGContextDrawRadialGradient(<#CGContextRef  _Nullable c#>, <#CGGradientRef  _Nullable gradient#>, <#CGPoint startCenter#>, <#CGFloat startRadius#>, <#CGPoint endCenter#>, <#CGFloat endRadius#>, <#CGGradientDrawingOptions options#>)
//    CGColorSpaceRelease(space);
//    CGGradientRelease(gradient);
//}

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
    request.timeoutInterval = 30;
    [request setAllHTTPHeaderFields:@{@"Content-Type":@"2"}];
    request.HTTPMethod = @"POST";
    //    request.allHTTPHeaderFields = @{
    //
    //                                    }
    NSData *postData = [@"key1=value1&key2=value2" dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = postData;
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",data);
    }];
    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    
//    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
//    request.timeoutInterval = 5;
//    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
////       NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
//    }];
    
    [task resume];
}

- (void)resetWindow{
    [self.window makeKeyWindow];
}

- (void)test
{
    baoxiaoModel *baoxiao = [[baoxiaoModel alloc]init];
    baoxiao.count = @"42342";
    baoxiao.remark = @"这是一个报销";
    
    qingjiaModel *qingjia = [[qingjiaModel alloc]init];
    qingjia.beginDate = @"2016-06-12";
    qingjia.endDate = @"2016-06-15";
    
    feedState  *state = [[feedState alloc]init];
    state.model = baoxiao;
    
    [checkFeed saveStateWithMemento:[state toMemento]  keyName:nil];
    
    feeData *data1 = [[feeData alloc]init];
    data1.dataname = @"审批";
    
    feeData *data2 = [[feeData alloc]init];
    data2.dataname = @"请假";
    
    feedFactory *factory = [[feedFactory alloc]init];
    feed<feed> *feed1 =  [factory createFeedWithName:@"审批数据源"];
    feed<feed> *feed2 = [factory createFeedWithName:@"请假数据源"];
    
    [feed1 feedWihthFeedData:data1];
    [feed2 feedWihthFeedData:data2];

}

- (void)aspectCreateSession
{
    [NSURLSession aspect_hookSelector:@selector(sharedSession) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
        NSLog(@"请求开始");
    } error:NULL];
}

- (void)aspectGet
{
    [NSURLSession aspect_hookSelector:@selector(dataTaskWithURL:completionHandler:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        NSLog(@"%@",aspectInfo);
    } error:NULL];
}

- (void)aspectPost
{
    DebugNetWork *debugNet = [DebugManager networkInstance];
    debugNet.enable = YES;
    __block NetWork *net = [debugNet beginRequest];
//    [NSURLSession aspect_hookSelector:@selector(dataTaskWithRequest:completionHandler:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,NSMutableURLRequest *requset,void (^block)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error)){
//        NSString *path = [requset.URL.absoluteString safeString];
//        NSString *method = [requset.HTTPMethod safeString];
//        NSString *type = [[requset.allHTTPHeaderFields valueForKey:@"Content-Type"] safeString];
//        
////        NSNumber *size = @(data.length);
////        NSString *dataString = nil;
////        if (data) {
////            dataString = [eLongNetworkSerialization jsonStringWithObject:[eLongNetworkSerialization jsonObjectWithData:data]];
////        }else{
////            dataString = @"error";
////        }
//        //NSString *body = [[NSString alloc] initWithData:operation.currentReq.HTTPBody encoding:NSUTF8StringEncoding];
//        NSString *header = [NetworkSerialization jsonStringWithObject:requset.allHTTPHeaderFields];
//        net.path = path;
//        net.method = method;
//        net.type = type;
//        net.header = header;
//        DebugNetWork *debugNetWork = [DebugManager networkInstance];
//        [debugNetWork endRequest:net];
//        NSLog(@"网络记录模型为%@",net);
//    } error:NULL];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{

}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{

}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{

}

// 接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"didReceiveResponse");
    completionHandler(NSURLSessionResponseAllow);
}
// 接收到服务器返回的数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
}
// 请求完毕
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
