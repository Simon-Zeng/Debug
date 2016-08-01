//
//  SearchTestVc.m
//  TestTabelController
//
//  Created by wzg on 16/8/1.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "SearchTestVc.h"
#import "SDAutoLayout.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define stringFromNum(x) [NSString stringWithFormat:@"%zi",x]

@interface SearchTestVc()
@property (nonatomic, strong)UIView *mainView;
@property (nonatomic, strong)UIView *table;
@end

@implementation SearchTestVc
#pragma mark - lifeCycle
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadData];
}

#pragma mark - customApi

#pragma mark - nativeApi

#pragma mark - privateMethod
- (void)setup
{
    self.mainView = [[UIView alloc]init];
    [self.view addSubview:self.mainView];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"添加search" style:UIBarButtonItemStylePlain target:self action:@selector(addSearch)];
    [self.navigationController.navigationItem setRightBarButtonItem:rightBarItem];
}

- (void)loadData
{
    
}

- (void)layoutMain
{

}

- (void)addSearch
{
    NSUInteger random = rand();
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    CSSearchableItemAttributeSet *set = [[CSSearchableItemAttributeSet alloc]initWithItemContentType:(NSString *)kUTTypeImage];
    set.title = [NSString stringWithFormat:@"标题%zi",random];
    set.keywords = @[@"审批",@"发送"];
    set.displayName = @"关于审批的内容";
    set.contentDescription = @"审批的内容";
    set.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"chatIcon_schedule"]);
    
    CSSearchableItem *item = [[CSSearchableItem alloc]initWithUniqueIdentifier:stringFromNum(random) domainIdentifier:@"test-id" attributeSet:set];
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:[NSArray arrayWithObjects:item, nil] completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"索引失败%@",error.localizedDescription);
        }else{
            
        }
    }];
#endif
}

#pragma mark - publicMethod

#pragma mark - property

@end
