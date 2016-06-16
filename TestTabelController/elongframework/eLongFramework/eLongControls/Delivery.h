//
//  Delivery.h
//  ElongClient
//
//  Created by Harry Zhao on 3/17/15.
//  Copyright (c) 2015 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongRequestBaseModel.h"
#import "eLongResponseBaseModel.h"

typedef enum {
    NotNeed,
    Post,
    SelfGet,
    Others
} TicketGetType;

@protocol DeliveryAddress @end
@interface DeliveryAddress : eLongResponseBaseModel
/**
 *  地址 Id
 */
@property (nonatomic, assign) NSInteger Id;
/**
 *  地址信息
 */
@property (nonatomic, strong) NSString *AddressContent;
/**
 *  邮政编码
 */
@property (nonatomic, strong) NSString *Postcode;
/**
 *  联系人姓名
 */
@property (nonatomic, strong) NSString *Name;
/**
 *  联系人手机
 */
@property (nonatomic, strong) NSString *PhoneNo;

@property (nonatomic,assign) BOOL selected;

@end

@interface Delivery : eLongRequestBaseModel
/**
 *  取票类型
 */
@property (nonatomic, assign) TicketGetType TicketGetType;
/**
 *  备注
 */
@property (nonatomic, strong) NSString *Memo;
/**
 *  地址
 */
@property (nonatomic, strong) DeliveryAddress<Optional> *Address;
/**
 *  自取地址Id
 */
@property (nonatomic, assign) NSInteger SelfGetAddressID;
/**
 *  自取地址
 */
@property (nonatomic, strong) NSString<Optional> *SelfGetAddress;
/**
 *  自取时间
 */
@property (nonatomic, strong) NSString<Optional> *SelfGetTime;
/**
 *  发票抬头
 */
@property (nonatomic, copy)   NSString *invoiceTitle;
@end
