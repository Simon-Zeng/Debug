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
#import "SearchTestVc.h"
#import "DebugVc.h"
#import "AnimateVc.h"
#import "PasteTestController.h"
#import "SDAutoLayout.h"
#import "calulate.h"

@interface ViewController ()<NSURLSessionTaskDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIWindow *window;
@property (strong, nonatomic) UITableView *table;
@property (nonatomic, strong)NSArray *dataList;
@property (nonatomic, strong)dispatch_block_t testblock;
@end

@implementation ViewController
- (IBAction)getClick:(id)sender {
    [self get];
}
- (IBAction)postClick:(id)sender {
    [self post];
}

- (NSArray *)dataList
{
    return @[@"debug监听网络",@"新特性-searchapi",@"气泡动画",@"粘贴板",@"mockhttp"];
}

- (NSArray<UIViewController *> *)subVcs
{
    SearchTestVc *search = [[SearchTestVc alloc]init];
    DebugVc *Debug = [[DebugVc alloc]init];
    AnimateVc *animate = [[AnimateVc alloc]init];
    PasteTestController *paste = [[PasteTestController alloc]init];
    return [NSArray arrayWithObjects:search,Debug,animate,paste, nil];
}

- (void)viewDidLoad {
    NSLog(@"dsl---%f",mockCalulate(0).withAdd(5).withmultiply(2).result);
    
    [super viewDidLoad];
    self.table = [[UITableView alloc]init];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableFooterView = [UIView new];
    [self.view addSubview:self.table];
    
    self.testblock = ^(){
        NSLog(@"%@",self.dataList);
    };
    self.testblock();
    
    self.table.sd_layout.widthRatioToView(self.view,1).heightRatioToView(self.view,1).topSpaceToView(self.view,0).leftSpaceToView(self.view,0);
    
}

- (void)debugTest
{
    //    [DebugHttpMonitor setNetMonitorEnable:YES];
    //    self.view.backgroundColor = [UIColor whiteColor];
    //
    ////    DebugView *debug  = [[DebugView alloc]init];
    ////    debug.root = self;
    ////    [debug showOverWindow];
    //
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    //    btn.frame = CGRectMake(100, 100, 100, 50);
    //    btn.titleLabel.text = @"get";
    //    btn.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:btn];
    //
    //    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn1 addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    //    btn1.frame = CGRectMake(100, 200, 100, 50);
    //    btn1.titleLabel.text = @"post";
    //    btn1.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:btn1];
    //
    //    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    //
    //    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn2.backgroundColor = [UIColor redColor];
    //    [btn2 setTitle:@"改变" forState:UIControlStateNormal];
    //    [self.view addSubview:btn2];
    //    [btn2 addTarget:self action:@selector(changeUrl) forControlEvents:UIControlEventTouchUpInside];
    //    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(100);
    //        make.top.mas_equalTo(300);
    //        make.height.width.mas_equalTo(50);
    //    }];
    //
    //    BubbleView *bubble = [[BubbleView alloc]initWithPoint:CGPointMake(100, 400) superView:self.view];
    //    bubble.bWidth = 10;
    //    bubble.bColor = [UIColor redColor];
    //    bubble.title.text = @"99";
    //    bubble.viscosity = 0.6;
    //
    //    self.view.backgroundColor = [UIColor whiteColor];
    //    self.window = [[[UIApplication sharedApplication] delegate] window];
    //    DebugView *debug = [[DebugView alloc]initWithFrame:CGRectZero];
    //    debug.rootVc = self.navigationController;
    //    [debug showOverWindow];
    //    [[UIApplication sharedApplication].keyWindow addSubview:debug];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetWindow) name:UIWindowDidBecomeKeyNotification object:nil];
    
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

#pragma mark - native api
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 33)];
//    [cell setupAutoHeightWithBottomView:view bottomMargin:5];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取cell高度
//    return [self.table cellHeightForIndexPath:indexPath model:nil keyPath:@"cell" cellClass:[UITableViewCell class]  contentViewWidth:self.view.width];
    return 44;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [self subVcs][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - NSURLSessionDelegate
//- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
//{
//
//}
//
//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
//{
//
//}
//
//- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
//{
//
//}
//
//// 接收到服务器的响应
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
//{
//    NSLog(@"didReceiveResponse");
//    completionHandler(NSURLSessionResponseAllow);
//}
//// 接收到服务器返回的数据
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
//{
//    NSLog(@"didReceiveData");
//}
//// 请求完毕
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
//{
//    NSLog(@"didCompleteWithError");
//}
@end
