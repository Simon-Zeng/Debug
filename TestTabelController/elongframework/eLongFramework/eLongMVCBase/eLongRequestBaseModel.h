//
//  eLongRequestBaseModel.h
//  ElongClient
//
//  Created by Dawn on 14-12-31.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface eLongRequestBaseModel : JSONModel
/**
 *  整合请求参数
 *
 *  @return 请求参数字典
 */
- (NSDictionary *) requestParams;
/**
 *  网络请求的业务地址：myelong/getHotelFavorites... etc.
 *
 *  @return 网络请求业务地址
 */
- (NSString *)requestBusiness;
@end
