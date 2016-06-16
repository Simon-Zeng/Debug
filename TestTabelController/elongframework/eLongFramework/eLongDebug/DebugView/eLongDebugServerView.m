//
//  eLongDebugServerView.m
//  ElongClient
//
//  Created by Dawn on 15/3/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugServerView.h"
#import "eLongDebugManager.h"

@interface eLongDebugServerView()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *servers;
@property (nonatomic,strong) eLongDebugServer *debugServer;
@property (nonatomic,strong) UITableView *serverTableView;
@property (nonatomic,strong) UITextField *serverField;
@end
@implementation eLongDebugServerView

- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.debugServer = [eLongDebugManager serverInstance];
        // 请求列表
        self.servers = [NSMutableArray arrayWithArray:[self.debugServer servers]];
        
        
        // 搜索
        self.serverField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, self.contentView.frame.size.width-80, 40)];
        self.serverField.borderStyle = UITextBorderStyleRoundedRect;
        self.serverField.returnKeyType = UIReturnKeyDone;
        self.serverField.keyboardType = UIKeyboardTypeASCIICapable;
        self.serverField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.serverField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.serverField.delegate = self;
        self.serverField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.serverField.textColor = [UIColor whiteColor];
        self.serverField.placeholder = @"服务器地址";
        self.serverField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.contentView addSubview:self.serverField];
        
        // 添加
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addBtn.frame = CGRectMake(self.contentView.frame.size.width - 60, 0, 40, 40);
        [self.contentView addSubview:addBtn];
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 请求列表
        self.serverTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.contentView.frame.size.width, self.contentView.frame.size.height - 50) style:UITableViewStylePlain];
        self.serverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.serverTableView.delegate = self;
        self.serverTableView.dataSource = self;
        self.serverTableView.rowHeight = 40;
        self.serverTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.serverTableView];
        
        [self.serverTableView reloadData];
    }
    return self;
}


- (void) addBtnClick:(id)sender{
    NSString *url = [self.serverField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([NSURL URLWithString:url].host) {
        for (eLongDebugServerModel *model in self.servers) {
            if ([model.url isEqualToString:url]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存在相同地址"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
        }
        eLongDebugServerModel *serverModel = [self.debugServer addServerName:@"" url:url];
        if (serverModel) {
            [self.servers addObject:serverModel];
            [self.serverTableView reloadData];
            self.serverField.text = @"";
            [self.serverField resignFirstResponder];
            [[NSNotificationCenter defaultCenter] postNotificationName:ELONDEBUG_NOTI_SERVERCHANGED
                                                                object:nil];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"服务地址错误"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.servers) {
        return self.servers.count;
    }
    return self.servers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"RequestCell";
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
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;//UILineBreakModeCharacterWrap;
        cell.selectedBackgroundView = [[UIView alloc] init];
        
    }
    eLongDebugServerModel *model = [self.servers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.url;
    if ([model.enabled boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }else{
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    eLongDebugServerModel *serverModel = [self.servers objectAtIndex:indexPath.row];
    [self.servers removeObjectAtIndex:indexPath.row];
    [self.debugServer removeServer:serverModel];
    [self.serverTableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ELONDEBUG_NOTI_SERVERCHANGED
                                                        object:nil];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (eLongDebugServerModel *serverModel in self.servers) {
        serverModel.enabled = @(NO);
    }
    eLongDebugServerModel *model = [self.servers objectAtIndex:indexPath.row];
    model.enabled = @(YES);
    [self.debugServer saveServer:model];
    [self.serverTableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ELONDEBUG_NOTI_SERVERCHANGED
                                                        object:nil];
}

- (void) closeBtnClick:(id)sender{
    self.servers = nil;
    self.debugServer = nil;
    self.serverTableView = nil;
    [super closeBtnClick:sender];
}

@end
