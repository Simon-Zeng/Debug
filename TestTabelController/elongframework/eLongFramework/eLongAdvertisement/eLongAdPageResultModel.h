//
//  eLongAdPageResultModel.h
//  eLongFramework
//
//  Created by Ning.liu on 15/8/17.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//
@protocol eLongAdPageResultModel @end

#import "eLongResponseBaseModel.h"
#import "eLongAdvInfoModel.h"

@interface eLongAdPageResultModel : eLongResponseBaseModel

/**
 *  0:Default,1:HotelSearch,2:FlightSearch,3:RailwaySearch,4:HotelPayCounter,5:FlightPayCounter,6:GrouponPayCounter,7:HomePage,8:HotelList,9:FlatOne,10:FlatTwo,11:FlatThree,12:SplashScreen,13:H5Business,14:H5Activity,15:FlatList,16:H5ActivityPage,17:GlobalHotelListPage
 */
@property (nonatomic,copy)   NSString *key;

@property (nonatomic,strong) NSArray<eLongAdvInfoModel> *infos;


@end
