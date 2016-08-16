//
//  ViewController.m
//  objc-io
//
//  Created by wzg on 16/8/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()
@property (nonatomic, assign) NSUInteger foo;
@property (nonatomic, assign) NSUInteger bar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //尾调优化
//    dispatch_apply(5, dispatch_get_global_queue(0, 0), ^(size_t index) {
//        NSLog(@"%zu",index);
//    });
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^(){
        // Do something that takes a while
        [self doSomeFoo];
        dispatch_group_async(group, dispatch_get_main_queue(), ^(){
            self.foo = 42;
        });
    });
    dispatch_group_async(group, queue, ^(){
        // Do something else that takes a while
        [self doSomeBar];
        dispatch_group_async(group, dispatch_get_main_queue(), ^(){
            sleep(3);
            self.bar = 1;
        });
    });
    
    // This block will run once everything above is done:
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        NSLog(@"foo: %zi", self.foo);
        NSLog(@"bar: %zi", self.bar);
    });
    NSLog(@"呵呵哈哈哈");
}


- (void)doSomeFoo
{
    NSLog(@"doSomeFoo");
}

- (void)doSomeBar
{
    NSLog(@"doSomeBar");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
