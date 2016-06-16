//
//  eLongMapView.h
//  ElongClient
//
//  Created by chenggong on 15/12/15.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "eLongMapModel.h"
#import "ScalableView.h"

typedef MKAnnotationView* (^mapViewForAnnotation)(MKMapView* mapView, id<MKAnnotation> annotation);
typedef MKOverlayView* (^mapViewForOverlay)(MKMapView *mapView, id<MKOverlay> overlay);
typedef void (^mapViewAnnotationDidChangeDragStateFromOldState)(MKMapView * map, MKAnnotationView *annotationView, MKAnnotationViewDragState newState, MKAnnotationViewDragState oldState);
typedef void (^addMKAnnotation)(void);

#define kMapRouteColor [UIColor colorWithRed:68.0f/255.0f green:184.0f/255.0f blue:34.0/255.0f alpha:0.8]

@interface eLongMapView : MKMapView <CLLocationManagerDelegate, MKMapViewDelegate, ScalableViewDelegate>

@property (nonatomic, copy) mapViewForAnnotation mapViewForAnnotationBlock;
@property (nonatomic, copy) mapViewForOverlay mapViewForOverlayBlock;
@property (nonatomic, copy) mapViewAnnotationDidChangeDragStateFromOldState annotationDidChangeDragStateBlock;
@property (nonatomic, copy) addMKAnnotation addMKAnnotationBlock;

@property (nonatomic, strong) eLongMKAnnotation *pinAnnotation;

- (instancetype) initWithFrame:(CGRect)frame latitude:(double) lat longitude:(double)lng;
- (instancetype) initWithModel:(eLongMapModel *)mapModel;
- (void)refresh;

@end
