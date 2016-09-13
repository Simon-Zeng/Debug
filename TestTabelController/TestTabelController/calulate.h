//
//  calulate.h
//  TestTabelController
//
//  Created by wzg on 16/8/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class calulate;



#import "myMath.h"

@interface calulate : myMath


typedef calulate *(^add)(CGFloat);
typedef calulate *(^reduce)(CGFloat);
typedef calulate *(^multiply)(CGFloat);
typedef calulate *(^division)(CGFloat);

@property (nonatomic, assign) CGFloat result;
@property (nonatomic, assign) CGFloat lastResult;

@property (nonatomic, strong,readonly)add withAdd;
@property (nonatomic, strong,readonly)reduce withreduce;
@property (nonatomic, strong,readonly)multiply withmultiply;
@property (nonatomic, strong,readonly)division withdivision;

//calulate *mockCalulate(CGFloat initialize);

- (void)testMethod;
@end


#ifdef __cplusplus
extern "C" {
#endif
    calulate *mockCalulate(CGFloat initialize);
    
#ifdef __cplusplus
}
#endif
