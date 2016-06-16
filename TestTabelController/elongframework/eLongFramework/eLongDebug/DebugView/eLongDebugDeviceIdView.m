//
//  eLongDebugDeviceIdView.m
//  eLongFramework
//
//  Created by Dean on 16/4/15.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongDebugDeviceIdView.h"
#import "eLongDebugDeviceid.h"
#import "eLongDebugManager.h"

@interface eLongDebugDeviceIdView()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *deviceidList;
@property (nonatomic,strong) eLongDebugDeviceid *deviceidObj;
@property (nonatomic,strong) UITableView *deviceidTableView;
@property (nonatomic,strong) UITextField *deviceidField;

@end

@implementation eLongDebugDeviceIdView

- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.deviceidObj = [eLongDebugManager deviceIdInstance];
        // 请求列表
        self.deviceidList = [NSMutableArray arrayWithArray:[self.deviceidObj deviceids]];
        
        // 请求列表
        self.deviceidTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.contentView.frame.size.width, self.contentView.frame.size.height - 50) style:UITableViewStylePlain];
        self.deviceidTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.deviceidTableView.delegate = self;
        self.deviceidTableView.dataSource = self;
        self.deviceidTableView.rowHeight = 40;
        self.deviceidTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.deviceidTableView];
        
        // 添加
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addBtn.frame = CGRectMake(self.contentView.frame.size.width - 60, 0, 40, 40);
        [self.contentView addSubview:addBtn];
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 搜索
        self.deviceidField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, self.contentView.frame.size.width-80, 40)];
        self.deviceidField.borderStyle = UITextBorderStyleRoundedRect;
        self.deviceidField.returnKeyType = UIReturnKeyDone;
        self.deviceidField.keyboardType = UIKeyboardTypeASCIICapable;
        self.deviceidField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.deviceidField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.deviceidField.delegate = self;
        self.deviceidField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.deviceidField.textColor = [UIColor whiteColor];
        self.deviceidField.placeholder = @"设备id";
        self.deviceidField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.contentView addSubview:self.deviceidField];
        
        [self.deviceidTableView reloadData];
    }
    return self;
}


- (void) addBtnClick:(id)sender{
    NSString *deviceId = [self.deviceidField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (deviceId) {
        NSArray *devicePartList = [deviceId componentsSeparatedByString:@"-"];
        if (devicePartList.count != 5) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输出正确的设备ID"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSString *firstPart = devicePartList[0];
        NSString *secondPart = devicePartList[1];
        NSString *thirdPart = devicePartList[2];
        NSString *forthPart = devicePartList[3];
        NSString *fifthPart = devicePartList[4];

        if (firstPart.length != 8 ||
            secondPart.length != 4 ||
            thirdPart.length != 4 ||
            forthPart.length != 4 ||
            fifthPart.length != 12) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输出正确的设备ID"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        
        for (eLongDebugDeviceIdModel *model in self.deviceidList) {
            if ([model.deviceid isEqualToString:deviceId]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存在相同设备ID"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
        }
        eLongDebugDeviceIdModel *deviceIdModel = [self.deviceidObj addDeviceIdName:@"" deviceid:deviceId];
        if (deviceIdModel) {
            [self.deviceidList addObject:deviceIdModel];
            [self.deviceidTableView reloadData];
            self.deviceidField.text = @"";
            [self.deviceidField resignFirstResponder];
            [[NSNotificationCenter defaultCenter] postNotificationName:ELONDEBUG_NOTI_DEVICEIDCHANGED
                                                                object:nil];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请添加设备ID"
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
    if (self.deviceidList) {
        return self.deviceidList.count;
    }
    return self.deviceidList.count;
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
    eLongDebugDeviceIdModel *model = [self.deviceidList objectAtIndex:indexPath.row];
    cell.textLabel.text = model.deviceid;
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
    eLongDebugDeviceIdModel *model = [self.deviceidList objectAtIndex:indexPath.row];
    [self.deviceidList removeObjectAtIndex:indexPath.row];
    [self.deviceidObj removeDeviceid:model];
    [self.deviceidTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:ELONDEBUG_NOTI_DEVICEIDCHANGED
                                                        object:nil];
}



#pragma mark -
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (eLongDebugDeviceIdModel *deviceIdModel in self.deviceidList) {
        deviceIdModel.enabled = @(NO);
    }
    eLongDebugDeviceIdModel *model = [self.deviceidList objectAtIndex:indexPath.row];
    model.enabled = @(YES);
    [self.deviceidObj saveDeviceId:model];
    [self.deviceidTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:ELONDEBUG_NOTI_SERVERCHANGED
                                                        object:nil];
}

- (void) closeBtnClick:(id)sender{
    self.deviceidList = nil;
    self.deviceidObj = nil;
    self.deviceidTableView = nil;
    self.deviceidField = nil;
    [super closeBtnClick:sender];
}

@end
