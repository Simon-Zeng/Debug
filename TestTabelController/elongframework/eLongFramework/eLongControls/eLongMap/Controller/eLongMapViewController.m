//
//  eLongMapViewController.m
//  ElongClient
//
//  Created by chenggong on 15/12/15.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongMapViewController.h"
#import "eLongMapView.h"
#import "eLongLocation.h"
#import "NSArray+CheckArray.h"

#define kButtonTag 1024

@interface eLongMapViewController ()

@property (nonatomic, strong) eLongMapModel *mapModel;
@property (nonatomic, strong) UIButton *lastSelectedButton;

@end

@implementation eLongMapViewController

- (instancetype)initWithTitle:(NSString *)titleStr
                        style:(NavBarBtnStyle)style
                     mapModel:(eLongMapModel *)mapModel{
    if (self = [super initWithTitle:titleStr style:style]) {
        self.mapModel = mapModel;
        self.mapView =  [[eLongMapView alloc] initWithModel:_mapModel];
        self.reservedAnnotations = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:_mapView];
    
    if (_mapModel.isDisplayPOI) {
        [self initializePOIView];
    }
    
    if (_mapModel.isDisplayNavigator) {
        [self initializeNavigatorView];
    }
}

- (void)initializeNavigatorView {
    // 创建地图页面右下部视图
    UIButton *hotelPositionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hotelPositionButton.backgroundColor = [UIColor whiteColor];
    hotelPositionButton.titleLabel.font = FONT_11;
    [hotelPositionButton setTitle:@" 酒店位置" forState:UIControlStateNormal];
    [hotelPositionButton setTitleColor:[UIColor colorWithHexStr:@"#444444"] forState:UIControlStateNormal];
    [hotelPositionButton setTitleColor:[UIColor colorWithHexStr:@"#444444"] forState:UIControlStateSelected];
    [hotelPositionButton setImage:[UIImage imageNamed:@"hotelLocationChoice.png"] forState:UIControlStateNormal];
    [hotelPositionButton addTarget:self action:@selector(hotelLocationChoice:) forControlEvents:UIControlEventTouchUpInside];
    hotelPositionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:hotelPositionButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[hotelPositionButton(70)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hotelPositionButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[hotelPositionButton(32)]-32-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hotelPositionButton)]];
    CALayer *hotelPositionButtonLayer = [hotelPositionButton layer];
    hotelPositionButtonLayer.cornerRadius = 5.0f;
    
    UIButton *userLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userLocationButton.backgroundColor = [UIColor whiteColor];
    userLocationButton.titleLabel.font = FONT_11;
    [userLocationButton setTitle:@" 我的位置" forState:UIControlStateNormal];
    [userLocationButton setTitleColor:[UIColor colorWithHexStr:@"#444444"] forState:UIControlStateNormal];
    [userLocationButton setTitleColor:[UIColor colorWithHexStr:@"#444444"] forState:UIControlStateSelected];
    [userLocationButton setImage:[UIImage imageNamed:@"userLocation.png"] forState:UIControlStateNormal];
    [userLocationButton addTarget:self action:@selector(userLocationChoice:) forControlEvents:UIControlEventTouchUpInside];
    userLocationButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:userLocationButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[userLocationButton(70)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(userLocationButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[userLocationButton(32)]-12-[hotelPositionButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(userLocationButton, hotelPositionButton)]];
    CALayer *userLocationButtonLayer = [userLocationButton layer];
    userLocationButtonLayer.cornerRadius = 5.0f;
    
    UIButton *navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    navigationButton.titleLabel.font = FONT_11;
    [navigationButton setTitle:@" 导 航" forState:UIControlStateNormal];
    [navigationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [navigationButton setImage:[UIImage imageNamed:@"navigationIcon.png"] forState:UIControlStateNormal];
    [navigationButton addTarget:self action:@selector(navigationChoice:) forControlEvents:UIControlEventTouchUpInside];
    navigationButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:navigationButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[navigationButton(70)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(navigationButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[navigationButton(32)]-12-[userLocationButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(userLocationButton, navigationButton)]];
    CALayer *navigationButtonLayer = [navigationButton layer];
    navigationButtonLayer.cornerRadius = 5.0f;
}

- (void)initializePOIView {
    CGFloat itemWidth = SCREEN_WIDTH / 5;
    
    UIView *poiBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 60.0f)];
    poiBackgroundView.backgroundColor = [UIColor clearColor];
    poiBackgroundView.translatesAutoresizingMaskIntoConstraints = YES;
    
    UIButton *scenicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scenicButton.tag = kButtonTag;
    scenicButton.titleLabel.font = FONT_11;
    [scenicButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [scenicButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [scenicButton setTitle:@"景点" forState:UIControlStateNormal];
    [scenicButton setTitleColor:[UIColor colorWithHexStr:@"#858585"] forState:UIControlStateNormal];
    [scenicButton setTitleColor:[UIColor colorWithHexStr:@"#4499ff"] forState:UIControlStateSelected];
    scenicButton.imageEdgeInsets = UIEdgeInsetsMake(14.0f, (itemWidth - 20.0f) / 2, 0.0f, 0.0f);
    scenicButton.titleEdgeInsets = UIEdgeInsetsMake(36, (itemWidth - 20) * 0.5 - 20, 0.0f, 0.0f);
    
    [scenicButton setImage:[UIImage imageNamed:@"scenicUnSelected.png"] forState:UIControlStateNormal];
    [scenicButton setImage:[UIImage imageNamed:@"scenicUnSelected.png"] forState: UIControlStateHighlighted];
    [scenicButton setImage:[UIImage imageNamed:@"scenicSelected.png"] forState:UIControlStateSelected];
    [scenicButton setImage:[UIImage imageNamed:@"scenicSelected.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    //    scenicButton.selected = YES;
    //    self.lastSelectedButton = scenicButton;
    [scenicButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    scenicButton.translatesAutoresizingMaskIntoConstraints = NO;
    [poiBackgroundView addSubview:scenicButton];
    
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scenicButton(itemWidth)]" options:0 metrics:@{@"itemWidth":@(itemWidth)} views:NSDictionaryOfVariableBindings(scenicButton)]];
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scenicButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scenicButton)]];
    
    UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foodButton.tag = kButtonTag + 1;
    foodButton.titleLabel.font = FONT_11;
    [foodButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [foodButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [foodButton setTitle:@"美食" forState:UIControlStateNormal];
    [foodButton setTitleColor:[UIColor colorWithHexStr:@"#858585"] forState:UIControlStateNormal];
    [foodButton setTitleColor:[UIColor colorWithHexStr:@"#4499ff"] forState:UIControlStateSelected];
    foodButton.imageEdgeInsets = UIEdgeInsetsMake(14.0f, (itemWidth - 20.0f) / 2, 0.0f, 0.0f);
    foodButton.titleEdgeInsets = UIEdgeInsetsMake(36, (itemWidth - 20) * 0.5 - 20, 0.0f, 0.0f);
    [foodButton setImage:[UIImage imageNamed:@"foodUnSelected.png"] forState:UIControlStateNormal];
    [foodButton setImage:[UIImage imageNamed:@"foodUnSelected.png"] forState: UIControlStateHighlighted];
    [foodButton setImage:[UIImage imageNamed:@"foodSelected.png"] forState:UIControlStateSelected];
    [foodButton setImage:[UIImage imageNamed:@"foodSelected.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [foodButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    foodButton.translatesAutoresizingMaskIntoConstraints = NO;
    [poiBackgroundView addSubview:foodButton];
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[scenicButton][foodButton(scenicButton)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scenicButton, foodButton)]];
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[foodButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(foodButton)]];
    
    UIButton *bankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bankButton.tag = kButtonTag + 2;
    bankButton.titleLabel.font = FONT_11;
    [bankButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [bankButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [bankButton setTitle:@"银行" forState:UIControlStateNormal];
    [bankButton setTitleColor:[UIColor colorWithHexStr:@"#858585"] forState:UIControlStateNormal];
    [bankButton setTitleColor:[UIColor colorWithHexStr:@"#4499ff"] forState:UIControlStateSelected];
    bankButton.imageEdgeInsets = UIEdgeInsetsMake(14.0f, (itemWidth - 20.0f) / 2, 0.0f, 0.0f);
    bankButton.titleEdgeInsets = UIEdgeInsetsMake(36, (itemWidth - 20) * 0.5 - 20, 0.0f, 0.0f);
    [bankButton setImage:[UIImage imageNamed:@"bankUnSelected.png"] forState:UIControlStateNormal];
    [bankButton setImage:[UIImage imageNamed:@"bankUnSelected.png"] forState: UIControlStateHighlighted];
    [bankButton setImage:[UIImage imageNamed:@"bankSelected.png"] forState:UIControlStateSelected];
    [bankButton setImage:[UIImage imageNamed:@"bankSelected.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [bankButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    bankButton.translatesAutoresizingMaskIntoConstraints = NO;
    [poiBackgroundView addSubview:bankButton];
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[foodButton][bankButton(foodButton)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(foodButton, bankButton)]];
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bankButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bankButton)]];
    
    UIButton *shoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingButton.tag = kButtonTag + 3;
    shoppingButton.titleLabel.font = FONT_11;
    [shoppingButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [shoppingButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [shoppingButton setTitle:@"购物" forState:UIControlStateNormal];
    [shoppingButton setTitleColor:[UIColor colorWithHexStr:@"#858585"] forState:UIControlStateNormal];
    [shoppingButton setTitleColor:[UIColor colorWithHexStr:@"#4499ff"] forState:UIControlStateSelected];
    shoppingButton.imageEdgeInsets = UIEdgeInsetsMake(14.0f, (itemWidth - 20.0f) / 2, 0.0f, 0.0f);
    shoppingButton.titleEdgeInsets = UIEdgeInsetsMake(36, (itemWidth - 20) * 0.5 - 20, 0.0f, 0.0f);
    
    [shoppingButton setImage:[UIImage imageNamed:@"shoppingUnSelected.png"] forState:UIControlStateNormal];
    [shoppingButton setImage:[UIImage imageNamed:@"shoppingUnSelected.png"] forState: UIControlStateHighlighted];
    [shoppingButton setImage:[UIImage imageNamed:@"shoppingSelected.png"] forState:UIControlStateSelected];
    [shoppingButton setImage:[UIImage imageNamed:@"shoppingSelected.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [shoppingButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    shoppingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [poiBackgroundView addSubview:shoppingButton];
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bankButton][shoppingButton(bankButton)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bankButton, shoppingButton)]];
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[shoppingButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(shoppingButton)]];
    
    UIButton *entertainmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    entertainmentButton.tag = kButtonTag + 4;
    entertainmentButton.titleLabel.font = FONT_11;
    [entertainmentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [entertainmentButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [entertainmentButton setTitle:@"娱乐" forState:UIControlStateNormal];
    [entertainmentButton setTitleColor:[UIColor colorWithHexStr:@"#858585"] forState:UIControlStateNormal];
    [entertainmentButton setTitleColor:[UIColor colorWithHexStr:@"#4499ff"] forState:UIControlStateSelected];
    entertainmentButton.imageEdgeInsets = UIEdgeInsetsMake(14.0f, (itemWidth - 20.0f) / 2, 0.0f, 0.0f);
    entertainmentButton.titleEdgeInsets = UIEdgeInsetsMake(36, (itemWidth - 20) * 0.5 - 20, 0.0f, 0.0f);
    
    [entertainmentButton setImage:[UIImage imageNamed:@"entertainmentUnSelected.png"] forState:UIControlStateNormal];
    [entertainmentButton setImage:[UIImage imageNamed:@"entertainmentUnSelected.png"] forState: UIControlStateHighlighted];
    [entertainmentButton setImage:[UIImage imageNamed:@"entertainmentSelected.png"] forState:UIControlStateSelected];
    [entertainmentButton setImage:[UIImage imageNamed:@"entertainmentSelected.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [entertainmentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    entertainmentButton.translatesAutoresizingMaskIntoConstraints = NO;
    [poiBackgroundView addSubview:entertainmentButton];
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[shoppingButton][entertainmentButton(shoppingButton)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(shoppingButton, entertainmentButton)]];
    [poiBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[entertainmentButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(entertainmentButton)]];
    
    [self.view addSubview:poiBackgroundView];
}

- (eLongMapView *)mapView {
    return _mapView;
}

- (void)refreshMapView {
    //    [_mapView refresh];
    if (_refreshMapViewBlock) {
        _refreshMapViewBlock();
    }
}

- (void)setMapViewRegion:(MKCoordinateRegion)region animated:(BOOL)animated {
    [_mapView setRegion:region animated:animated];
}

- (void)setMapToCenter
{
    if (![_mapModel.annotationArray hasValue]) {
        return;
    }
    
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    NSUInteger count = _mapModel.annotationArray.count;
    for(int idx = 0; idx < count; idx++) {
        eLongMKAnnotation * curAnonotation=((eLongMKAnnotation *)[_mapModel.annotationArray safeObjectAtIndex:idx]);
        
        if(curAnonotation.coordinate.latitude==0 && curAnonotation.coordinate.longitude==0)
            continue;
        
        if(curAnonotation.coordinate.latitude > maxLat)
            maxLat = curAnonotation.coordinate.latitude;
        if(curAnonotation.coordinate.latitude < minLat)
            minLat = curAnonotation.coordinate.latitude;
        if(curAnonotation.coordinate.longitude > maxLon)
            maxLon = curAnonotation.coordinate.longitude;
        if(curAnonotation.coordinate.longitude < minLon)
            minLon = curAnonotation.coordinate.longitude;
    }
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  = maxLat - minLat + 0.012;
    region.span.longitudeDelta = maxLon - minLon + 0.002;
    
    [self.mapView setRegion:region animated:YES];
}

- (void)setSinglePinWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if (_mapView.pinAnnotation) {
        [self.mapView removeAnnotation:_mapView.pinAnnotation];
    }
    
    _mapView.pinAnnotation = [[eLongMKAnnotation alloc] init];
    [_mapView.pinAnnotation setCoordinate:coordinate];
    [self.mapView addAnnotation:_mapView.pinAnnotation];
}

- (void)goUserLocation {
    float zoomLevel = 0.05;
    //    MKCoordinateRegion currentRegion = self.mapView.region;
    MKCoordinateRegion currentRegion = _reservedRegion;
    
    CLLocationCoordinate2D userloacation = self.mapView.userLocation.location.coordinate;
    if (userloacation.longitude == 0 && userloacation.latitude == 0) {
        userloacation = [[eLongLocation sharedInstance] coordinate];
    }
    if (currentRegion.span.latitudeDelta > zoomLevel) {
        currentRegion = MKCoordinateRegionMake(userloacation, MKCoordinateSpanMake(zoomLevel,zoomLevel));
    }
    else {
        currentRegion = MKCoordinateRegionMake(userloacation, currentRegion.span);
    }
    [self.mapView setRegion:currentRegion animated:NO];
}

- (void)selectPin {
    [self.mapView setCenterCoordinate:self.mapView.pinAnnotation.coordinate animated:NO];
    [self.mapView selectAnnotation:self.mapView.pinAnnotation animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)buttonAction:(UIButton *)selectButton {
    if ([selectButton isKindOfClass:[UIButton class]]) {
        //        selectButton.selected = YES;
        // 清除之前加载的POI信息
        for (id annotation in self.mapView.annotations) {
            if ([_reservedAnnotations indexOfObject:annotation] == NSNotFound) {
                [self.mapView removeAnnotation:annotation];
            }
        }
        
        selectButton.selected = !selectButton.selected;
        
        if (_lastSelectedButton) {
            if (_lastSelectedButton != selectButton) {
                if (_lastSelectedButton.selected) {
                    _lastSelectedButton.selected = !_lastSelectedButton.selected;
                }
            }
        }
        
        self.lastSelectedButton = selectButton;
        
        if (!selectButton.selected) {
            return;
        }
        
        NSUInteger selectedIndex = selectButton.tag - kButtonTag;
        switch (selectedIndex) {
            case 0:
                [self fetchNearbyInfo:@"景点"];
                break;
            case 1:
                [self fetchNearbyInfo:@"美食"];
                break;
            case 2:
                [self fetchNearbyInfo:@"银行"];
                break;
            case 3:
                [self fetchNearbyInfo:@"购物"];
                break;
            case 4:
                [self fetchNearbyInfo:@"娱乐"];
                break;
            default:
                break;
        }
    }
}

- (void)fetchNearbyInfo:(NSString *)poiString
{
    MKLocalSearchRequest *requst = [[MKLocalSearchRequest alloc] init];
    requst.region = _reservedRegion;
    requst.naturalLanguageQuery = poiString; //想要的信息
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:requst];
    
    __weak __typeof(self) weakSelf = self;
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (!error) {
            if (weakSelf.lastSelectedButton.selected) {
                [self.mapView setRegion:response.boundingRegion];
                for (MKMapItem *mapItem in response.mapItems) {
                    eLongMKAnnotation *annotation = [[eLongMKAnnotation alloc] init];
                    annotation.coordinate = mapItem.placemark.coordinate;
                    annotation.title = mapItem.name;
                    annotation.subtitle = mapItem.placemark.thoroughfare;
                    annotation.annotaionType = poiString;
                    [self.mapView addAnnotation:annotation];
                }
            }
        }
    }];
}

- (void)hotelLocationChoice:(UIButton *)selectedButton {
    [self setMapViewRegion:_reservedRegion animated:YES];
    [self.mapView selectAnnotation:self.mapView.pinAnnotation animated:YES];
}

- (void)userLocationChoice:(UIButton *)selectedButton {
    [self goUserLocation];
    [self.mapView selectAnnotation:self.mapView.userLocation animated:YES];
}

- (void)navigationChoice:(UIButton *)selectedButton {
    NSDictionary *options = @{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
    
    MKPlacemark *userPlaceMark = [[MKPlacemark alloc] initWithCoordinate:[[eLongLocation sharedInstance] coordinate]  addressDictionary:nil];
    MKPlacemark *hotelPlaceMark = [[MKPlacemark alloc] initWithCoordinate:_reservedRegion.center  addressDictionary:nil];
    MKMapItem *userMapItem=[[MKMapItem alloc]initWithPlacemark:userPlaceMark];
    userMapItem.name = @"我的位置";
    MKMapItem *hotelMapItem=[[MKMapItem alloc]initWithPlacemark:hotelPlaceMark];
    hotelMapItem.name = self.mapView.pinAnnotation.title;
    
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        // Use class
        [MKMapItem openMapsWithItems:@[userMapItem,hotelMapItem] launchOptions:options];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
