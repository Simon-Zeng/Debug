//
//  MyElongFileDefine.h
//  MyElong
//
//  Created by zhaolina on 15/9/23.
//  Copyright © 2015年 lvyue. All rights reserved.
//

#import "NSArray+CheckArray.h"
#import "NSDictionary+CheckDictionary.h"
#import "NSMutableArray+SafeForObject.h"
#import "NSMutableDictionary+SafeForObject.h"
#import "NSObjectCommonCheck.h"
#import "NSObject+Encoding.h"
#import "eLongSingletonDefine.h"
#import "UIView+TipMessage.h"
#import "UIApplication+openURL.h"
#import "NSString+Convert.h"
#import "eLongDefine.h"
#import "eLongExtension.h"
#import "eLongBus.h"
#import "eLongUserDefault.h"
#import "eLongCommonDefine.h"

#ifndef MyElongFileDefine_h
#define MyElongFileDefine_h

#define REGISTPAYERTIMESPAN     120   //修改支付密码倒计时限制
#define STATUS_BAR_HEIGHT		20

#define NOTI_CASHACCOUNT_SETPASSWORDSUCCESS     @"NOTI_CASHACCOUNT_SETPASSWORDSUCCESS"  // 现金账户设置密码成功
#define NOTI_ORDER_MODIFY                       @"NOTI_ORDER_MODIFY"                    // 修改订单成功

#define NOTI_RECOMMENDCHANGED                   @"NOTI_RECOMMENDCHANGED"                // 酒店点评数量发生变化
#define NOTI_USERCENTERCOUNTUPDATE              @"NOTI_USERCENTERCOUNTUPDATE"           // 点评、可反馈酒店、消
#define NOTI_REDPACKETCHANGED                   @"NOTI_REDPACKETCHANGED"                // 红包数量发生变化
#define NOTI_COMMENT_SUCESS_IHOTEL_REFRESH                   @"NOTI_COMMENT_SUCESS_IHOTEL_REFRESH"        // 点评成功国际酒店刷新


#define NOTI_FINDFAVOURITE_ISEMPTY          @"NOTI_FINDFAVOURITE_ISEMPTY"

#define NOTI_FINDEDIT_REFRESH               @"NOTI_FINDEDIT_REFRESH"
#define NOTI_FINDFAVLIST_REFRESH            @"NOTI_FINDFAVLIST_REFRESH"

#define NOTI_HOTELCOMMENT_DIDCLICK              @"NOTI_HOTELCOMMENT_DIDCLICK"             //酒店点评提交页返回
#define CARD_NUMBER					@"CardNo"
#define CREATETIME					@"CreateTime"
#define LOCATION_NAME               @"LocationName"
#define DISTINCTID_REQ				@"DistinctID"

#define HOTEL_STATE_CODE			@"HotelStateCode"
#define HOTEL_STATE_NAME			@"HotelStateName"

#define HOTEL_ORDER_CREATE_TIME		@"HotelOrderCreateTime"

#define ISNEEDADDINFO_REQ			@"IsNeedAddinfo"

#define IMAGE_SIZE_TYPE             @"ImageSizeType"
#define MINPRICE_REQ				@"MinPrice"
#define MAXPRICE_REQ				@"MaxPrice"
#define ORDERS						@"Orders"

#define ORDERNO_REQ					@"OrderNo"
#define ORDERSTATUSINFOS			@"OrderStatusInfos"
#define PAGE_SIZE_					@"PageSize"
#define PAGE_INDEX					@"PageIndex"

#define SEARCH_TYPE					@"SearchType"

#define SORTTYPE_REQ				@"SortType"
#define STATE_CODE					@"StateCode"
#define CLIENTSTATUSDESC        @"ClientStatusDesc"

#define STARCODE_REQ				@"StarCode"
#define STATENAME					@"StateName"
#define TOTALCOUNT					@"TotalCount"

#define U_R_L                       @"Url"
#define BIZSECTIONID_REQ			@"BizSectionID"

#define ADDRESS_ADD_NOTIFICATION	@"Address_Add"
#define INVOICE_ADD_NOTIFICATION    @"invoice_add"
#define ADDRESS_MODIFY_NOTIFICATION	@"Address_modify"
#define INVOICE_MODITY_NOTIFICATION	@"invoice_modify"
#define ADDRESS_DELETE_NOTIFICATION	@"Address_delete"
#define INVOICE_DELETE_NOTIFICATION	@"invoice_delete"
#define INVOICE_CHOOSE_NOTIFICATION @"invoice_choose"
#define ADDRESS_CHOOSE_NOTIFICATION @"address_choose"
#define NOTI_HOTELCOMMETN_DRAFT                 @"NOTI_HOTELCOMMETN_DRAFT"             //
#define KEY_ADDRESSES				@"Addresses"
#define KEY_ADDRESS_CONTENT					@"AddressContent"				//地址内容
#define KEY_ID						@"Id"
#define NOTI_GET_TOKEN                          @"NOTI_GET_TOKEN"
#define NOTI_HOTEL_FEEDBACK                     @"NOTI_HOTEL_FEEDBACK"    

#define APP_VALUE                   @"AppValue"
#define SFRelease(obj)			[obj release]; obj = nil

//是否打开信用卡安全与优化
#define SSCreditCardSafeAndOptimizeEnabled 1
#define	IS_VOER_DUE					@"IsOverdue"
#define APPTYPE     @"1"
#define NOTI_CASHACCOUNT_RECHARGE               @"NOTI_CASHACCOUNT_RECHARGE"            // 现金账户充值成功
#define NOTI_GROUPFAVORITE_ISEMPTY              @"NOTI_GROUPFAVORITE_ISEMPTY"        //团购收藏全部删除之后的通知
#define NOTI_HOTELFAVORITE_ISEMPTY              @"NOTI_HOTELFAVORITE_ISEMPTY"           //酒店收藏全部删除之后的通知
//酒店点评草稿箱返回通知
#define NOTI_HOTELORDER_UPDATEINVOICEINFO       @"NOTI_HOTELORDER_UPDATEINVOICEINFO"         //修改或新增发票信息更新订单信息的通知
#define NOTI_INVOICE_MOTIFY_SUCCESS             @"NOTI_INVOICE_MOTIFY_SUCCESS"               //个人中心修改发票提交成功
#define NOTI_INVOICE_ADD_SUCCESS                @"NOTI_INVOICE_ADD_SUCCESS"                   //个人中心新增发票提交成功
#define NOTI_MYELONG_ORDER_REBATE_LIST_CHANGED  @"NOTI_MYELONG_ORDER_REBATE_LIST_CHANGED"     //个人中心申请返现成功返回刷新返现列表通知
//我的钱包字典字段
#define MY_WALLET_CASHDETAILDIC @"cashDetailDic"
//点评跳转记录
#define  APPComment   @"appcomment"
#define  RedExtraIsCheck  @"RedExtraIsCheck"  //红包余额没被查
#define  NOTI_CASHACCOUNT_CHANGED               @"NOTI_CASHACCOUNT_CHANGED"             //现金账户余额发生变化
//我的钱包字典字段
#define MY_WALLET_CASHDETAILDIC @"cashDetailDic"
#define  NOTI_CASHACCOUNT_REDPACKET             @"NOTI_CASHACCOUNT_REDPACKET"           //红包充值
#define NOTI_LONGVIP                            @"NOTI_LONGVIP"

#define NOTI_LOGOUTUOACTION        @"NOTI_LOGOUTUOACTION"   //注销 个人中心用

#define NOTI_LOGOUTUOACTION_ALL        @"NOTI_LOGOUTUOACTION_ALL"   //注销 各个业务线用

// 团购常用字段
#define ADDRESS_GROUPON				@"Address"
#define CITYNAME_GROUPON			@"CityName"
#define CITYID_GROUPON				@"CityID"

#define KEY_NAME				@"Name"				//姓名
#define KEY_ADDRESS_CONTENT		@"AddressContent"	//地址内容
#define KEY_ADDRESSES			@"Addresses"		//邮寄地址
#define KEY_ID					@"Id"				//id
#define HOTELNAME_GROUPON			@"HotelName"

// 订单填写时缓存用户信息字段
#define NONMEMBER_PHONE                 @"nonmember_phone"
#define NONMEMBER_EMAIL                 @"nonmember_email"
#define NONMEMBER_CREDITCARD            @"nonmember_creditcard"
#define NONMEMBER_POSTADDRESS           @"nonmember_postaddress"
#define NONMEMBER_CHECKINPEPEOS         @"nonmember_checkinpepeos"
#define NONMEMBER_CHECKINTIME           @"nonmenber_checkintime"
#define NONMEMBER_HOTEL_ORDERS          @"nonmember_hotel_orders"
#define NONMEMBER_FLIGHT_ORDERS         @"nonmember_flight_orders"
#define NONMEMBER_INTERFLIGHT_ORDERS         @"nonmember_interflight_orders"
#define NONMEMBER_GROUPON_ORDERS        @"nonmember_groupon_orders"
#define NONMEMBER_TRAIN_ORDERS          @"NONMEMBER_TRAIN_ORDERS"
#define NONMEMBER_ROOMNUM               @"nonmenber_roomnum"
#define HIDE_ORDER_LIST                 @"hide_order_list"
#define RECORD_TRAIN_PASSAGERS          @"RECORD_TRAIN_PASSAGERS"
#define RECORD_TRAIN_PASSAGERS_COUNT    @"RECORD_TRAIN_PASSAGERS_COUNT"
#define RECORD_TRAIN_RECORDTIME         @"RECORD_TRAIN_RECORDTIME"
#define RECORD_TRAIN_PASSENGERS_INFO    @"RECORD_TRAIN_PASSENGERS_INFO"

#define ORDERID_GROUPON				@"OrderID"
// 列车查询常用字段
#define Resq_Header					@"Header"
#define PRODID_GROUPON				@"ProdId"

#define MAX_PAGESIZE_GROUPON		20
#define MAX_ONEPAGE_GROUPON         60
#define MAX_PAGESIZE_HOTEL          25
//typedef enum {
//    //by杨泽2014.12.1
//    UserCenterItemTypeHotelComment,
//    UserCenterItemTypeGrouponComment,
//    UserCenterItemTypeFeedback,
//    UserCenterItemTypeJCard,
//    UserCenterItemTypeJCustomer,
//    UserCenterItemTypeJGetAddress,
//    UserCenterItemTypeMore,
//    
//    
//    
//    UserCenterItemTypeHotelOrder,
//    UserCenterItemTypeInterHotelOrder,
//    UserCenterItemTypeC2COrder,
//    UserCenterItemTypeGrouponOrder,
//    UserCenterItemTypeFlightOrder,
//    UserCenterItemTypeInterFlightOrder,
//    UserCenterItemTypeTrainOrder,
//    UserCenterItemTypeTaxiOrder,
//    UserCenterItemTypeCarOrder,
//    UserCenterItemTypeCommenInfo,
//    UserCenterItemTypeFavHotel,
//    UserCenterItemTypeFavGroupon,
//    UserCenterItemTypeBusOrder
//}UserCenterItemType;

#define GET_NATIVE_HOTEL_ORDER 2

#define GET_GROUPON_ORDER 4
#define PRODNAME_GROUPON			@"ProdName"
#define SALENUMS_GROUPON			@"SaleNums"
#define SALEPRICE_GROUPON			@"SalePrice"
#define SHOWPRICE_GROUPON			@"ShowPrice"
#define SALENUMS_GROUPON			@"SaleNums"
#define MOBILEPRODUCTTYPE_GROUPON   @"MobileProductType"
/*****************************************************************************************/
#define ReqHS_CityName_S			@"CityName"
#define ReqHS_CityID_S              @"CityID"
#define ReqHS_AreaId_S			    @"AreaId"
#define ReqHS_AreaType_s            @"AreaType"
#define ReqHS_AreaName_S			@"AreaName"
#define ReqHS_HotelName_S			@"HotelName"
#define ReqHS_IntelligentSearchText @"IntelligentSearchText"
#define ReqHS_HotelBrandID			@"HotelBrandID"
#define ReqHS_MutilpleFilter		@"MutilpleFilter"
#define ReqHS_FacilitiesFilter      @"FacilitiesFilter"
#define ReqHS_ThemesFilter          @"ThemesFilter"
#define ReqHS_NumbersOfRoom         @"NumbersOfRoom"
#define ReqHS_PriceLevel            @"PriceLevel"
#define ReqHS_HighestPrice_I		@"HighestPrice"
#define ReqHS_LowestPrice_I			@"LowestPrice"
#define ReqHS_Radius_D				@"Radius"
#define ReqHS_MemberLevel           @"MemberLevel"
#define ReqHS_CheckInDate_ED		@"CheckInDate"
#define ReqHS_CheckOutDate_ED		@"CheckOutDate"
#define ReqHS_StarCode_I			@"StarCode"
#define ReqHS_OrderBy_I				@"OrderBy"
#define ReqHS_IsPositioning_B		@"IsPositioning"
#define ReqHS_Longitude_B			@"Longitude"
#define ReqHS_Latitude_B			@"Latitude"
#define ReqHS_PageSize_I			@"PageSize"
#define ReqHS_PageIndex_I			@"PageIndex"
#define ReqHS_TonightPageIndex_I    @"TPageIndex"
#define ReqHS_Filter				@"Filter"
#define ReqHS_IsApartment  @"IsApartment"
#define ReqHS_SEARCHGPS				@"IsSearchAgain"
#define ReqHS_VIP                   @"IsVIPSelected"
#define ReqHS_SearchType            @"SearchType"
#define ReqHS_IsAroundSale          @"IsAroundSale"

#endif /* MyElongFileDefine_h */
