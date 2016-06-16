//
//  eLongHotelDetailPrepayRuleModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongHotelDetailPrepayRuleModel @end
@interface eLongHotelDetailPrepayRuleModel : eLongResponseBaseModel
/**
 *  预付规则描述
 */
@property (nonatomic,copy) NSString *Description;
@end
