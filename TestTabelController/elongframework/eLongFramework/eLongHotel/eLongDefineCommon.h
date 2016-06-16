/*
 *  eLongDefineCommon.h
 *  ElongClient
 *
 *  Created by bin xing on 11-3-5.
 *  Copyright 2011 DP. All rights reserved.
 *
 */

#define Resp_IsError @"IsError"
#define Resp_ErrorMessage @"ErrorMessage"

#define Resq_HeaderChannelId @"ChannelId"
#define Resq_HeaderDeviceId @"DeviceId"
#define Resq_HeaderAuthCode @"AuthCode"
#define Resq_HeaderClientType @"ClientType"
#define Resq_CardNo @"CardNo"

#define JSON_NULL	 [NSNull null]
#define JSON_YES	 [NSNumber numberWithBool:YES]
#define JSON_NO	 [NSNumber numberWithBool:NO]
#define EmptyString	 @""
#define Zero	[NSNumber numberWithInt:0]
#define NegativeOne	[NSNumber numberWithInt:-1]
#define ELONGDATE	@"/Date(%.f)/"

// =======================================================================================================
// 酒店查询字段
#define DATANAME_HOTEL				@"DataName"
#define NAME_HOTEL                  @"Name"
#define THEMENAMECN_HOTEL           @"ThemeNameCn"
#define APIID_HOTEL                 @"ApiId"
#define MISID_HOTEL                 @"MisId"
#define THEMEID_HOTEL               @"ThemeId"
#define DATAID_HOTEL				@"DataID"
#define LOCATIONLIST_HOTEL			@"LocationList"
#define THEMELIST_HOTEL             @"ThemeList"
#define ADDITONINFOLIST_HOTEL		@"AdditionInfoList"
#define ARRIVE_TIME_RANGE			@"ArriveTimeRange"
#define TYPEID_HOTEL				@"TypeID"
#define TAGID_HOTEL					@"TagID"
#define TAGNAME_HOTEL				@"TagName"
#define AIRPORT_RAILWAY_TAG_INFOS	@"AirportRailwayTagInfos"
#define COMMERCIAL_HOTEL			@"Commercial"
#define DISTRICT_HOTEL				@"District"
#define HOTEL_LIST                  @"HotelList"
#define HOTELBRAND_HOTEL			@"HotelBrand"
#define CHAINHOTEL_HOTEL            @"ChainHotel"
#define HOTEL_ADDRESS				@"HotelAddress"
#define HOLDING_TIME_OPTIONS        @"HoldingTimeOptions"
#define GUEST_NAME					@"GuestName"
#define GHHOTEL_ROOM_INFOLIST       @"GHHotelRoomInfoList"
#define AIRPORT_RAILWAY				@"Airport/Railway"
#define ROOMS                       @"Rooms"
#define	ROOMTYPEID					@"RoomTypeId"
#define SHotelID                    @"SHotelID"
#define ROOMTYPENAME				@"RoomTypeName"
#define	RATEPLANID					@"RatePlanId"
#define	VOUCHSET					@"VouchSet"
#define SUBWAY_STATION				@"Subway Station"
#define SUBWAYSTATION_TAG_INFOS		@"SubwayStationTagInfos"
#define HOTELFACILITYS              @"HotelFacilitys"
#define PICURL_HOTEL				@"PicUrl"
#define HOTEL_IMAGE_ITEMS           @"HotelImageItems"
#define AREA_LIMITED_NONE			@"区域不限"
#define BRAND_LIMITED_NONE			@"品牌不限"
#define THEME_LIMITED_NONE          @"主题不限"
#define THEME_APARTMENT             @"公寓"
#define FACILITY_LIMITED_NONE       @"设施不限"
#define STAR_LIMITED_NONE			@"星级不限"
#define PRICE_LIMITED_NONE			@"价格不限"
#define ORDER_LIMITED_NONE			@"默认排序"
#define PAYINHOTEL_TYPE				@"前台自付"
#define HAVE_COUPON_STR				@"可使用消费券"
#define NO_VOUCH_STR				@"免担保"
#define STAR_LIMITED_FIVE			@"五星/豪华"
#define STAR_LIMITED_FOUR			@"四星/高档"
#define STAR_LIMITED_THREE			@"三星/舒适"
#define STAR_LIMITED_OTHER			@"经济"
#define ORDER_FILL_ALERT			@"关闭界面将丢失填写数据,\n是否确认？"
#define LOADINGTIPSTRING            @"正在加载，请稍候"
#define CANT_TEL_TIP				@"当前设备不支持通话功能"
#define MAX_HOTEL_COUNT				100			// 酒店列表最大容量
#define HOTEL_PAGESIZE				15			// 每页酒店请求数


#define USERDEFAULT_HTTPMONITOR_USERTRACEID         @"HTTPMONITOR_USERTRACEID"      //网络监控中 UserTraceID的宏定义

