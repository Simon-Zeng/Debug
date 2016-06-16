//
//  eLongDebugAdsView.m
//  ElongClient
//
//  Created by Dawn on 15/4/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugAdsView.h"
#import "eLongDebugAds.h"
#import "eLongDebugManager.h"

@interface eLongDebugAdsView()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *ads;
@property (nonatomic,strong) eLongDebugAds *debugAds;
@property (nonatomic,strong) UITableView *adsTableView;
@property (nonatomic,strong) UITextField *adsField;
@end

@implementation eLongDebugAdsView

- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.debugAds = [eLongDebugManager adsInstance];
        // 请求列表
        self.ads = [NSMutableArray arrayWithArray:[self.debugAds ads]];
        
        // 请求列表
        self.adsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.contentView.frame.size.width, self.contentView.frame.size.height - 50) style:UITableViewStylePlain];
        self.adsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.adsTableView.delegate = self;
        self.adsTableView.dataSource = self;
        self.adsTableView.rowHeight = 40;
        self.adsTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.adsTableView];
        
        // 添加
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addBtn.frame = CGRectMake(self.contentView.frame.size.width - 60, 0, 40, 40);
        [self.contentView addSubview:addBtn];
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 搜索
        self.adsField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, self.contentView.frame.size.width-80, 40)];
        self.adsField.borderStyle = UITextBorderStyleRoundedRect;
        self.adsField.returnKeyType = UIReturnKeyDone;
        self.adsField.keyboardType = UIKeyboardTypeASCIICapable;
        self.adsField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.adsField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.adsField.delegate = self;
        self.adsField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.adsField.textColor = [UIColor whiteColor];
        self.adsField.placeholder = @"广告地址";
        self.adsField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.contentView addSubview:self.adsField];
        
        [self.adsTableView reloadData];
    }
    return self;
}


- (void) addBtnClick:(id)sender{
    NSString *url = [self.adsField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([NSURL URLWithString:url].host) {
        for (eLongDebugAdsModel *model in self.ads) {
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
        eLongDebugAdsModel *serverModel = [self.debugAds addAdsName:@"" url:url];
        if (serverModel) {
            [self.ads addObject:serverModel];
            [self.adsTableView reloadData];
            self.adsField.text = @"";
            [self.adsField resignFirstResponder];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"广告地址错误"
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
    if (self.ads) {
        return self.ads.count;
    }
    return self.ads.count;
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
    eLongDebugAdsModel *model = [self.ads objectAtIndex:indexPath.row];
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
    eLongDebugAdsModel *adsModel = [self.ads objectAtIndex:indexPath.row];
    [self.ads removeObjectAtIndex:indexPath.row];
    [self.debugAds removeAd:adsModel];
    [self.adsTableView reloadData];
}



#pragma mark -
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    eLongDebugAdsModel *model = [self.ads objectAtIndex:indexPath.row];
    model.enabled = @(![model.enabled boolValue]);
    [self.debugAds saveAds:model];
    [self.adsTableView reloadData];
}

- (void) closeBtnClick:(id)sender{
    self.ads = nil;
    self.debugAds = nil;
    self.adsTableView = nil;
    self.adsField = nil;
    [super closeBtnClick:sender];
}


@end
