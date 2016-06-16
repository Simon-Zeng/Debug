//
//  eLongCountryModel.h
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/21.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"

@protocol eLongCountryModel @end

@interface eLongCountryModel : eLongRequestBaseModel

/**
 *  国家名称
 */
@property (nonatomic, copy) NSString *countryName;

/**
 *  国家三字码
 */
@property (nonatomic, copy) NSString *countryID;

@end
