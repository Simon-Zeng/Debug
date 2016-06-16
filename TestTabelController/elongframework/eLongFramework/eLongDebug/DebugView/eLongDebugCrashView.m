//
//  eLongDebugCrashView.m
//  ElongClient
//
//  Created by Dawn on 15/3/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugCrashView.h"
#import "eLongDebugCrash.h"
#import "eLongDebugManager.h"

@interface eLongDebugCrashView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *crashes;
@property (nonatomic,strong) eLongDebugCrash *debugCrash;
@property (nonatomic,strong) UITableView *crashTableView;
@property (nonatomic,strong) UITextView *detailTextView;
@end
@implementation eLongDebugCrashView

- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.debugCrash = [eLongDebugManager crashInstance];
        // crash列表数据
        self.crashes = [NSMutableArray arrayWithArray:[self.debugCrash crashes]];
        
        // crash列表
        self.crashTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.contentView.frame.size.width, self.contentView.frame.size.height - 50) style:UITableViewStylePlain];
        self.crashTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.crashTableView.delegate = self;
        self.crashTableView.dataSource = self;
        self.crashTableView.rowHeight = 40;
        self.crashTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.crashTableView];
        
        // crash详情页
        // 详情页
        self.detailTextView = [[UITextView alloc] initWithFrame:self.contentView.bounds];
        self.detailTextView.editable = NO;
        self.detailTextView.textColor = [UIColor whiteColor];
        self.detailTextView.backgroundColor = [UIColor clearColor];
        self.detailTextView.font = [UIFont systemFontOfSize:14.0];
        self.detailTextView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.contentView addSubview:self.detailTextView];
        self.detailTextView.hidden = YES;
        
        //清除按钮
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.crashTableView.frame.size.width, 40)];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = headerView.bounds;
        clearBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [clearBtn setTitle:@"清除数据" forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:clearBtn];
        self.crashTableView.tableHeaderView = headerView;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.crashTableView.frame.size.width, 40)];
        UIButton *clearBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn2.frame = headerView.bounds;
        clearBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [clearBtn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [clearBtn2 setTitle:@"清除数据" forState:UIControlStateNormal];
        [clearBtn2 addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:clearBtn2];
        self.crashTableView.tableFooterView = footerView;
        
        [self.crashTableView reloadData];
    }
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.crashes) {
        return self.crashes.count;
    }
    return self.crashes.count;
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
    eLongDebugCrashModel *model = [self.crashes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",model.page,model.date];
    
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
    eLongDebugCrashModel *model = [self.crashes objectAtIndex:indexPath.row];
    
    NSMutableString *text = [NSMutableString stringWithFormat:@""];
    [text appendFormat:@"页面名称：\n%@\n\n",model.page];
    [text appendFormat:@"异常名称：\n%@\n\n",model.name];
    [text appendFormat:@"app版本号：\n%@\n\n",model.version];
    [text appendFormat:@"系统版本号：\n%@\n\n",model.osversion];
    [text appendFormat:@"设备类型：\n%@\n\n",model.device];
    
    NSString *network = @"";
    switch ([model.network integerValue]) {
        case 0:
            network = @"3G";
            break;
        case 1:
            network = @"2G";
            break;
        case 3:
            network = @"WIFI";
            break;
        default:
            break;
    }
    [text appendFormat:@"网络类型：\n%@\n\n",network];
    [text appendFormat:@"渠道号：\n%@\n\n",model.channel];
    [text appendFormat:@"crash时间：\n%@\n\n",model.date];
    [text appendFormat:@"设备状态：\n%@\n\n",model.mark];
    [text appendFormat:@"堆栈信息：\n%@\n\n",model.stack];
    self.detailTextView.text = text;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.contentView cache:YES];
    
    self.detailTextView.hidden = NO;
    self.crashTableView.hidden = YES;
    
    [UIView commitAnimations];
}

- (void)clearBtnClick:(id)sender{
    self.crashes = nil;
    [[eLongDebugManager crashInstance] clearCrash];
    [self.crashTableView reloadData];
}

- (void) closeBtnClick:(id)sender{
    if (self.detailTextView.hidden == NO) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.contentView cache:YES];
        
        self.detailTextView.hidden = YES;
        self.crashTableView.hidden = NO;
        
        [UIView commitAnimations];
    }else{
        self.crashTableView = nil;
        self.detailTextView = nil;
        self.crashes = nil;
        [super closeBtnClick:sender];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
