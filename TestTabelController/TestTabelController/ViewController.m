//
//  ViewController.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/6.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "ViewController.h"
#import "checkFeed.h"
#import "baoxiaoModel.h"
#import "qingjiaModel.h"
#import "feedState.h"
#import "feedFactory.h"
#import "feeData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baoxiaoModel *baoxiao = [[baoxiaoModel alloc]init];
    baoxiao.count = @"42342";
    baoxiao.remark = @"这是一个报销";
    
    qingjiaModel *qingjia = [[qingjiaModel alloc]init];
    qingjia.beginDate = @"2016-06-12";
    qingjia.endDate = @"2016-06-15";
    
    feedState  *state = [[feedState alloc]init];
    state.model = baoxiao;
    
    [checkFeed saveStateWithMemento:[state toMemento]  keyName:nil];
    
    feeData *data1 = [[feeData alloc]init];
    data1.dataname = @"审批";
    
    feeData *data2 = [[feeData alloc]init];
    data2.dataname = @"请假";
    
    feedFactory *factory = [[feedFactory alloc]init];
    feed<feed> *feed1 =  [factory createFeedWithName:@"审批数据源"];
    feed<feed> *feed2 = [factory createFeedWithName:@"请假数据源"];
    
    [feed1 feedWihthFeedData:data1];
    [feed2 feedWihthFeedData:data2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
