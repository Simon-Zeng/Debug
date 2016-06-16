//
//  eLongHotelDetailProductModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongHotelDetailPriceModel.h"
#import "eLongHotelDetailProductTagModel.h"
#import "eLongHotelDetailProductPromotionModel.h"
#import "eLongHotelDetailHoldingTimeModel.h"
#import "eLongHotelDetailVouchSetModel.h"
#import "eLongHotelDetailPrepayRuleModel.h"
#import "eLongHotelDetailVouchAddedModel.h"
#import "eLongHotelDetailProductDayPriceModel.h"

@protocol eLongHotelDetailProductModel @end
@interface eLongHotelDetailProductModel : eLongResponseBaseModel
/**
 *  产品Id hotelId_roomId_rpId
 */
@property (nonatomic,copy) NSString *ProductId;
/**
 *  roomId
 */
@property (nonatomic,copy) NSString *RoomId;
/**
 *  客房定价规则 Id
 */
@property (nonatomic,assign) NSInteger RatePlanId;
/**
 *  ProductName
 */
@property (nonatomic,copy) NSString *ProductName;
/**
 *  SHotelId
 */
@property (nonatomic,copy) NSString *SHotelId;
/**
 *  产品价格
 */
@property (nonatomic,strong) eLongHotelDetailPriceModel *PriceInfo;
/**
 *  每日价格明细
 */
@property (nonatomic,strong) NSArray <eLongHotelDetailProductDayPriceModel> *DayPrices;
/**
 *  取消类型 0:免费取消 1:限时取消 2:不可取消
 */
@property (nonatomic,assign) NSInteger CancelType;
/**
 *  房间最多可定量（取当前房型可定量的最小值，当最小值小于5时显示最小值，大于5时为-1
 */
@property (nonatomic,assign) NSInteger MinStocks;
/**
 *  首日最少入住房量
 */
@property (nonatomic,assign) NSInteger MinCheckInRooms;
/**
 *  即时房量（如果是多天，就是最小的房量), -1:即时不限量;0:非即时; >0:即时房量
 */
@property (nonatomic,assign) NSInteger OnTimeConfirmAmount;
/**
 *  是否即使可确认房型
 */
@property (nonatomic,assign) BOOL IsOnTimeConfirm;
/**
 *  即时可确认房型订购提示
 */
@property (nonatomic,copy) NSString *ImmediatelyPrompt;
/**
 *  是否可预订
 */
@property (nonatomic,assign) BOOL IsAvailable;
/**
 *  需要英文名
 */
@property (nonatomic,assign) BOOL NeedEnName;
/**
 *  会员等级 4:龙萃
 */
@property (nonatomic,assign) NSInteger MemberLevel;
/**
 *  标签
 */
@property (nonatomic,strong) NSArray<eLongHotelDetailProductTagModel> *Tags;
/**
 *  促销大标
 */
@property (nonatomic,strong) NSArray<eLongHotelDetailProductTagModel,Optional> *productBigTag;
/**
 *  支付类型：到店付款0，预付1
 */
@property (nonatomic,assign) NSInteger PayType;
/**
 *  开发票方式（开发票方式（0表示没维护,1表示艺龙开发票,2表示酒店开发票）
 */
@property (nonatomic,assign) NSInteger InvoiceMode;
/**
 *  促销信息, coupon及红包
 */
@property (nonatomic,strong) NSArray<eLongHotelDetailProductPromotionModel> *Promotions;
/**
 *  房间保留时间选项
 */
@property (nonatomic,strong) NSArray<eLongHotelDetailHoldingTimeModel> *HoldingTimeOptions;
/**
 *  担保规则
 */
@property (nonatomic,strong) eLongHotelDetailVouchSetModel *VouchSet;
/**
 *  预付规则
 */
@property (nonatomic,strong) NSArray<eLongHotelDetailPrepayRuleModel> *PrepayRules;
/**
 *  担保规则（附加） 关心无罚金取消时间，罚金金额，冻结金额
 */
@property (nonatomic,strong) eLongHotelDetailVouchAddedModel *VouchAdded;
/**
 *  是否周边价产品
 */
@property (nonatomic,assign) BOOL IsAroundSale;
/**
 *  是否首晚五折
 */
@property (nonatomic,assign) BOOL  IsFirstTimeHalf;
/**
 *  是否满减
 */
@property (nonatomic,assign) BOOL  IsFullCutRoom;
/**
 *  首晚五折显示标签
 */
@property  (nonatomic,copy) NSString  *FirstTimeHalfTag;
/**
 *  是否是预付五折房型
 */
@property (nonatomic,assign) BOOL IsDiscountRoom;
/**
 *  房间送礼信息
 */
@property (nonatomic,copy) NSString *GiftDescription;
/**
 *  折扣数量
 */
@property (nonatomic,assign) NSInteger DiscountPercent;
/**
 *  早餐份数
 */
@property (nonatomic,assign) NSInteger BreakfastNum;
/**
 *  判断产品默认是否展示
 */
@property (nonatomic,assign) BOOL Visible;

@end
