//
//  eLongDebugPerformanceView.m
//  ElongClient
//
//  Created by Dawn on 15/3/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugPerformanceView.h"
#import "eLongDebugManager.h"

@interface eLongDebugPerformanceView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) eLongDebugPerformance *debugPerformance;
@property (nonatomic,strong) UITableView *performanceTableView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) eLongDebugMemoryModel *memoryModel;
@end
@implementation eLongDebugPerformanceView

- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.debugPerformance = [eLongDebugManager performanceInstance];
        self.memoryModel = [self.debugPerformance memery];
        
        // 请求列表
        self.performanceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.contentView.frame.size.width, self.contentView.frame.size.height - 50) style:UITableViewStylePlain];
        self.performanceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.performanceTableView.delegate = self;
        self.performanceTableView.dataSource = self;
        self.performanceTableView.rowHeight = 30;
        self.performanceTableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.performanceTableView];
        
        [self.performanceTableView reloadData];
        
        //
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countSecond:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void) countSecond:(id)sender{
    self.memoryModel = [self.debugPerformance memery];
    [self.performanceTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"RequestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:39.0/255.0 green:162.0/255.0 blue:23.0/255.0 alpha:1]; //[UIColor greenColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView = [[UIView alloc] init];
        
    }
    
    
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"可使用内存";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", self.memoryModel.availableMemory];
        }
            break;
        case 1:{
            cell.textLabel.text = @"已用内存";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.memoryModel.usedMemory];
        }
            break;
        case 2:{
            cell.textLabel.text = @"free";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.memoryModel.memory.free];
        }
            break;
        case 3:{
            cell.textLabel.text = @"active";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.memoryModel.memory.active];
        }
            break;
        case 4:{
            cell.textLabel.text = @"inactive";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.memoryModel.memory.inactive];
        }
            break;
        case 5:{
            cell.textLabel.text = @"wire";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.memoryModel.memory.wire];
        }
            break;
        case 6:{
            cell.textLabel.text = @"zero_fill";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.memoryModel.memory.zero_fill];
        }
            break;
        case 7:{
            cell.textLabel.text = @"reactivations";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.memoryModel.memory.reactivations];
        }
            break;
        case 8:{
            cell.textLabel.text = @"pageins";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.memoryModel.memory.pageins];
        }
            break;
        case 9:{
            cell.textLabel.text = @"pageouts";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",self.memoryModel.memory.pageouts];
        }
            break;
        case 10:{
            cell.textLabel.text = @"faults";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.memoryModel.memory.faults];
        }
            break;
        case 11:{
            cell.textLabel.text = @"cow_faults";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.memoryModel.memory.cow_faults];
        }
            break;
        case 12:{
            cell.textLabel.text = @"lookups";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.memoryModel.memory.lookups];
        }
            break;
        case 13:{
            cell.textLabel.text = @"hits";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.memoryModel.memory.hits];
        }
            break;
        default:
            break;
    }
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }else{
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return cell;
}

- (void) closeBtnClick:(id)sender{
    [self.timer invalidate];
    self.timer = nil;
    self.debugPerformance = nil;
    self.performanceTableView = nil;
    self.memoryModel = nil;
    [super closeBtnClick:sender];
}
@end
