//
//  DebugView.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/20.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugView.h"

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
        self.actions = @[@"网络",@"内存",@"崩溃",@"设备ID"];
        
        self.actionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeigth - 40)];
        self.actionTableView.delegate = self;
        self.actionTableView.dataSource = self;
        self.actionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.actionTableView.rowHeight = 60;
        self.actionTableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - public method
- (void)showOverWindow
{
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(100, 0, [UIScreen mainScreen].bounds.size.width - 100, 20)];
//    self.window.rootViewController
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
- (void)handleSwipeFromLeft:(UISwipeGestureRecognizer *)ges
{
    NSTimeInterval beginTime = CACurrentMediaTime();
    NSString *timeConsume = [NSString stringWithFormat:@"耗费时间:%f",beginTime - CACurrentMediaTime()];
}

- (void)handleSwipeFromRight:(UISwipeGestureRecognizer *)ges
{

}

#pragma mark - dataSource
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
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = [self.actions objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - delegate

#pragma mark - property
- (void)setHidden:(BOOL)hidden
{
    
}
@end
