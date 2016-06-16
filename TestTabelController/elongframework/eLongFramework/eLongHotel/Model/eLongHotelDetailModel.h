//
//  eLongHotelDetailModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongHotelDetailGroupModel.h"

@interface eLongHotelDetailModel : eLongResponseBaseModel
/**
 *  酒店名称
 */
@property (nonatomic,copy) NSString *HotelName;
/**
 *  酒店 Id
 */
@property (nonatomic,copy) NSString *HotelId;
/**
 *  星级
 */
@property (nonatomic,assign) NSInteger Star;
/**
 *  酒店封面图
 */
@property (nonatomic,copy) NSString *PicUrl;
/**
 *  经度
 */
@property (nonatomic,assign) CGFloat Longitude;
/**
 *  纬度
 */
@property (nonatomic,assign) CGFloat Latitude;
/**
 *  百度纬度
 */
@property (nonatomic,assign) CGFloat BaiduLatitude;
/**
 *  百度经度
 */
@property (nonatomic,assign) CGFloat BaiduLongitude;
/**
 *  酒店地址
 */
@property (nonatomic,copy) NSString *Address;
/**
 *  酒店电话
 */
@property (nonatomic,copy) NSString *Phone;
/**
 *  开业日期
 */
@property (nonatomic,copy) NSString *OpenDate;
/**
 *  酒店星级
 */
@property (nonatomic,assign) NSInteger NewStarCode;
/**
 *  酒店设施
 */
@property (nonatomic,assign) NSInteger HotelFacilityCode;
/**
 *  酒店评分
 */
@property (nonatomic,assign) CGFloat Rating;
/**
 *  酒店好评率
 */
@property (nonatomic,assign) CGFloat CommentPoint;
/**
 *  设施与服务
 */
@property (nonatomic,copy) NSString *GeneralAmenities;
/**
 *  交通状况
 */
@property (nonatomic,copy) NSString *TrafficAndAroundInformations;
/**
 *  推荐人数
 */
@property (nonatomic,assign) NSInteger GoodCommentCount;
/**
 *  不推荐人数
 */
@property (nonatomic,assign) NSInteger BadCommentCount;
/**
 *  评价人数
 */
@property (nonatomic,assign) NSInteger TotalCommentCount;
/**
 *  行政区域
 */
@property (nonatomic,copy) NSString *AreaName;
/**
 *  商圈ID
 */
@property (nonatomic,copy) NSString *BusinessAreaId;
/**
 *  特色介绍
 */
@property (nonatomic,copy) NSString *FeatureInfo;
/**
 *  酒店类型
 */
@property (nonatomic,assign) NSInteger HotelCategory;
/**
 *  是否是买五送一酒店
 */
@property (nonatomic,assign) BOOL IsFiveToOneHotel;
/**
 *  买五送一酒店活动描述详情
 */
@property (nonatomic,copy) NSString *FiveToOneHotelDesc;
/**
 *  是否是五折酒店
 */
@property (nonatomic,assign) BOOL IsDiscountHotel;
/**
 *  五折酒店描述
 */
@property (nonatomic,copy) NSString *discountDes;
/**
 *  满减酒店描述
 */
@property (nonatomic,copy) NSString *fullCutDes;
/**
 *  是否显示折后价开关
 */
@property (nonatomic,assign) BOOL IsShowSubCouponPrice;
/**
 *  是否有返现
 */
@property (nonatomic,assign) BOOL isCouponFlag;

/**
 *  城市名
 */
@property (nonatomic,copy) NSString *CityName;
/**
 *  图片数量
 */
@property (nonatomic,assign) NSInteger ImagesCount;
@property (nonatomic,strong) NSArray<eLongHotelDetailGroupModel> *productsGroupByRoom;

/**
 *  当前选中房间位置
 */
@property (nonatomic,strong) NSIndexPath *selectedRoomIndexPath;

/**
 *  酒店确认率与同城均值的差值
 */
@property (nonatomic,assign) NSInteger HotelConfirmRateDiff;

/**
 *  预定成功率与同城均值的差值
 */
@property (nonatomic,assign) NSInteger PreSuccessRateDiff;

/**
 *  用户满意度与同城均值的差值
 */
@property (nonatomic,assign) NSInteger SatisfactionDiff;

/**
 *  酒店确认率
 */
@property (nonatomic,copy) NSString *HotelConfirmRate;

/**
 *  酒店预订成功率
 */
@property (nonatomic,copy) NSString *PreSuccessRate;

/**
 *  用户满意度
 */
@property (nonatomic,copy) NSString *Satisfaction;

@end
