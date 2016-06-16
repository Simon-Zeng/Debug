//
//  eLongMapViewController.h
//  ElongClient
//
//  Created by chenggong on 15/12/15.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongMapView.h"
#import "eLongMapModel.h"
#import "ElongBaseViewController.h"

typedef void (^refreshMapViewBlk)(void);

@interface eLongMapViewController : ElongBaseViewController

@property (nonatomic, strong) eLongMapView *mapView;
@property (nonatomic, strong) NSMutableArray *reservedAnnotations;
@property (nonatomic, assign) MKCoordinateRegion reservedRegion;
@property (nonatomic, strong) UILabel *addressTipsLbl;

// MapView Delegate.
@property (nonatomic, copy) mapViewForAnnotation mapViewForAnnotationBlock;
@property (nonatomic, copy) mapViewForOverlay mapViewForOverlayBlock;
@property (nonatomic, copy) mapViewAnnotationDidChangeDragStateFromOldState annotationDidChangeDragStateBlock;
@property (nonatomic, copy) addMKAnnotation addMKAnnotationBlock;
@property (nonatomic, copy) refreshMapViewBlk refreshMapViewBlock;

- (instancetype)initWithTitle:(NSString *)titleStr
                        style:(NavBarBtnStyle)style
                     mapModel:(eLongMapModel *)mapModel;

- (void)refreshMapView;
- (void)setMapViewRegion:(MKCoordinateRegion)region animated:(BOOL)animated;
- (void)setMapToCenter;
- (void)setSinglePinWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)goUserLocation;
- (void)selectPin;

@end
