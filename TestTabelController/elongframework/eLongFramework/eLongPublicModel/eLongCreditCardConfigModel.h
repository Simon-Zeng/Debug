//
//  eLongCreditCardConfigModel.h
//  eLongFramework
//
//  Created by lina on 15/12/15.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongCreditCardConfigModel : NSObject
/**
 *  业务线 国内酒店1005默认
 */
@property (nonatomic, strong) NSNumber *bussinessType;
+ (id)shared;

@end
