//
//  eLongHomeAdWebController.m
//  eLongFramework
//
//  Created by 张馨允 on 16/2/29.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongHomeAdWebController.h"
#import "eLongCountlyEventShow.h"
#import "eLongAnalyticsGlobalModel.h"
#import "eLongAlertView.h"
#import "NSArray+CheckArray.h"
#import "NSString+eLongExtension.h"
#import "eLongServices.h"
#import "NSDictionary+CheckDictionary.h"
#import "NSMutableDictionary+SafeForObject.h"


#define kHotelDetail 1003

//h5页面红包分享页面重定向使用
#define URL_STRING_COMPONENT_IMGHEIGHT @"imgHeight"
#define URL_STRING_COMPONENT_CALLBACK @"callback"

@interface eLongHomeAdWebController (){
@private
    UIBarButtonItem *backItem;
    UIBarButtonItem *forwardItem;
    UIBarButtonItem *refreshItem;
    UIToolbar *tool;
    NSDictionary *jsonDic;
    NSString *countlyPageName; //打点页面名称
    UIWebView *myWebView;
}

@property (nonatomic, strong) SmallLoadingView *smallLoading;

@end
@implementation eLongHomeAdWebController
- (void)dealloc
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [myWebView stopLoading];
    [myWebView removeFromSuperview];
#import "NSMutableDictionary+SafeForObject.h"

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//H5页面统一打点pageName规则
- (void)getCountlyPageNameWithUrl:(NSString *)url{
    NSString *tempUrl = [[[[url componentsSeparatedByString:@"//"]safeObjectAtIndex:1] componentsSeparatedByString:@"?"] safeObjectAtIndex:0];
    NSArray *indexArray = [tempUrl componentsSeparatedByString:@"/"];
    if (ARRAYHASVALUE(indexArray)) {
        if([indexArray count] >= 3) {
            countlyPageName = [NSString stringWithFormat:@"%@/%@",[indexArray safeObjectAtIndex:1],[indexArray safeObjectAtIndex:2]];
        }else if ([indexArray count] >= 2){
            countlyPageName = [indexArray safeObjectAtIndex:1];
        }
    }
}

- (id)initWithTitle:(NSString *)title targetUrl:(NSString *)url style:(NavBarBtnStyle)navStyle{
    
    self = [super initWithTitle:title style:navStyle];
    if (self){
        //获取统一打点页面名
        [self getCountlyPageNameWithUrl:url];
        //打点
        eLongCountlyEventShow *countlyEventShow = [[eLongCountlyEventShow alloc] init];
        countlyEventShow.page = countlyPageName;
        [countlyEventShow sendEventCount:1];
        
        // 跳转到H5之前追加日志收集信息
        eLongAnalyticsGlobalModel *globalModel = [eLongAnalyticsGlobalModel sharedInstance];
        url = [globalModel urlStringAppendAnalyticsData:url];
        
        [eLongServices callService:@"eLongWebJSBridgeGetWebView",self,^(UIWebView *jsWebView){
            
            myWebView = jsWebView;
            
        },nil];
        
        myWebView.scalesPageToFit = YES;
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
        [self.view addSubview:myWebView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(h5AppRedirect:) name:@"NOTI_H5APP_SESSIONEXCHANGE" object:nil];
    }
    return self;
}

- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style params:(NSDictionary *)params {
    
    titleStr = [params safeObjectForKey:@"titleStr"];
    style = [[params safeObjectForKey:@"style"] intValue];
    
    if (self = [super initWithTitle:titleStr style:style params:params]) {
        
        NSString *webUrl = [params safeObjectForKey:@"webUrl"];
        [self getCountlyPageNameWithUrl:webUrl];
        //打点
        eLongCountlyEventShow *countlyEventShow = [[eLongCountlyEventShow alloc] init];
        countlyEventShow.page = countlyPageName;
        [countlyEventShow sendEventCount:1];
        
        // 跳转到H5之前追加日志收集信息
        eLongAnalyticsGlobalModel *globalModel = [eLongAnalyticsGlobalModel sharedInstance];
        webUrl = [globalModel urlStringAppendAnalyticsData:webUrl];
        
        [eLongServices callService:@"eLongWebJSBridgeGetWebView",self,^(UIWebView *jsWebView){
            
            myWebView = jsWebView;
            
        },nil];
        
        myWebView.scalesPageToFit = YES;
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
        
        [self.view addSubview:myWebView];
        
    }
    return self;
}

- (void) setIsNavBarShow:(BOOL)isNavBarShow{
    _isNavBarShow = isNavBarShow;
    if (self.isNavBarShow) {
        if (!tool) {
            //            [self makeNavBottomBar];//14.7.24被注释
        }
    }else{
        if (tool) {
            [tool removeFromSuperview];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置回退按钮
//    adNavi = [[HomeAdNavi alloc] init];
}

/* 暂时注释
- (void) makeNavBottomBar {
    myWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44);
    
    // 构造下方得toolbar
    tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 20 - 44, SCREEN_WIDTH, 44)];
    tool.barStyle = UIBarStyleBlack;
    tool.translucent = YES;
    
    NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:2];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage noCacheImageNamed:@"goback.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(webGoBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.showsTouchWhenHighlighted = YES;
    backBtn.frame = CGRectMake(0, 0, 50, 44);
    backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    backItem.enabled = NO;
    [itemsArray addObject:backItem];
    
    UIButton *forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardBtn setImage:[UIImage noCacheImageNamed:@"goforward.png"] forState:UIControlStateNormal];
    [forwardBtn addTarget:self action:@selector(webGoForward) forControlEvents:UIControlEventTouchUpInside];
    forwardBtn.showsTouchWhenHighlighted = YES;
    forwardBtn.frame = CGRectMake(0, 0, 50, 44);
    forwardItem = [[UIBarButtonItem alloc] initWithCustomView:forwardBtn];
    forwardItem.enabled = NO;
    [itemsArray addObject:forwardItem];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexItem];
    
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage noCacheImageNamed:@"webrefresh_btn.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    refreshBtn.showsTouchWhenHighlighted = YES;
    refreshBtn.frame = CGRectMake(0, 0, 50, 44);
    refreshItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    [itemsArray addObject:refreshItem];
    
    tool.items = itemsArray;
    [self.view addSubview:tool];
    
}
*/

- (void)webGoBack {
    [myWebView goBack];
}


- (void)webGoForward {
    [myWebView goForward];
}


- (void)refresh {
    [myWebView reload];
}

- (void)back{
    if ([myWebView canGoBack])
    {
        [myWebView goBack];
    }
    else
    {
        [super back];
    }
}


- (void)addLoadingView {
    if (!self.smallLoading) {
        self.smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, (MAINCONTENTHEIGHT - 50) / 2, 50, 50)];
        [self.view addSubview:self.smallLoading];
    }
    
    [self.smallLoading startLoading];
}

- (void)removeLoadingView {
    [self.smallLoading stopLoading];
}

- (void)h5AppRedirect:(NSNotification *)notification{
    if (notification.userInfo) {
        NSURL *url = [NSURL URLWithString:[notification.userInfo objectForKey:@"url"]];
        [myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }else{
        [self back];
    }
}

#pragma mark - UIWebviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url = request.URL.absoluteString;
    
    //截断安卓分享参数url对我们产生的跳转影响
    if([[url lowercaseString]rangeOfString:[URL_STRING_COMPONENT_IMGHEIGHT lowercaseString]].length > 0 && [url rangeOfString:URL_STRING_COMPONENT_CALLBACK].length > 0){
        return NO;
    }
    
    //截取h5 url重定向进行分享
    NSArray *components = [url componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"testapp"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"alert"])
        {
            //请求分享信息
            NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"WxCall()"];
            jsonDic = [[NSDictionary alloc]initWithDictionary:[str JSONValue]];
            
            //调起微信分享
            [self weakUpWeixinShare];
        }
        return NO;
    }
    
    NSNumber *redirect = [eLongServices callServiceHasReturnValue:@"HomeAdNaviRedirect",url,nil];
    
    if ([redirect boolValue]) {
        return NO;
    }

    NSString *queryString=request.URL.query;
    NSLog(@"%@",queryString);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self addLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self removeLoadingView];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self removeLoadingView];
}
-(void)share{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM safeSetObject:[jsonDic objectForKey:@"title"] forKey:@"wxShareTitle"];
    [dictM safeSetObject:[jsonDic objectForKey:@"imgUrl"] forKey:@"shareThumbImageUrl"];
    [dictM safeSetObject:[jsonDic objectForKey:@"desc"] forKey:@"shareMessage"];
    [dictM safeSetObject:[jsonDic objectForKey:@"link"] forKey:@"shareLink"];
    
    [eLongServices callService:@"eLongShare",dictM,[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES],nil];
}

-(void)weakUpWeixinShare{
    //未安装微信
   //TODO:
    NSNumber *isSupport = [eLongServices callServiceHasReturnValue:@"WeChatCheckAppIsInstalled",nil];
    if(![isSupport boolValue]){
        [eLongAlertView showAlertTitle:nil Message:@"您没有安装微信哟！"];
        return;
    }
    if ([eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_OPENID] == nil || [eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_UNIONID] == nil){
        // 唤起微信进行授权
        [eLongServices callService:@"WeChatAuth", @"snsapi_userinfo", @"weixin", ^(NSInteger resultCode, NSString *resultInfo, NSString *code){
            
            if (resultCode == 1) {
                [self share];
                [self shareSucessful];

            }else {
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:resultInfo
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView show];
            }
            
        },nil];
        
    }else{
        //弹出分享框,回调成功后传给后台openID
        [self share];
        [self shareSucessful];
    }
    
}


#pragma mark -
#pragma mark 分享成功
- (void) shareSucessful {
    NSLog(@"分享成功：unionID:%@",[eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_UNIONID]);
    //回调js WxCallBack（parameter1,parameter2,parameter3）
    NSString * unionID = [eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_UNIONID];
    NSString * access_token = [eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_ACCESSTOKEN];
    NSString * openID = [eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_OPENID];
    NSString * callBackJsMethod  = [NSString stringWithFormat:@"WxCallBack(\"%@\",\"%@\",\"%@\")", unionID,access_token,openID];
    NSLog(@"callbackJS:%@",callBackJsMethod);
    [myWebView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:callBackJsMethod afterDelay:3];
}


- (void)resetWebViewFrame {
    CGRect rect = myWebView.frame;
    rect.size.height = SCREEN_HEIGHT;
    myWebView.frame = rect;
}

@end
