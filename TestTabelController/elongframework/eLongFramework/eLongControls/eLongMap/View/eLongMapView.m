//
//  eLongMapView.m
//  ElongClient
//
//  Created by chenggong on 15/12/15.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongMapView.h"
#import "eLongAlertView.h"
#import "eLongMKAnnotation.h"
#import <AddressBook/AddressBook.h>
#import "eLongLocation.h"
#import "eLongDefine.h"

#define kMapZoomLevel 0.02f

@interface eLongMapView()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic, strong) ScalableView *navScalableView;              // 导航
@property (nonatomic, strong) ScalableView *poiScalableView;              // 酒店、餐馆
@property (nonatomic, strong) eLongMapModel *mapModel;

@end

@implementation eLongMapView

- (instancetype) initWithFrame:(CGRect)frame latitude:(double)lat longitude:(double)lng {
    if (self = [super initWithFrame:frame]) {
        self.coordinate2D = CLLocationCoordinate2DMake(lat, lng);
        [self initializeMapView];
    }
    
    return self;
}

- (instancetype) initWithModel:(eLongMapModel *)mapModel {
    if (self = [super initWithFrame:mapModel.mapFrame]) {
        if (mapModel) {
            self.coordinate2D = CLLocationCoordinate2DMake(mapModel.Latitude, mapModel.Longitude);
            [self initializeMapView];
            
            //            if (mapModel.isDisplayNavigator) {
            //                [self initializeNavigatorView];
            //            }
            
            //            if (mapModel.isDisplayPOI) {
            //                [self initializePOIView];
            //            }
        }
    }
    return self;
}

- (void)initializePOIView {
    // 周边
    NSArray *imageArray = [NSArray arrayWithObjects:@"poi_0.png",@"poi_1.png",@"poi_2.png",@"poi_3.png",@"poi_4.png",@"poi_5.png", nil];
    NSArray *hightlightedImageArray = [NSArray arrayWithObjects:@"poi_0_l.png",@"poi_1_l.png",@"poi_2_l.png",@"poi_3_l.png",@"poi_4_l.png",@"poi_5_l.png", nil];
    self.poiScalableView = [[ScalableView alloc] initWithFrame:CGRectMake(8, 22, SCREEN_WIDTH-16, 45)
                                                        images:imageArray
                                             highlightedImages:hightlightedImageArray];
    _poiScalableView.delegate = self;
    [self addSubview:_poiScalableView];
    
    // 默认展开周边
    [_poiScalableView moveOut];
}

- (void)initializeNavigatorView {
    // 导航
    NSArray *imageArray = [NSArray arrayWithObjects:@"nav_0.png",@"nav_1.png",@"nav_2.png", nil];
    NSArray *hightlightedImageArray = [NSArray arrayWithObjects:@"nav_0_l.png",@"nav_1_l.png",@"nav_2_l.png", nil];
    
    self.navScalableView = [[ScalableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 166, 70, 160, 45)
                                                        images:imageArray
                                             highlightedImages:hightlightedImageArray];
    _navScalableView.delegate = self;
    [self addSubview:_navScalableView];
}

- (void)initializeMapView {
    self.delegate = self;
    [self setUserTrackingMode:MKUserTrackingModeNone];
    [self setMapType:MKMapTypeStandard];
    self.showsUserLocation = YES;
    //    MKCoordinateRegion region;
    //    if(CLLocationCoordinate2DIsValid(_coordinate2D) && ((int)_coordinate2D.longitude != 0 || (int)_coordinate2D.latitude != 0)) {
    //        region = MKCoordinateRegionMake(_coordinate2D, MKCoordinateSpanMake(kMapZoomLevel, kMapZoomLevel));
    //    }
    //    else {
    //        region.center.longitude = 0.0;
    //        region.center.latitude = 0.0;
    //        region.span.longitudeDelta = 30.0;
    //        region.span.latitudeDelta = 30.0;
    //    }
    
    //    [self setRegion:[self regionThatFits:region] animated:YES];
    
    //    eLongMKAnnotation *businessAnnoation = [[eLongMKAnnotation alloc] init];
    //    businessAnnoation.coordinate = _coordinate2D;
    //    [self addAnnotation:businessAnnoation];
    
    //    [self selectAnnotation:businessAnnoation animated:YES];
    
}

//#pragma mark -
//#pragma mark Setter.
//- (void)setMapViewForAnnotationBlock:(mapViewForAnnotation)annotation {
//    _mapViewForAnnotationBlock = [annotation copy];
//}

#pragma mark -
#pragma mark MapView manipulate
- (void)refresh {
    [self removeAnnotation:self.pinAnnotation];
    self.pinAnnotation = nil;
    
    if (_mapModel.annotationArray) {
        [self removeAnnotations:_mapModel.annotationArray];
    }
    
    [_mapModel.annotationArray removeAllObjects];
    
    if (_addMKAnnotationBlock) {
        _addMKAnnotationBlock();
    }
    
    [self addAnnotations:_mapModel.annotationArray];
    //
    //    [self centerMap];
    //    [self addMark];
}

#pragma mark -
#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (_mapViewForAnnotationBlock) {
        return _mapViewForAnnotationBlock(mapView, annotation);
    }
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[eLongMKAnnotation class]]) {
        static NSString *PriceIdentifier = @"PriceIdentifier";
        MKAnnotationView* pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:PriceIdentifier];
        if (!pinView){
            // 大头针注解
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PriceIdentifier];
            pinView.canShowCallout  = YES;
            pinView.opaque			= YES;
            pinView.frame			= CGRectMake(0, 0, 32, 38);
            pinView.tintColor = [UIColor greenColor];
        }
        else {
            pinView.annotation = annotation;
        }
        
        //        static NSString *PinIdentifier = @"PinIdentifier";
        //        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
        //        if (!pinView){
        //            MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
        //                                                                                  reuseIdentifier:PinIdentifier];
        //            annotationView.canShowCallout = YES;
        //            annotationView.animatesDrop = YES;
        //            annotationView.pinColor = MKPinAnnotationColorGreen;
        //
        //            return annotationView;
        //        }
        //        else {
        //            pinView.annotation = annotation;
        //        }
        
        return pinView;
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]]){
        
        MKPolylineView *lineview = [[MKPolylineView alloc] initWithOverlay:overlay] ;
        //路线颜色
        lineview.strokeColor = kMapRouteColor;
        lineview.lineWidth = 10.0;
        return lineview;
    }
    return nil;
}

#pragma mark -
#pragma mark ScalableViewDelegate
- (void) scalableViewDidMoveout:(ScalableView *)scalableView{
    if (scalableView == _navScalableView) {
        [_poiScalableView moveBack];
    }else if(scalableView == _poiScalableView){
        [_navScalableView moveBack];
    }
}

- (void) scalableView:(ScalableView *)scalableView didSelectedAtIndex:(NSInteger)index{
    if (scalableView == _navScalableView){
        [scalableView moveBack];
    }
    if (_navScalableView == scalableView) {
        [_poiScalableView moveBack];
        if (index == 0) {
            //            // 驾车
            //            travelMode = Driving;
            //
            //            [self showalert];
        }else{
//            NSDictionary *options = @{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking};
            
            
            MKPlacemark *mark1 = [[MKPlacemark alloc] initWithCoordinate:[[eLongLocation sharedInstance] coordinate]  addressDictionary:nil];
            MKPlacemark *mark2 = [[MKPlacemark alloc] initWithCoordinate:_coordinate2D  addressDictionary:nil];
            //            MKMapItem *mapItem1=[[MKMapItem alloc]initWithPlacemark:mark1];
            //            MKMapItem *mapItem2=[[MKMapItem alloc]initWithPlacemark:mark2];
            //
            //            Class itemClass = [MKMapItem class];
            //            if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
            //                // Use class
            //                [MKMapItem openMapsWithItems:@[mapItem1,mapItem2] launchOptions:options];
            //            }
            
            [self drawLineWithPlaceMark:mark1 andDestPlaceMark:mark2];
            
            //            // 步行
            //            travelMode = Walking;
            //
            //            if (!routes_walking) {
            //                [self searchDirectionWithLoading:NO];
            //            }else{
            //                [self updateRouteView];
            //            }
        }
        
    }
    else if(_poiScalableView == scalableView){
        switch (index) {
            case 0:{
                [self fetchNearbyInfo:@"bank"];
                break;
            }
            case 1:{
                [self fetchNearbyInfo:@"park"];
                break;
            }
            case 2:{
                [self fetchNearbyInfo:@"food"];
                
                break;
            }
            case 3:{
                [self fetchNearbyInfo:@"shopping_mall"];
                break;
            }
            case 4:{
                [self fetchNearbyInfo:@"night_club"];
                break;
            }
            default:
                break;
        }
    }
}

- (void)fetchNearbyInfo:(NSString *)poiString
{
    //    CLLocationDegrees latitude = 116.13554;
    //    CLLocationDegrees longitude = 38.413546;
    //    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
    
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.coordinate2D, self.coordinate2D. ,DEFAULTSPAN );
    //
    //    MKLocalSearchRequest *requst = [[MKLocalSearchRequest alloc] init];
    //    requst.region = region;
    //    requst.naturalLanguageQuery = poiString; //想要的信息
    //    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:requst];
    //
    //    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
    //        if (!error)
    //        {
    //            NSLog(@"MKLocalSearchResponse: %@", response);
    //            //
    //        }
    //        else
    //        {
    //            //
    //        }
    //    }];
}


- (void)drawLineWithPlaceMark:(MKPlacemark*)sourcePlace andDestPlaceMark:(MKPlacemark*)destPlaceMark
{
    MKDirectionsRequest *mkRequest=[[MKDirectionsRequest alloc] init];
    MKMapItem *sourceItem=[[MKMapItem alloc] initWithPlacemark:sourcePlace];
    
    MKMapItem *destItem=[[MKMapItem alloc] initWithPlacemark:destPlaceMark];
    
    mkRequest.destination=destItem;
    mkRequest.source=sourceItem;
    
    MKDirections *directions = [[MKDirections alloc]initWithRequest:mkRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * __nullable response, NSError * __nullable error) {
        for (MKRoute *route in response.routes) {
            [self addOverlay:route.polyline];
        }
    }];
}
- (nonnull MKOverlayRenderer *)mapView:(nonnull MKMapView *)mapView rendererForOverlay:(nonnull id<MKOverlay>)overlay
{
    MKPolylineRenderer *mapPolyLine = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    mapPolyLine.lineWidth = 4;
    mapPolyLine.strokeColor = [UIColor greenColor];
    
    //   MKOverlayRenderer *lay=[[MKOverlayRenderer alloc] initWithOverlay:overlay];
    
    return mapPolyLine;
}
@end
