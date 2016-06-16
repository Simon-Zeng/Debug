///*
// *  MyElongCommonDefine.h
// *  ElongClient
// *
// *  Created by bin xing on 11-3-20.
// *  Copyright 2011 DP. All rights reserved.
// *
// */
//#import <eLongDefine.h>
//#import <eLongDefineCommon.h>
//
//#define REGISTPAYERTIMESPAN     120   //修改支付密码倒计时限制
//
//
//#define NOTI_CASHACCOUNT_SETPASSWORDSUCCESS     @"NOTI_CASHACCOUNT_SETPASSWORDSUCCESS"  // 现金账户设置密码成功
//#define NOTI_ORDER_MODIFY                       @"NOTI_ORDER_MODIFY"                    // 修改订单成功
//
//#define NOTI_RECOMMENDCHANGED                   @"NOTI_RECOMMENDCHANGED"                // 酒店点评数量发生变化
//#define NOTI_USERCENTERCOUNTUPDATE              @"NOTI_USERCENTERCOUNTUPDATE"           // 点评、可反馈酒店、消
//#define NOTI_REDPACKETCHANGED                   @"NOTI_REDPACKETCHANGED"                // 红包数量发生变化
//#define NOTI_FINDFAVOURITE_ISEMPTY          @"NOTI_FINDFAVOURITE_ISEMPTY"
//
//#define NOTI_FINDEDIT_REFRESH               @"NOTI_FINDEDIT_REFRESH"
//#define NOTI_FINDFAVLIST_REFRESH            @"NOTI_FINDFAVLIST_REFRESH"
//
//#define NOTI_HOTELCOMMENT_DIDCLICK              @"NOTI_HOTELCOMMENT_DIDCLICK"             //酒店点评提交页返回
//#define CARD_NUMBER					@"CardNo"
//#define CREATETIME					@"CreateTime"
//#define LOCATION_NAME               @"LocationName"
//#define DISTINCTID_REQ				@"DistinctID"
//
//#define HOTEL_STATE_CODE			@"HotelStateCode"
//#define HOTEL_STATE_NAME			@"HotelStateName"
//
//#define HOTEL_ORDER_CREATE_TIME		@"HotelOrderCreateTime"
//
//#define ISNEEDADDINFO_REQ			@"IsNeedAddinfo"
//
//#define IMAGE_SIZE_TYPE             @"ImageSizeType"
//#define MINPRICE_REQ				@"MinPrice"
//#define MAXPRICE_REQ				@"MaxPrice"
//#define ORDERS						@"Orders"
//
//#define ORDERNO_REQ					@"OrderNo"
//#define ORDERSTATUSINFOS			@"OrderStatusInfos"
//#define PAGE_SIZE_					@"PageSize"
//#define PAGE_INDEX					@"PageIndex"
//
//#define SEARCH_TYPE					@"SearchType"
//
//#define SORTTYPE_REQ				@"SortType"
//#define STATE_CODE					@"StateCode"
//#define CLIENTSTATUSDESC        @"ClientStatusDesc"
//
//#define STARCODE_REQ				@"StarCode"
//#define STATENAME					@"StateName"
//#define TOTALCOUNT					@"TotalCount"
//
//#define U_R_L                       @"Url"
//#define BIZSECTIONID_REQ			@"BizSectionID"
//// 订单填写时缓存用户信息字段
//#define NONMEMBER_PHONE                 @"nonmember_phone"
//#define NONMEMBER_EMAIL                 @"nonmember_email"
//#define NONMEMBER_CREDITCARD            @"nonmember_creditcard"
//#define NONMEMBER_POSTADDRESS           @"nonmember_postaddress"
//#define NONMEMBER_CHECKINPEPEOS         @"nonmember_checkinpepeos"
//#define NONMEMBER_CHECKINTIME           @"nonmenber_checkintime"
//#define NONMEMBER_HOTEL_ORDERS          @"nonmember_hotel_orders"
//#define NONMEMBER_FLIGHT_ORDERS         @"nonmember_flight_orders"
//#define NONMEMBER_INTERFLIGHT_ORDERS         @"nonmember_interflight_orders"
//#define NONMEMBER_GROUPON_ORDERS        @"nonmember_groupon_orders"
//#define NONMEMBER_TRAIN_ORDERS          @"NONMEMBER_TRAIN_ORDERS"
//#define NONMEMBER_ROOMNUM               @"nonmenber_roomnum"
//#define HIDE_ORDER_LIST                 @"hide_order_list"
//#define RECORD_TRAIN_PASSAGERS          @"RECORD_TRAIN_PASSAGERS"
//#define RECORD_TRAIN_PASSAGERS_COUNT    @"RECORD_TRAIN_PASSAGERS_COUNT"
//#define RECORD_TRAIN_RECORDTIME         @"RECORD_TRAIN_RECORDTIME"
//#define RECORD_TRAIN_PASSENGERS_INFO    @"RECORD_TRAIN_PASSENGERS_INFO"
//
//// 国际酒店入住人信息缓存
//#define INTERHOTEL_ROOMERS          @"InterHotel_roomers"
//#define INTERHOTEL_ROOMER_TIME      @"InterHotel_roomer_time"
//
//// 回传字段
//#define BIZSECTIONID_RESP			@"BizSectionID"
//#define BIZSECTIONLIST_RESP			@"BizSectionList"
//#define BIZSECTIONNAME_RESP			@"BizSectionName"
//#define	DISTRICTLIST_RESP			@"DistrictList"
//#define DISTRICTID_RESP				@"DistrictID"
//#define DISTRICTNAME_RESP			@"DistrictName"
//#define HOTELDETAILINFOS_RESP		@"HotelDetailInfos"
//#define STAR_RESP					@"Star"
//#define SHOWTIME					@"ShowTime"
//#define SUMPRICE					@"SumPrice"
//#define NAME_RESP					@"Name"
//#define IDTYPEENUM                  @"idTypeEnum"
//#define IDTYPENAME                  @"IdTypeName"
//#define IDNUMBER                    @"IdNumber"
//#define IDTYPE                      @"IdType"
//#define NEEDVOUCH					@"NeedVouch"
//#define PRIORITY_SEARCH_HOTEL		@"priority search hotel"			// 优先搜索酒店名
//#define PNRS_RESP					@"PNRs"
//#define VOUCHSETOPTION				@"VouchSetOption"
//#define	IS_VOER_DUE					@"IsOverdue"
//
//#define GROUPONSEARCHHISTORIES      @"GrouponSearchKeywordArray"
//#define IMAGE_PATH                  @"ImagePath"
//
//// =======================================================================================================
//// 酒店查询字段
//#define DATANAME_HOTEL				@"DataName"
//#define NAME_HOTEL                  @"Name"
//#define THEMENAMECN_HOTEL           @"ThemeNameCn"
//#define APIID_HOTEL                 @"ApiId"
//#define MISID_HOTEL                 @"MisId"
//#define THEMEID_HOTEL               @"ThemeId"
//#define DATAID_HOTEL				@"DataID"
//#define LOCATIONLIST_HOTEL			@"LocationList"
//#define THEMELIST_HOTEL             @"ThemeList"
//#define ADDITONINFOLIST_HOTEL		@"AdditionInfoList"
//#define ARRIVE_TIME_RANGE			@"ArriveTimeRange"
//#define TYPEID_HOTEL				@"TypeID"
//#define TAGID_HOTEL					@"TagID"
//#define TAGNAME_HOTEL				@"TagName"
//#define AIRPORT_RAILWAY_TAG_INFOS	@"AirportRailwayTagInfos"
//#define COMMERCIAL_HOTEL			@"Commercial"
//#define DISTRICT_HOTEL				@"District"
//#define HOTEL_LIST                  @"HotelList"
//#define HOTELBRAND_HOTEL			@"HotelBrand"
//#define CHAINHOTEL_HOTEL            @"ChainHotel"
//#define HOTEL_ADDRESS				@"HotelAddress"
//#define HOLDING_TIME_OPTIONS        @"HoldingTimeOptions"
//#define GUEST_NAME					@"GuestName"
//#define GHHOTEL_ROOM_INFOLIST       @"GHHotelRoomInfoList"
//#define AIRPORT_RAILWAY				@"Airport/Railway"
//#define ROOMS                       @"Rooms"
//#define	ROOMTYPEID					@"RoomTypeId"
//#define SHotelID                    @"SHotelID"
//#define ROOMTYPENAME				@"RoomTypeName"
//#define	RATEPLANID					@"RatePlanId"
//#define	VOUCHSET					@"VouchSet"
//#define SUBWAY_STATION				@"Subway Station"
//#define SUBWAYSTATION_TAG_INFOS		@"SubwayStationTagInfos"
//#define HOTELFACILITYS              @"HotelFacilitys"
//#define PICURL_HOTEL				@"PicUrl"
//#define HOTEL_IMAGE_ITEMS           @"HotelImageItems"
//#define AREA_LIMITED_NONE			@"区域不限"
//#define BRAND_LIMITED_NONE			@"品牌不限"
//#define THEME_LIMITED_NONE          @"主题不限"
//#define THEME_APARTMENT             @"公寓"
//#define FACILITY_LIMITED_NONE       @"设施不限"
//#define STAR_LIMITED_NONE			@"星级不限"
//#define PRICE_LIMITED_NONE			@"价格不限"
//#define ORDER_LIMITED_NONE			@"默认排序"
//#define PAYINHOTEL_TYPE				@"前台自付"
//#define HAVE_COUPON_STR				@"可使用消费券"
//#define NO_VOUCH_STR				@"免担保"
//#define STAR_LIMITED_FIVE			@"五星/豪华"
//#define STAR_LIMITED_FOUR			@"四星/高档"
//#define STAR_LIMITED_THREE			@"三星/舒适"
//#define STAR_LIMITED_OTHER			@"经济"
//#define ORDER_FILL_ALERT			@"关闭界面将丢失填写数据,\n是否确认？"
//#define LOADINGTIPSTRING            @"正在加载，请稍候"
//#define CANT_TEL_TIP				@"当前设备不支持通话功能"
//#define MAX_HOTEL_COUNT				100			// 酒店列表最大容量
//#define HOTEL_PAGESIZE				15			// 每页酒店请求数
//
//
//
//// =======================================================================================================
//// 机票常用字段
//#define ARRIVAL_TIME				@"ArrivalTime"
//#define ARRIVE_AIRPORT				@"ArriveAirport"
//#define AIRCORP_NAME				@"AirCorpName"
//#define BOOKER_INFO					@"BookerInfo"
//#define DELIVERY_ADDRESS			@"DeliveryAddress"
//#define DELIVERY_PERSON				@"DeliveryPerson"
//#define DELIVERY_PHONE				@"DeliveryPhone"
//#define DELIVERY_POSTCODE			@"DeliveryPostcode"
//#define DEPART_TIME					@"DepartTime"
//#define DEPART_AIRREPORT			@"DepartAirport"
//#define FLIGHT_NUMBER				@"FlightNumber"
//#define FLIGHTS						@"Flights"
//#define LEGISLATION_PRICE           @"LegislationPrice"
//
//// =======================================================================================================
//// 列车查询常用字段
//#define Resq_Header					@"Header"
//#define TRAIN_DEPARTURE_STATION		@"StartStation"
//#define TRAIN_ARRIVAL_STATION		@"EndStation"
//#define TRAIN_STATION_NAME			@"StationName"
//#define TRAIN_SEARCH_ARRIVE_TIME	@"SearchStationArriveTime"
//#define TRAIN_SEARCH_START_TIME		@"SearchStationStartTime"
//#define TRAIN_SEARCH_STATION		@"SearchStation"
//#define TRAIN_TYPE					@"Type"
//#define TRAIN_STYPE					@"SType"
//#define TRAIN_START_TIME			@"StartTime"
//#define TRAIN_END_TIME				@"EndTime"
//#define TRAIN_MIN_START_TIME		@"MinStartTime"
//#define TRAIN_MAX_START_TIME		@"MaxStartTime"
//#define TRAIN_MIN_END_TIME			@"MinEndTime"
//#define TRAIN_MAX_END_TIME			@"MaxEndTime"
//#define ZERO						@"0"
//#define TRAIN_DEFAULT_START_TIME	@"00:00"
//#define TRAIN_DEFAULT_MORNING_TIME	@"06:00"
//#define TRAIN_DEFAULT_AFTERNOON_TIME @"12:00"
//#define TRAIN_DEFAULT_NIGHT_TIME	@"18:00"
//#define TRAIN_DEFAULT_END_TIME		@"23:59"
//#define TRAIN_COSTTIME				@"CostTime"
//#define TRAIN_COSTDAYS				@"CostDays"
//#define TRAIN_DISTANCE				@"Distance"
//#define TRAIN_NAME					@"TrainName"
//#define HARD_SEAT					@"HardSeat"
//#define SOFT_SEAT					@"SoftSeat"
//#define HARD_SLEEP					@"HardSleep"
//#define SOFT_SLEEP					@"SoftSleep"
//#define SEAT_A						@"SeatA"
//#define SEAT_B						@"SeatB"
//#define SEAT_SUPER					@"SeatSuper"
//#define GJRW						@"GJRW"
//#define LOW_PRICEINFO				@"LowPriceInfo"
//
//#define NOTRAIN_TIP					@"未找到匹配车次"
//#define NOSTOPFLIGHT_TIP            @"未能获取经停信息"
//#define STRING_NOLIMIT				@"不限"
//#define STRING_MORNING				@"06:00-12:00"
//#define STRING_AFTERNOON			@"12:00-18:00"
//#define STRING_NIGHT				@"18:00-06:00"
//#define ALL_TRAIN					@"全部"
//#define G_TRAIN						@"高铁（G）"
//#define D_TRAIN						@"动车（D）"
//#define Z_TRAIN						@"直达（Z）"
//#define T_TRAIN						@"特快（T）"
//#define K_TRAIN						@"快速（K）"
//#define OTHER_TRAIN					@"其它"
//#define TRAIN_START					@"始发"
//#define TRAIN_END					@"终到"
//#define TRAIN_SERVER_NUM            @"4009333333"
//#define TRAIN_SERVER_NUM_TIPS       @"4009-333-333"
//
//// =======================================================================================================
//// 团购常用字段
//#define ADDRESS_GROUPON				@"Address"
//#define ALLGROUPONCNT_GROUPON		@"AllGrouponCnt"
//#define AREAID_GROUPON				@"AreaID"
//#define AREANAME_GROUPON			@"AreaName"
//#define BOOKINGNUMS_GROUPON			@"BookingNums"
//#define CITYS_GROUPON				@"CityList"
//#define CITYNAME_GROUPON			@"CityName"
//#define CITYID_GROUPON				@"CityID"
//#define CONTENTS_GROUPON			@"Contents"
//#define	DESCRIPTION_GROUPON			@"Description"
//#define DETAILINFO_GROUPON			@"DetailInfo"
//#define PRODUCTDETAIL_GROUPON       @"ProductDetail"
//#define STARTAVAILABLEDATE_GROUPON  @"StartAvailableDate"
//#define ENDAVAILABLEDATE_GROUPON    @"EndAvailableDate"
//#define NOTAPPLICABLEDATE_GROUPON   @"NotApplicableDate"
//#define STORES_GROUPON              @"Stores"
//#define GIFTS_GROUPON               @"Gifts"
//#define DISCOUNT_GROUPON			@"Discount"
//#define EXPRESSFEE_GROUPON			@"ExpressFee"
//#define EFFECTSTARTTIME_GROUPON		@"EffectStartTime"
//#define EFFECTENDTIME_GROUPON		@"EffectEndTime"
//#define GROUPONCOUNT_GROUPON		@"GrouponCnt"
//#define GROUPONID_GROUPON			@"GrouponID"
//#define	GROUPONLIST_GROUPON			@"GrouponList"
//#define GROUPONORDERSTATUS			@"NewPayStatus"
//#define GROUPONPAYSTATUS			@"GrouponPayStatus"      //团购订单支付状态非会员还用老字段
//#define HOTELNAME_GROUPON			@"HotelName"
//#define INVOICE_GROUPON				@"Invoice"
//#define INVOICETITLE_GROUPON		@"InvoiceTitle"
//#define ISINVOICE_GROUPON			@"IsInvoice"
//#define ISSEARCHREFUND              @"IsSearchRefund"
//#define LEFTTIME_GROUPON			@"LeftTime"
//#define ORDERREQ_GROUPON			@"OrderReq"
//#define ORDERID_GROUPON				@"OrderID"
//#define ORDERSTATUS_GROUPON			@"OrderStatus"
//#define PAYSTATUS					@"NewPayStatus"
//#define	PHOTOURL_GROUPON			@"PhotoUrl"
//#define PHOTOURLS_GROUPON			@"PhotoUrls"
//#define ORIGINALPHOTOURLS_GROUPON   @"OriginalPhotoUrls"
//#define PRODID_GROUPON				@"ProdId"
//#define PRODNAME_GROUPON			@"ProdName"
//#define PRODTYPE_GROUPON			@"ProdType"
//#define PAYMETHOD                   @"PayMethod"
//#define QSTATUS_GROUPON				@"QStatus"
//#define QUANS_GROUPON				@"Quans"
//#define QUANCODE_GROUPON			@"QuanCode"
//#define QUANID_GROUPON				@"QuanID"
//#define QUANID_GROUPONS             @"QuanIDs"
//#define ISALLOWREFUND               @"IsAllowRefund"
//#define ISALLOWCONTINUEPAY  @"IsAllowContinuePay"
//#define SALEPRICE_GROUPON			@"SalePrice"
//#define SHOWPRICE_GROUPON			@"ShowPrice"
//#define SALENUMS_GROUPON			@"SaleNums"
//#define MOBILEPRODUCTTYPE_GROUPON   @"MobileProductType"
//#define TIME_GROUPON				@"Time"
//#define TITLE_GROUPON				@"Title"
//#define TOTALPRICE_GROUPON			@"TotalPrice"
//#define TYPE_GROUPON				@"Type"
//#define VALUE_GROUPON				@"Value"
//#define NONMEMBER_GROUPONCARDNO		@"192928"
//#define MAX_PAGESIZE_GROUPON		20
//#define MAX_ONEPAGE_GROUPON         60
//#define MAX_PAGESIZE_HOTEL          25
//#define MAX_GROUPON_COUNT			60
//#define MAX_PAGESIZE_HOTELSALE      25
//#define FILTER_TYPE_DIS				0
//#define FILTER_TYPE_BIZ				1
//#define FILTER_TYPE_POI             2
//
//#define SELFACTIONSHEET             1001
//#define DPNAVSHEET                  1002
//
//// 记录酒店城市列表上次选择
//#define kHotelLastSelectedCityKey @"HotelLastSelectedCityKey"
//
//#define  kUIColorFromColorvalue(rgbValue)    [UIColor \
//colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
//green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
//blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//
//#define CELLBGCOLOR                 RGBACOLOR(0,0,0,.1)
//#define GREENCOLOR                  RGBACOLOR(3, 145, 217, 1)
//#define DEEPGREENCOLOR              RGBACOLOR(2,101,151,1)
//#define PRICECOLOR                  RGBACOLOR(255, 89, 54, 1)
//#define ORANGECOLOR                 RGBACOLOR(255,136,17,1)
//#define DEEPORANGECOLOR             RGBACOLOR(178,95,12,1)
//#define GRAYCOLOR                   RGBACOLOR(250,250,250,1)
//#define DEEPGRAYCOLOR               RGBACOLOR(175,175,175,1)
//#define LEFTSIDEBAR_WIDTH           220
//#define TAXICELLCOLOR               RGBACOLOR(57,57,57,1)
//
//// 默认值
//#define DEFAULTPOSTCODEVALUE        @"100000"
////团购最大价格
//#define GrouponMaxMaxPrice 9999999
//
//// crash文件信息
//#define kSystemLaunchTimeKey                        @"systemLaunchTime"
//#define	kCrashInfoFile							    @"crashinfo.dat"
//#define	kCrashInfoArchiverKey						@"arrayCrashInfo"
//#define	kCrashStepFile							    @"crashStep.dat"
//#define	kCrashStepArchiverKey						@"arrayCrashStep"
//
//// 酒店关键词搜索历史记录数量
//#define HOTEL_KEYWORDHISTORY_NUM    3
//
////点评跳转记录
//#define  APPComment   @"appcomment"
//#define  RedExtraIsCheck  @"RedExtraIsCheck"  //红包余额没被查
//
//
////我的钱包字典字段
//#define MY_WALLET_CASHDETAILDIC @"cashDetailDic"
//
//#define KEY_NAME				@"Name"				//姓名
//#define KEY_ADDRESS_CONTENT		@"AddressContent"	//地址内容
//#define KEY_ADDRESSES			@"Addresses"		//邮寄地址
//#define KEY_ID					@"Id"				//id
