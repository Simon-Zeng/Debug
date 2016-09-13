//
//  calulate.m
//  TestTabelController
//
//  Created by wzg on 16/8/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "calulate.h"

@interface calulate()
@end


@implementation calulate
- (add)withAdd
{
    return ^(CGFloat y){
        self.lastResult = self.result;
        self.result = y + self.result;
        return self;
    };
}

- (add)withreduce
{
    return ^(CGFloat y){
        self.lastResult = self.result;
        self.result = self.result - y;
        return self;
    };
}

- (add)withmultiply
{
    return ^(CGFloat y){
        self.lastResult = self.result;
        self.result = y * self.result;
        return self;
    };
}

- (add)withdivision
{
    return ^(CGFloat y){
        self.lastResult = self.result;
        self.result = self.result/y;
        return self;
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"result--%f,lastR---%f",self.result,self.lastResult];
}

-(void)testMethod
{
    NSLog(@"进入子类");
}

@end

calulate *mockCalulate(CGFloat initialize){
    calulate *obj = [[calulate alloc]init];
    obj.lastResult = initialize;
    obj.result = initialize;
    return obj;
}