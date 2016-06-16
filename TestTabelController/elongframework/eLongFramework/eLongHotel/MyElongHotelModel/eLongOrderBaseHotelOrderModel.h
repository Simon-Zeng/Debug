//
//  eLongOrderBaseHotelOrderModel.h
//  ElongClient
//  GetHotelOrderList HotelOrder
//  Created by myiMac on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//
#include <CoreGraphics/CoreGraphics.h>
#import "eLongResponseBaseModel.h"
#import "eLongOrderHotelOrderGuestModel.h"
#import "eLongOrderHotelContactorModel.h"
#import "eLongOrderThirdPartyPaymentInfoModel.h"
#import "eLongOrderVisualFlowItemModel.h"
#import "eLongOrderNewOrderStatusModel.h"
#import "eLongOrderStateRefundOrderOperationTraceInfo.h"
#import "eLongBackOrDiscount.h"

/**
 *  订单的取消状态
 */
typedef enum
{
    Unkown =0,
    Disable =1,     //1:不能取消
    Enable =2,      //2:可取消
    PhoneCancel =3, // 3:可电话取消
    
} eLongCancelStatus;

@protocol eLongOrderBaseHotelOrderModel @end
@interface eLongOrderBaseHotelOrderModel : eLongResponseBaseModel


/**
 *  此订单的订单号（又称ReserNo）
 */
@property (nonatomic,assign) NSInteger OrderNo;
/**
 *  订单所属卡号
 */
@property (nonatomic,copy) NSString *CardNumber;
/**
 *  创建时间
 */
@property (nonatomic,copy) NSString *CreateTime;
/**
 *  到达时间
 */
@property (nonatomic,copy) NSString *ArriveDate;
/**
 *  离开日期
 */
@property (nonatomic,copy) NSString *LeaveDate;
/**
 *  最早到达
 */
@property (nonatomic,copy) NSString *TimeEarly;
/**
 *  最晚到达
 */
@property (nonatomic,copy) NSString *TimeLate;
/**
 *  酒店地址
 */
@property (nonatomic,copy) NSString *HotelAddress;
/**
 *  酒店 Id
 */
@property (nonatomic,copy) NSString *HotelId;
/**
 *  酒店名称
 */
@property (nonatomic,copy) NSString *HotelName;
/**
 *  酒店名称英文
 */
@property (nonatomic,copy) NSString *HotelNameEn;
/**
 *  酒店名称中文
 */
@property (nonatomic,copy) NSString *HotelNameCN;
/**
 *  最近变更时间
 */
@property (nonatomic,copy) NSString *LatestChangeTime;
/**
 * 房间数量
 */
@property (nonatomic,assign) NSInteger RoomCount;
/**
 *  房型名称
 */
@property (nonatomic,copy) NSString *RoomTypeName;
/**
 * 订单状态
 */
@property (nonatomic,copy) NSString *StateCode;
/**
 *  总价
 */
@property (nonatomic,assign) CGFloat SumPrice;
/**
 *  担保类型
 */
@property (nonatomic,copy) NSString *VouchSet;
/**
 *  担保类型code
 */
@property (nonatomic,assign) NSInteger VouchSetCode;
/**
 *  是否可取消
 */
@property (assign) BOOL Cancelable;
/**
 *  订单的取消状态 1:不能取消 2:可取消 3:可电话取消
 */
@property (nonatomic,assign) eLongCancelStatus CancelStatus;
/**
 *  支付类型 0:前台现付 1:预付
 */
@property (nonatomic,assign) NSInteger Payment;
/**
 *  城市名
 */
@property (nonatomic,copy) NSString *CityName;
/**
 *  酒店电话
 */
@property (nonatomic,copy) NSString *HotelPhone;
/**
 *  订单联系人是否可以修改
 */
@property (assign) BOOL CanEditContactor;
/**
 *  订单入住人是否可以修改
 */
@property (assign) BOOL CanEditGuests;
/**
 * 酒店入住人列表
 */
@property (nonatomic,strong) NSArray<eLongOrderHotelOrderGuestModel> *Gutests;
/**
 *  酒店联系人
 */
@property (nonatomic,strong)eLongOrderHotelContactorModel* Contactor;
/**
 * 第三方支付信息
 */
@property (nonatomic,strong)eLongOrderThirdPartyPaymentInfoModel * ThirdPartyPaymentInfo;
/**
 *  订单产品是否能够被修改,只能修改成同一酒店下的产品，HotelId相同
 */
@property (assign) BOOL IsCanBeEdited;
/**
 *  是否可继续支付
 */
@property (assign) BOOL IsCanContinuePay;
/**
 *  酒店列表图片
 */
@property (nonatomic,copy) NSString *PicUrl;
/**
 *  优惠金额
 */
@property (nonatomic,assign) CGFloat  CounponAmount;
/**
 * 订单流信息
 */
@property (nonatomic,strong) NSArray<eLongOrderVisualFlowItemModel> *OrderVisualFlow;
/**
 *  承诺时间
 */
@property (nonatomic,copy) NSString *PromisedTime;
/**
 *  新订单状态及操作信息
 */
@property (nonatomic,strong) eLongOrderNewOrderStatusModel* NewOrderStatus;
/**
 *  新订单状态
 */
@property (nonatomic,copy) NSString *ClientStatusDesc;
/**
 *  某订单状态的小状态（状态细分 0:无状态 1：特殊满房-需同意安排 2：特殊满房-可反馈）
 */
@property (nonatomic,assign) NSInteger SubOrderStatusCode;
/**
 *  是否是新流程订单
 */
@property (assign) BOOL IsNewFlow;
/**
 *  mis回调url
 */
@property (nonatomic,copy) NSString *NotifyUrl;
/**
 *  支付订单金额
 */
@property (nonatomic,assign) CGFloat PayAmount;
/**
 *  请求交易号token
 */
@property (nonatomic,copy) NSString *TradeNo;
/**
 *  申请返现状态，1：可以申请，2：已申请，3：已返现，4：不显示
 */
@property (nonatomic,assign) NSInteger ApplyCouponStatus;
/**
 *  最晚到店时间是周几，这个字段只有未出行订单使用
 */
@property (nonatomic,copy) NSString *Zhouji;
/**
 *  退款金额(退款订单使用)
 */
@property (nonatomic,assign) CGFloat  RefundAmount;
/**
 *  退款提示(退款订单使用)
 */
@property (nonatomic,copy) NSString *RefundTip;
/**
 *  退款状态 (退款订单使用)：0：无退款 1：退款中 2：退款完毕
 */
@property (nonatomic,assign) NSInteger RefundStatus;
/**
 * 退款交易明细列表,退款状态可视化中交易明细
 */
@property (nonatomic,strong) eLongOrderStateRefundOrderOperationTraceInfo  *RefundOrderOperationTraceInfo;
/**
 * 判断是返现多少还是立减多少
 */
@property (nonatomic,strong) eLongBackOrDiscount *BackOrDiscount;
/**
 * 申请返现时是否需要传入经纬度
 */
@property (nonatomic,assign) BOOL IsNeedCoordinatesInfo;

// 以下是国际订单使用哦
/**
 *  与为出行订单保持一致,订单分类，1:国内酒店,4国际酒店.iphone8.9.0,andorid,8.9.0,winphone
 */
@property (nonatomic,assign)NSInteger OrderType;

/**
 *  oms订单号 取消订单使用
 */
@property (nonatomic,copy) NSString *OrderId;
/**
 *  说明类型“取消订单”“去支付”
 */
@property (nonatomic,copy) NSString *orderStr;

/**
 *  国际酒店入店日期
 */
@property (nonatomic, copy) NSString *CheckIn4IHotel;
/**
 *  国际酒店离店日期
 */
@property (nonatomic, copy) NSString *CheckOut4IHotel;
/**
 *  订单来源枚举,1-B2B国际酒店，2-国内Mis酒店，3-OMS国际酒店
 */
@property (nonatomic,copy) NSString *GlobalHotelOrderFrom;
/**
 *  取消订单政策  取消规则,7.7加入,目前是国际酒店用
 */
@property (nonatomic,copy) NSString *CancelPolicyDesc;
/**
 *  取消政策中文描述 命中当前时间的 国际酒店 -- 弹窗使用
 */
@property (nonatomic,copy) NSString *CancelSimplePolicy;
/**
 *  产品取消罚金,大于0-具体金额 ,等于0-免费取消，小于0-不可取消 国际酒店
 */
@property (nonatomic,assign)CGFloat BigDecimal;

/**
 *  优惠活动类型, 国际酒店使用
 */
@property (nonatomic, copy)NSString *ActivityType;

//  火车票相关字段
/**
 * 查询类型(待支付，未出行) 待支付=ToPay 未出行=ToTravel
 */
@property (nonatomic,copy) NSString *queryType;
/**
 * 业务线 05= 火车票 07 = 国际酒店 10 = 汽车票
 */
@property (nonatomic,copy) NSString *productLine;
/**
 * 预关单时间(时间格式:2015-01-01 00:00:00)
 */
@property (nonatomic,copy) NSString *preCloseTime;
/**
 * 支付订单号
 */
@property (nonatomic,copy) NSString *gorderId;
/**
 * 供应商订单号(未出行有值)
 */
@property (nonatomic,copy) NSString *merchantOrderId;
/**
 * 订单状态 0=待支付 1=出票中 2 =出票成功
 */
@property (nonatomic,copy) NSString *orderStatus;
/**
 *  火车车次
 */
@property (nonatomic, copy)NSString *trainNumber;
/**
 * 火车开车时间
 */
@property (nonatomic,copy) NSString *trainStartTime;
/**
 * 火车起始站名称
 */
@property (nonatomic,copy) NSString *startStationName;
/**
 * 火车终点站名称
 */
@property (nonatomic,copy) NSString *endStationName;
/**
 * 火车站到站时间
 */
@property (nonatomic,copy) NSString *trainStopTime;
/**
 * int	1=是艺龙订单, 0=12306订单
 */
@property (nonatomic,assign) NSInteger elongOrderFlag;
/**
 * 座位类型
 */
@property (nonatomic,copy) NSString *seatTypeName;
/**
 *  票数
 */
@property (nonatomic, assign) NSInteger ticketNum;
/**
 * bus起始城市
 */
@property (nonatomic,copy) NSString *busStartCityName;
/**
 * bus终点城市
 */
@property (nonatomic,copy) NSString *busDestCityName;
/**
 * bus发车时间
 */
@property (nonatomic,copy) NSString *busStartTime;
/**
 * bus车型
 */
@property (nonatomic,copy) NSString *busType;
/**
 *  bus车次
 */
@property (nonatomic, copy) NSString *busNumber;
/**
 * bus发车车站名称
 */
@property (nonatomic,copy) NSString *busStartStationName;
/**
 * bus终点车站名称
 */
@property (nonatomic,copy) NSString *destStationName;
/**
 *  1=是黄牛 0=不是黄牛    1
 */
@property (nonatomic, assign) NSInteger huangniuFlag;

/**
 *  "代理类型编号"
 */
@property (nonatomic, assign) NSInteger oTAProductSourceType;
/**
 *  "代理类型名称"
 */
@property (nonatomic, copy) NSString *oTAProductSourceName;

@end
