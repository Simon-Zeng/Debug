//
//  eLongDebugUserDefaultView.m
//  ElongClient
//
//  Created by Dawn on 15/3/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugUserDefaultView.h"
#import "eLongDebugManager.h"

@interface eLongDebugUserDefaultView()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (nonatomic,strong) eLongDebugStorage *debugStorage;
@property (nonatomic,strong) NSArray *userDefaults;
@property (nonatomic,strong) UITableView *userDefaultTableView;
@property (nonatomic,strong) UITextView *detailTextView;
@end
@implementation eLongDebugUserDefaultView

- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.debugStorage = [eLongDebugManager storageInstance];
        self.userDefaults = [self.debugStorage userDefaults];
        
        // 请求列表
        self.userDefaultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.contentView.frame.size.width, self.contentView.frame.size.height - 50) style:UITableViewStylePlain];
        self.userDefaultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.userDefaultTableView.delegate = self;
        self.userDefaultTableView.dataSource = self;
        self.userDefaultTableView.rowHeight = 30;
        self.userDefaultTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.userDefaultTableView];
        
        [self.userDefaultTableView reloadData];
        
        // 详情页
        self.detailTextView = [[UITextView alloc] initWithFrame:self.contentView.bounds];
        self.detailTextView.editable = NO;
        self.detailTextView.delegate = self;
        self.detailTextView.textColor = [UIColor whiteColor];
        self.detailTextView.backgroundColor = [UIColor clearColor];
        self.detailTextView.font = [UIFont systemFontOfSize:14.0];
        self.detailTextView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.contentView addSubview:self.detailTextView];
        self.detailTextView.hidden = YES;
        
    }
    return self;
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(cut:)) {
        return NO;
    }else if(action == @selector(copy:)) {
        return YES;
    }else if(action == @selector(paste:)) {
        return NO;
    }else if(action == @selector(select:)) {
        return YES;
    }else if(action == @selector(selectAll:)) {
        return YES;
    }else {
        return [super canPerformAction:action withSender:sender];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userDefaults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"RequestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
//        cell.detailTextLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:162.0/255.0 blue:23.0/255.0 alpha:1]; //[UIColor greenColor];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView = [[UIView alloc] init];
        
    }
    eLongDebugUserDefaultModel *userDefault = [self.userDefaults objectAtIndex:indexPath.row];
    cell.textLabel.text = userDefault.key;
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }else{
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    eLongDebugUserDefaultModel *userDefault = [self.userDefaults objectAtIndex:indexPath.row];
    self.detailTextView.text = userDefault.value;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.contentView cache:YES];
    
    self.detailTextView.hidden = NO;
    self.userDefaultTableView.hidden = YES;
    
    [self.detailTextView becomeFirstResponder];
    
    [UIView commitAnimations];
    
}


- (void) closeBtnClick:(id)sender{
    if (self.detailTextView.hidden == NO) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.contentView cache:YES];
        
        self.detailTextView.hidden = YES;
        self.userDefaultTableView.hidden = NO;
        
        [UIView commitAnimations];
    }else{
        self.debugStorage = nil;
        self.userDefaults = nil;
        self.userDefaultTableView = nil;
        self.detailTextView = nil;
        [super closeBtnClick:sender];
    }
   
}

@end
