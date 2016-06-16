//
//  eLongResponseBaseModel.h
//  ElongClient
//
//  Created by Dawn on 14-12-31.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "JSONModel.h"

@interface eLongResponseBaseModel : JSONModel
@property (nonatomic, assign) BOOL IsError;
/**
 *  报错信息
 */
@property (nonatomic, copy) NSString *ErrorMessage;
/**
 *  错误码
 */
@property (nonatomic, copy) NSString *ErrorCode;
@end
