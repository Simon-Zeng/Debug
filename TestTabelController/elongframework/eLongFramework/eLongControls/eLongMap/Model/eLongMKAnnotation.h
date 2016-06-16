//
//  eLongMKAnnotation.h
//  ElongClient
//
//  Created by chenggong on 15/12/15.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface eLongMKAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *annotaionType;

@end
