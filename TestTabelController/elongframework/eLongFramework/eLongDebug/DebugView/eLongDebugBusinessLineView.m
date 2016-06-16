//
//  eLongDebugBusinessLineView.m
//  ElongClient
//
//  Created by Dawn on 15/3/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugBusinessLineView.h"
#import "eLongDebugManager.h"

@interface eLongDebugBusinessLineView()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *businessLines;
@property (nonatomic,strong) eLongDebugBusinessLine *debugBusinessLine;
@property (nonatomic,strong) UITableView *businessLineTableView;
@property (nonatomic,strong) UITextField *serverField;
@end
@implementation eLongDebugBusinessLineView

- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.debugBusinessLine = [eLongDebugManager businessLineInstance];
        // 请求列表
        self.businessLines = [NSMutableArray arrayWithArray:[self.debugBusinessLine businessLines]];
        
        // 请求列表
        self.businessLineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.contentView.frame.size.width, self.contentView.frame.size.height - 50) style:UITableViewStylePlain];
        self.businessLineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.businessLineTableView.delegate = self;
        self.businessLineTableView.dataSource = self;
        self.businessLineTableView.rowHeight = 40;
        self.businessLineTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.businessLineTableView];
        
        [self.businessLineTableView reloadData];
    }
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.businessLines) {
        return self.businessLines.count;
    }
    return self.businessLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"RequestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIView alloc] init];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.selectedBackgroundView = [[UIView alloc] init];
        
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    eLongDebugBusinessModel *model = [self.businessLines objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.name;
    if ([model.enabled boolValue]) {
        cell.detailTextLabel.text = @"正常";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:162.0/255.0 blue:23.0/255.0 alpha:1]; //[UIColor greenColor];
    }else{
        cell.detailTextLabel.text = @"禁用";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    
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
    eLongDebugBusinessModel *model = [self.businessLines objectAtIndex:indexPath.row];
    model.enabled = @(![model.enabled boolValue]);
    [self.debugBusinessLine saveBusinessLine:model];
    [self.businessLineTableView reloadData];
}

- (void) closeBtnClick:(id)sender{
    self.businessLines = nil;
    self.debugBusinessLine = nil;
    self.businessLineTableView = nil;
    self.serverField = nil;
    [super closeBtnClick:sender];
}

@end
