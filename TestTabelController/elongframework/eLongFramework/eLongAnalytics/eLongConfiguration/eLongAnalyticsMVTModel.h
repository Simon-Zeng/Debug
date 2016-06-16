//
//  eLongAnalyticsMVTModel.h
//  eLongFramework
//
//  MVT moldel
//
//  Created by zhaoyingze on 15/12/21.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "JSONModel.h"

@interface eLongAnalyticsMVTModel : JSONModel

/**
 *  实验名称
 */
@property (nonatomic, copy) NSString *expName;

/**
 *  实验id
 */
@property (nonatomic, copy) NSString *expId;

/**
 *  mvt值
 */
@property (nonatomic, copy) NSString *mvtValue;

/**
 *  变量id
 */
@property (nonatomic, copy) NSString *varId;

/**
 *  变量名称
 */
@property (nonatomic, copy) NSString *varName;

@end
