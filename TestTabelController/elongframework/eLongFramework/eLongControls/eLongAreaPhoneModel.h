//
//  eLongAreaPhoneModel.h
//  ElongClient
//
//  Created by nieyun on 15-1-4.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongBaseModel.h"

@interface eLongAreaPhoneModel : eLongBaseModel
@property  (nonatomic,copy) NSString  *acCode;
@property  (nonatomic,copy) NSString  *acDsc;
@property  (nonatomic,copy) NSNumber  *language;
@property  (nonatomic,copy) NSString  *regRule;
@property  (nonatomic,copy) NSNumber  *length;
@property  (nonatomic,assign) NSInteger  numCount;
@end
