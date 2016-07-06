//
//  DebugActionNetWorkView.m
//  TestTabelController
//
//  Created by wzg on 16/6/29.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugActionNetWorkView.h"
#import "DebugNetWork.h"
#import "NetWork.h"
#import "DebugManager.h"
#import "DebugHttpMonitor.h"

@interface DebugActionNetWorkView()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *networkTableView;
@property (nonatomic,strong) DebugNetWork *debugNetwork;
@property (nonatomic,strong) NSArray *requests;
@property (nonatomic,strong) NSArray *filterRequests;
@property (nonatomic,strong) UITextView *detailTextView;
@end

@implementation DebugActionNetWorkView

- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 请求列表
#ifdef DEBUG
        [DebugHttpMonitor setNetMonitorEnable:YES];
#endif
        self.debugNetwork = [DebugManager networkInstance];
        self.requests = [self.debugNetwork requests];
        
        // 搜索
        UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, self.contentView.frame.size.width-10, 40)];
        searchField.borderStyle = UITextBorderStyleRoundedRect;
        searchField.returnKeyType = UIReturnKeyDone;
        searchField.keyboardType = UIKeyboardTypeASCIICapable;
        searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchField.autocorrectionType = UITextAutocorrectionTypeNo;
        searchField.delegate = self;
        searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        searchField.textColor = [UIColor whiteColor];
        searchField.placeholder = @"请求地址关键词";
        searchField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.contentView addSubview:searchField];
        
        // 请求列表
        self.networkTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.contentView.frame.size.width, self.contentView.frame.size.height - 50) style:UITableViewStylePlain];
        self.networkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.networkTableView.delegate = self;
        self.networkTableView.dataSource = self;
        self.networkTableView.rowHeight = 60;
        self.networkTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.networkTableView];
        
        // 详情页
        self.detailTextView = [[UITextView alloc] initWithFrame:self.contentView.bounds];
        self.detailTextView.editable = NO;
        self.detailTextView.textColor = [UIColor whiteColor];
        self.detailTextView.backgroundColor = [UIColor clearColor];
        self.detailTextView.font = [UIFont systemFontOfSize:14.0];
        self.detailTextView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.contentView addSubview:self.detailTextView];
        self.detailTextView.hidden = YES;
        
        // 清除按钮
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.networkTableView.frame.size.width, 55)];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = CGRectMake(0, 0, self.networkTableView.frame.size.width, 40);
        clearBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [clearBtn setTitle:@"清除数据" forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:clearBtn];
        
        UILabel *flowTotal = [[UILabel alloc]init];
        flowTotal.frame = CGRectMake(0, 40, self.networkTableView.frame.size.width, 15);
        flowTotal.textColor = [UIColor redColor];
        flowTotal.font = [UIFont boldSystemFontOfSize:14.0];
        flowTotal.text = [NSString stringWithFormat:@"请求流量和:%.2f",[[[NSUserDefaults standardUserDefaults] valueForKey:@"netflowCount"] doubleValue]];
        [flowTotal sizeToFit];
        [headerView addSubview:flowTotal];
        self.networkTableView.tableHeaderView = headerView;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.networkTableView.frame.size.width, 40)];
        UIButton *clearBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn2.frame = headerView.bounds;
        clearBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [clearBtn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [clearBtn2 setTitle:@"清除数据" forState:UIControlStateNormal];
        [clearBtn2 addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:clearBtn2];
        self.networkTableView.tableFooterView = footerView;
        
        //
        [self.networkTableView reloadData];
    }
    return self;
}

#pragma mark -
#pragma mark ScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.networkTableView endEditing:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text && text.length) {
        self.filterRequests = [self.requests filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NetWork *model = (NetWork *)evaluatedObject;
            if ([model.path rangeOfString:text options:NSCaseInsensitiveSearch].length > 0 ) {
                return YES;
            }
            return NO;
        }]];
    }else{
        self.filterRequests = nil;
    }
    
    [self.networkTableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSString *text = textField.text;
    if (text && text.length) {
        self.filterRequests = [self.requests filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NetWork *model = (NetWork *)evaluatedObject;
            if ([model.path rangeOfString:text options:NSCaseInsensitiveSearch].length > 0 ) {
                return YES;
            }
            return NO;
        }]];
    }else{
        self.filterRequests = nil;
    }
    [self.networkTableView reloadData];
    return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.filterRequests) {
        return self.filterRequests.count;
    }
    return self.requests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"RequestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        //        cell.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIView alloc] init];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;// UILineBreakModeCharacterWrap;
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
        
    }
    NetWork *model = [(self.filterRequests?self.filterRequests:self.requests) objectAtIndex:indexPath.row];
    
    if ([model.statusCode intValue] == 200) {
        if ([model.data rangeOfString:@"\"IsError\" : true"].length > 0) {
            cell.detailTextLabel.textColor = [UIColor yellowColor];
        }else {
            cell.detailTextLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:162.0/255.0 blue:23.0/255.0 alpha:1]; //[UIColor greenColor];
        }
    }else {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd HH:mm:ss"];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"HH:mm:ss"];
    
    cell.textLabel.text = model.path;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %.2fkb [%@ %@ %.3fs]",
                                 model.method,
                                 model.statusCode,
                                 [model.size floatValue]/1024.0,
                                 [df stringFromDate:model.beginDate],
                                 [df2 stringFromDate:model.endDate],
                                 [model.endDate timeIntervalSinceDate:model.beginDate]];
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
    NetWork *model = [(self.filterRequests?self.filterRequests:self.requests) objectAtIndex:indexPath.row];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd HH:mm:ss"];
    
    NSMutableString *text = [NSMutableString stringWithFormat:@""];
    [text appendFormat:@"请求地址：\n%@\n\n",model.path];
    [text appendFormat:@"请求方法：\n%@\n\n",model.method];
    [text appendFormat:@"请求类型：\n%@\n\n",model.type];
    [text appendFormat:@"请求状态：\n%@\n\n",model.statusCode];
    [text appendFormat:@"开始时间：\n%@\n\n",[df stringFromDate:model.beginDate]];
    [text appendFormat:@"结束时间：\n%@\n\n",[df stringFromDate:model.endDate]];
    [text appendFormat:@"数据大小：\n%.2fkb\n\n",[model.size floatValue]/1024.0];
    [text appendFormat:@"请求header：\n%@\n\n",model.header];
    [text appendFormat:@"请求body：\n%@\n\n",model.body];
    [text appendFormat:@"回传数据：\n%@\n\n",model.data];
    self.detailTextView.text = text;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.contentView cache:YES];
    
    self.detailTextView.hidden = NO;
    self.networkTableView.hidden = YES;
    
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
        self.networkTableView.hidden = NO;
        
        [UIView commitAnimations];
    }else{
        self.networkTableView = nil;
        self.debugNetwork = nil;
        self.requests = nil;
        self.filterRequests = nil;
        self.detailTextView = nil;
        [super closeBtnClick:sender];
    }
}

- (void)clearBtnClick:(id)sender{
    self.requests = nil;
    [self.debugNetwork clearRequest];
    [self.networkTableView reloadData];
}

@end
