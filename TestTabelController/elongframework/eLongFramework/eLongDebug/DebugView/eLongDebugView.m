//
//  eLongDebugView.m
//  ElongClient
//
//  Created by Dawn on 15/3/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugView.h"
#import "eLongDebugServerView.h"
#import "eLongDebugBusinessLineView.h"
#import "eLongDebugCrashView.h"
#import "eLongDebugNetworkView.h"
#import "eLongDebugPerformanceView.h"
#import "eLongDebugUserDefaultView.h"
#import "eLongDebugKeychainView.h"
#import "eLongDebugAdsView.h"
#import "eLongDebugDeviceIdView.h"
#import "eLongBus.h"

@interface eLongDebugView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *actionTableView;
@property (nonatomic,strong) NSArray *actions;
@property (nonatomic,strong) UIWindow *window;
@end

@implementation eLongDebugView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat screenWidth = ([[UIScreen mainScreen] bounds].size.width);
        CGFloat screenHeight = ([[UIScreen mainScreen] bounds].size.height);
        self.frame = CGRectMake(screenWidth, 80, 60, screenHeight - 80 * 2);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        // 数据源
        self.actions = @[@"服务",@"业务",@"崩溃",@"网络",@"内存",@"UD",@"密钥",@"广告",@"禅道", @"设备ID"];
        
        // 功能区
        self.actionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40)];
        self.actionTableView.delegate = self;
        self.actionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.actionTableView.dataSource = self;
        self.actionTableView.rowHeight = 60;
        self.actionTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.actionTableView];
        
        // 收起按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"收起" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40);
        [self addSubview:btn];
        btn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        _hidden = YES;
    }
    return self;
}

- (void) showOverWindow {
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(100, 0, ([[UIScreen mainScreen] bounds].size.width) - 100, 20)];
    // iOS9 will crash if not have this sentence.
    self.window.rootViewController = [eLongBus bus].rootViewController;
    self.window.windowLevel = UIWindowLevelStatusBar + 10;
    self.window.hidden = NO;
    
    UISwipeGestureRecognizer *recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    [recognizer1 setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.window addGestureRecognizer:recognizer1];
    
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.window addGestureRecognizer:recognizer2];
}

- (void) btnClick:(id)sender{
    self.hidden = YES;
}

- (void) handleSwipeFromRight:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:recognizer.view];
    if (point.y < 20) {
        self.hidden = NO;
    }
}

- (void) handleSwipeFromLeft:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:recognizer.view];
    if (point.y < 20) {
        self.hidden = YES;
    }
}

- (void) setHidden:(BOOL)hidden {
    if (hidden != _hidden) {
        _hidden = hidden;
        if (!self.superview) {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        }
        if (hidden) {
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat screenWidth = ([[UIScreen mainScreen] bounds].size.width);
                CGFloat screenHeight = ([[UIScreen mainScreen] bounds].size.height);
                self.frame = CGRectMake(screenWidth, 80, self.frame.size.width, screenHeight - 80 * 2);
            }];
            [self.actionTableView reloadData];
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat screenWidth = ([[UIScreen mainScreen] bounds].size.width);
                CGFloat screenHeight = ([[UIScreen mainScreen] bounds].size.height);
                self.frame = CGRectMake(screenWidth - self.frame.size.width, 80, self.frame.size.width, screenHeight - 80 * 2);
            }];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.actions.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"DebugActionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIView alloc] init];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = [self.actions objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    eLongDebugActionView *actionView = nil;
    switch (indexPath.row) {
        case 0:{
            // 服务器
            actionView = [[eLongDebugServerView alloc] initWithFrame:CGRectZero];
        }
            break;
        case 1:{
            // 业务线
            actionView = [[eLongDebugBusinessLineView alloc] initWithFrame:CGRectZero];
        }
            break;
        case 2:{
            // Crash
            actionView = [[eLongDebugCrashView alloc] initWithFrame:CGRectZero];
        }
            break;
        case 3:{
            // 网络请求
            actionView = [[eLongDebugNetworkView alloc] initWithFrame:CGRectZero];
        }
            break;
        case 4:{
            // 内存
            actionView = [[eLongDebugPerformanceView alloc] initWithFrame:CGRectZero];
        }
            break;
        case 5:{
            // UserDefault
            actionView = [[eLongDebugUserDefaultView alloc] initWithFrame:CGRectZero];
        }
            break;
        case 6:{
            // Keychain
            actionView = [[eLongDebugKeychainView alloc] initWithFrame:CGRectZero];
        }
            break;
        case 7:{
            // 广告
            actionView = [[eLongDebugAdsView alloc] initWithFrame:CGRectZero];
        }
            break;
        case 8:{
            
            //接入禅道
            NSNumber *isLogin = [eLongServices callServiceHasReturnValue:@"eLongBugManagerLoginService",nil];
            
            if ([isLogin boolValue]) {
                
                self.hidden = YES;
                [eLongRoutes routeURL:[NSURL URLWithString:@"eLongBugManager/fillInfo"]];
            }else {
                
                self.hidden = YES;
                [eLongRoutes routeURL:[NSURL URLWithString:@"eLongBugManager/login"]];
            }
        }
            break;
        case 9:{
            //deviceid
            actionView = [[eLongDebugDeviceIdView alloc] initWithFrame:CGRectZero];
        }
            break;
        default:
            break;
    }
    [actionView showOverWindow];
}
@end
