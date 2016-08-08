//
//  PhotoController.m
//  TestTabelController
//
//  Created by wzg on 16/8/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoController.h"
#import "ArrayDataSource.h"
#import "PhotoCell.h"
#import "Photo.h"
#import "PhotoCell.h"
#import "PhotoCell+ConfigureForPhoto.h"

static NSString * const cellIdentifier = @"photocell";

@interface PhotoController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)ArrayDataSource *dataSource;
@end

@implementation PhotoController
#pragma mark - lifeCycle
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTabelView];
}


- (NSArray *)testPhotos
{
    return @[@"1",@"2",@"3",@"4",@"5"];
}

- (void)setupTabelView
{
    
    UITableView *table = [[UITableView alloc]init];
    tableViewCellConfigureBlock configureCell = ^(PhotoCell *cell,Photo *photo){
        [cell configurePhoto:photo];
    };
    
    self.dataSource = [[ArrayDataSource alloc]initWithItems:[self testPhotos] cellIdentifier:cellIdentifier configureCellBlock:configureCell];
    table.dataSource = self.dataSource;
    table.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadData];
}

#pragma mark - customApi

#pragma mark - nativeApi
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoViewController *photoVc = [[PhotoViewController alloc]init];
    photoVc.photo = [self.dataSource itemAtIndexPath:indexPath];
    [self.navigationController pushViewController:photoVc animated:YES];
}

#pragma mark - privateMethod
- (void)setup
{
    
}

- (void)loadData
{
    
}

#pragma mark - publicMethod

#pragma mark - property
@end
