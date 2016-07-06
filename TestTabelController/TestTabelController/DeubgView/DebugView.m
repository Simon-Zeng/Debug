//
//  DebugView.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/20.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugView.h"
#import "DebugActionView.h"
#import "DebugActionNetWorkView.h"
#import "DebugServeView.h"

@interface DebugView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *actionTableView;
@property (nonatomic, strong)NSArray *actions;
@property (nonatomic, strong)UIWindow *window;


@end

@implementation DebugView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeigth = [UIScreen mainScreen].bounds.size.height;
        
        self.frame = CGRectMake(screenWidth, 80, 60, screenHeigth - 80*2);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        //数据源
        self.actions = @[@"网络",@"服务器",@"内存",@"崩溃"];
        
        self.actionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeigth - 40)];
        self.actionTableView.delegate = self;
        self.actionTableView.dataSource = self;
        self.actionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

#pragma mark - public method
- (void)showOverWindow
{
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(100, 0, [UIScreen mainScreen].bounds.size.width - 100, 20)];

    self.window.rootViewController = _root;

    self.window.rootViewController = self.rootVc;

    self.window.windowLevel = UIWindowLevelStatusBar + 10;
    self.window.hidden = NO;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromRight:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.window addGestureRecognizer:swipe];
    
    
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.window addGestureRecognizer:recognizer2];
}

#pragma mark - action
- (void) btnClick:(id)sender{
    self.hidden = YES;
}

- (void)handleSwipeFromLeft:(UISwipeGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:ges.view];
    if (point.y < 20) {
        self.hidden = YES;
    }
}

- (void)handleSwipeFromRight:(UISwipeGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:ges.view];
    if (point.y < 20) {
        self.hidden = NO;
    }
}

#pragma mark - dataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    }
    cell.textLabel.text = [self.actions objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DebugActionView *actionView = nil;
    switch (indexPath.row) {
        case 0:{
            // 网络
            actionView = [[DebugActionNetWorkView alloc] initWithFrame:CGRectZero];
        }
            break;
        case 1:{
            // 服务器
            actionView = [[DebugServeView alloc]initWithFrame:CGRectZero];
        }
            break;
        case 2:{
            // Crash

        }
            break;
        case 3:{
            // 设备id
            
        }
            break;
        default:
            break;
    }
    [actionView showOverWindow];
}

#pragma mark - property
- (void)setHidden:(BOOL)hidden
{
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
@end
