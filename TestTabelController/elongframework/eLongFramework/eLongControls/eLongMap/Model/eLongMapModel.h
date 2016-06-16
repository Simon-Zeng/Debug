//
//  eLongMapModel.h
//  ElongClient
//
//  Created by chenggong on 15/12/16.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "eLongMKAnnotation.h"

@interface eLongMapModel : NSObject

/**
 *  经度
 */
@property (nonatomic,assign) CGFloat Longitude;
/**
 *  纬度
 */
@property (nonatomic,assign) CGFloat Latitude;
/**
 *  MKAnnotaion title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  MKAnnotaion subtitle
 */
@property (nonatomic, copy) NSString *subtitle;
/**
 *  地图页的frame
 */
@property (nonatomic, assign) CGRect mapFrame;
/**
 *  是否显示导航
 */
@property (nonatomic, assign) BOOL isDisplayNavigator;
/**
 *  是否显示兴趣点
 */
@property (nonatomic, assign) BOOL isDisplayPOI;
/**
 *  目的地Annotation.
 */
@property (nonatomic, strong) eLongMKAnnotation *destinationAnnotation;
/**
 *  Annotation数组.
 */
@property (nonatomic, strong) NSMutableArray *annotationArray;


@end
