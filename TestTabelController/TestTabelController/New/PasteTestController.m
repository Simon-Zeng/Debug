//
//  PasteTestController.m
//  TestTabelController
//
//  Created by wzg on 16/8/2.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "PasteTestController.h"
#import "PasteBoard.h"
#import "SDAutoLayout.h"
#import "BaseMarco.h"

@interface PasteTestController()
@property (nonatomic, strong)UIButton *btn1;
@property (nonatomic, strong)UILabel *show;
@end

@implementation PasteTestController
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
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = LRRandomColor;
    btn.layer.cornerRadius = 9;
    [btn setTitle:@"粘贴板" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pasteContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn.sd_layout
    .widthIs(100)
    .heightIs(100)
    .topSpaceToView(self.view,200)
    .centerXEqualToView(self.view);
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = LRRandomColor;
    btn1.layer.cornerRadius = 9;
    [btn1 setTitle:@"动画" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    btn1.sd_layout
    .widthIs(100)
    .heightIs(100)
    .bottomSpaceToView(self.view,50)
    .centerXEqualToView(self.view);
    self.btn1 = btn1;
    
    self.show = [UILabel new];
    self.show.textColor = LRRandomColor;
    self.show.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.show];
    
    self.show.sd_layout.autoHeightRatio(0).topSpaceToView(self.view,20).centerXEqualToView(self.btn1);
}

- (void)loadData
{
    
}

#pragma aciton
- (void)pasteContent:(UIButton *)btn
{
    PasteBoard *paste = [[PasteBoard alloc]init];
    NSString *str = paste.content;
    self.show.text = str;
    NSLog(@"%@",str);
    
    [self.show updateLayout];
}

- (void)animate:(UIButton *)btn
{
    [UIView animateWithDuration:1.0 animations:^{
        self.btn1.sd_layout.leftSpaceToView(self.view,20);
        [self.btn1 updateLayout];
    }];
}

#pragma mark - publicMethod

#pragma mark - property
@end
