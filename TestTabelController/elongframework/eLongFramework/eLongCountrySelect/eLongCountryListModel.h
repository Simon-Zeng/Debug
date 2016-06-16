//
//  eLongCountryListModel.h
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/21.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"
#import "eLongCountryModel.h"

@interface eLongCountryListModel : eLongRequestBaseModel

/**
 *  数据版本
 */
@property (nonatomic, copy) NSString *dataVersion;
/**
 *  是否需要更新数据
 */
@property (nonatomic, assign) BOOL isNeedUpdata;
/**
 *  国家列表
 */
@property (nonatomic, strong) NSArray<eLongCountryModel> *countryList;

@end
