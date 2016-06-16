//
//  eLongHtml5WebController.m
//  InterHotel
//
//  Created by 张馨允 on 16/3/1.
//  Copyright © 2016年 eLong. All rights reserved.
//

#import "eLongHtml5WebController.h"
#import "eLongCountlyEventShow.h"
#import "eLongAlertView.h"
#import "eLongServices.h"
#import "NSDictionary+CheckDictionary.h"
#import "NSMutableDictionary+SafeForObject.h"
#import "NSArray+CheckArray.h"
#import "NSString+eLongExtension.h"


//判断群红包分享  add by 张馨允
#define URL_STRING_COMPONENT_GROUPPACKET @"GroupPacket"

//截断安卓分享信息url用
#define URL_STRING_COMPONENT_IMGHEIGHT @"imgHeight"
#define URL_STRING_COMPONENT_CALLBACK @"callback"

@interface eLongHtml5WebController ()<UIGestureRecognizerDelegate>{
    
    UIWebView *myWebView;
    
    NSString *countlyPageName;
    
    SmallLoadingView *smallLoading;				// 地图模式loading框
    
    BOOL modifySuccess;                 // 修改订单是否成功
    H5Type fromType;         //来源
    
    //add by 张馨允
    NSDictionary *jsonDic;  //红包分享内容dic
    BOOL isHongBaoShare;    //是否进行红包分享数据请求
}
@end

@implementation eLongHtml5WebController

- (void)dealloc
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url FromType:(H5Type)type{
    self =  [self initWithTitle:title Html5Link:url];
    //获取统一打点页面名
    [self getCountlyPageNameWithUrl:url];
    if(self){
        fromType = type;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url style:(NavBarBtnStyle )navStyle{
    self = [super initWithTitle:title  style:navStyle];
    if (self){
        modifySuccess = NO;
        NSLog(@"%@", url);
        //获取统一打点页面名
        [self getCountlyPageNameWithUrl:url];
        
        [eLongServices callService:@"eLongWebJSBridgeGetWebView",self,^(UIWebView *jsWebView){
            
            myWebView = jsWebView;
            
        },nil];

        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
        [self.view addSubview:myWebView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url
{
    return [self initWithTitle:title Html5Link:url style:NavBarBtnStyleNoTel];
}

- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style params:(NSDictionary *)params {
    
    titleStr = [params safeObjectForKey:@"titleStr"];
    style = [[params safeObjectForKey:@"style"] integerValue];
    
    if (self = [super initWithTitle:titleStr style:style params:params]) {
        NSString *webUrl = [params safeObjectForKey:@"webUrl"];
        //获取统一打点页面名
        [self getCountlyPageNameWithUrl:webUrl];
        
        H5Type type = [[params safeObjectForKey:@"h5Type"] integerValue];
        fromType = type;
        
        [eLongServices callService:@"eLongWebJSBridgeGetWebView",self,^(UIWebView *jsWebView){
            
            myWebView = jsWebView;
            
        },nil];
        
        myWebView.scalesPageToFit = YES;
        
        NSURL *url = [NSURL URLWithString:webUrl];
        if (STRINGHASVALUE(webUrl) && url) {
            
        }else {
            url = [NSURL URLWithString:@"http://m.elong.com"];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [myWebView loadRequest:request];
        
        [self.view addSubview:myWebView];
        
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    eLongCountlyEventShow *countlyEventShow = [[eLongCountlyEventShow alloc] init];
    countlyEventShow.page = countlyPageName;
    [countlyEventShow sendEventCount:1];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark -- 右滑返回时需要调用的back方法 --
- (void)slideBack{
    
    switch (fromType) {
        case HOTEL_MODIFYORDER:
        {
            if (modifySuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_ORDER_MODIFY" object:nil];
            }
        }
            break;
        case HOTEL_FEEDBACK:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_HOTEL_FEEDBACK" object:nil];

        }
            break;
        case HOTEL_ORDER_REBATE:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_MYELONG_ORDER_REBATE_LIST_CHANGED" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_USERCENTERCOUNTCHANGED object:nil]; //刷新页面小红
        }
            break;
        default:
            break;
    }
}

#pragma mark -- UIGestureRecognizerDelegate 右滑返回代理方法 --
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //判断为右滑手势
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
        [self slideBack];
        return YES;
    }
    return YES;
}

- (void)back{
    // 对于webview返回的特殊处理
    if (myWebView.canGoBack) {
        [myWebView goBack];
    }
    else{
        [super back];
    }
    
    switch (fromType) {
        case HOTEL_MODIFYORDER:
        {
            if (modifySuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_ORDER_MODIFY" object:nil];
            }
        }
            break;
        case HOTEL_FEEDBACK:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_HOTEL_FEEDBACK" object:nil];

        }
            break;
        case HOTEL_ORDER_REBATE:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_MYELONG_ORDER_REBATE_LIST_CHANGED" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_USERCENTERCOUNTCHANGED object:nil]; //刷新页面小红点
        }
            break;
        default:
            break;
    }
    
}
- (void)modi_back:(NSString *)orderid
{
    [super back];
    if (modifySuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_ORDER_MODIFY" object:nil userInfo:[NSDictionary dictionaryWithObject:orderid forKey:@"orderid"]];
    }
}

- (void)backhome{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_USERCENTERCOUNTCHANGED object:nil];
    [super backhome];
}

- (void)addLoadingView {
    if (!smallLoading) {
        smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 50)/2, (MAINCONTENTHEIGHT - 50) / 2, 50, 50)];
        [self.view addSubview:smallLoading];
    }
    
    [smallLoading startLoading];
}

- (void)removeLoadingView {
    [smallLoading stopLoading];
}

#pragma mark - UIWebviewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"%@",[request.URL absoluteString]);
    
    if ([[url lowercaseString] rangeOfString:[URL_STRING_COMPONENT_GROUPPACKET lowercaseString]].length>0) {
        isHongBaoShare = YES;
    }
    
    if([[url lowercaseString]rangeOfString:[URL_STRING_COMPONENT_IMGHEIGHT lowercaseString]].length > 0 && [url rangeOfString:URL_STRING_COMPONENT_CALLBACK].length > 0){
        return NO;
    }
    
    //截取h5 url重定向进行分享
    NSArray *components = [url componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"testapp"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"alert"])
        {
            //调起微信分享
            [self weakUpWeixinShare];
        }
        return NO;
    }
    
    
    if ([url hasPrefix:@"http://m.elong.com/Hotel/EditOrderComplete"])
    {
        // 进入h5的成功页面时，发送修改成功的通知
        modifySuccess = YES;
    }else if ([url hasPrefix:@"http://m.elong.com/Order/HotelOrderList"]) {
        NSArray *queries = [[request.URL absoluteString] componentsSeparatedByString:@"&"];
        for (NSString *parameter in queries) {
            NSArray *p = [parameter componentsSeparatedByString:@"="];
            if ([p count]>1) {
                if([p[0] isEqualToString:@"OrderNo"]){
                    modifySuccess = YES;
                    [self modi_back:p[1]];
                }
            }
        }
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self addLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self removeLoadingView];
    
    if (isHongBaoShare) {
        //调用js方法 WxCall（）获取数据
        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"WxCall()"];
        jsonDic = [[NSDictionary alloc]initWithDictionary:[str JSONValue]];
        isHongBaoShare = NO;
        
        NSLog(@"---str:%@",str);
        NSLog(@"---jsonDic:%@", jsonDic);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self removeLoadingView];
    
    [eLongAlertView showAlertQuiet:[error.userInfo safeObjectForKey:@"NSLocalizedDescription"]];
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
    NSNumber *weChatInstalled = [eLongServices callServiceHasReturnValue:@"WeChatCheckAppIsInstalled",nil];
    if(![weChatInstalled boolValue]){
//        [PublicMethods showAlertTitle:nil Message:@"您没有安装微信哟！"];
        [eLongAlertView showAlertTitle:nil Message:@"您没有安装微信哟！"];
        return;
    }
    if ([eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_OPENID] == nil || [eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_UNIONID] == nil){ //1.unionID为h5页面红包分享请求必须的值；2.因为更多页面绑定账户，不涉及unionID的请求，所以不能仅以unionID作为是否需要授权的标志
        
        //对微信进行授权
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
    //回调js WxCallBack（parameter1,parameter2）
    NSString * unionID = [eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_UNIONID];
    NSString * access_token = [eLongUserDefault objectForKey:USERDEFAULT_WEIXIN_ACCESSTOKEN];
    NSString * callBackJsMethod  = [NSString stringWithFormat:@"WxCallBack(\"%@\",\"%@\")", unionID,access_token];
    NSLog(@"callbackJS:%@",callBackJsMethod);
    [myWebView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:callBackJsMethod afterDelay:3];
    
}

@end
