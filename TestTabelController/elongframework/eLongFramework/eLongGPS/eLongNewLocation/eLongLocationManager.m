//
//  eLongLocationManager.m
//  TestLocation
//
//  Created by top on 15/12/29.
//  Copyright © 2015年 robotnik911. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>

#import "eLongLocationManager.h"
#import "eLongLocationRequest.h"

@interface eLongLocationManager () <eLongLocationRequestDelegate, CLLocationManagerDelegate, BMKGeneralDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, assign) BOOL isMonitoringSignificantLocationChanges;

@property (nonatomic, assign) BOOL isUpdatingLocation;

@property (nonatomic, assign) BOOL updateFailed;

@property (nonatomic, strong) NSArray *locationRequests;

@property (nonatomic,strong) BMKMapManager *bmkMap;

@end

@implementation eLongLocationManager

- (instancetype)init
{
    NSAssert(_sharedInstance == nil, @"Only one instance of eLongLocationManager should be created. Use +[eLongLocationManager sharedInstance] instead.");
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
#ifdef __IPHONE_8_4
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_4
        /* iOS 9 requires setting allowsBackgroundLocationUpdates to YES in order to receive background location updates.
         We only set it to YES if the location background mode is enabled for this app, as the documentation suggests it is a
         fatal programmer error otherwise. */
        NSArray *backgroundModes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
        if ([backgroundModes containsObject:@"location"]) {
            if ([_locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
                [_locationManager setAllowsBackgroundLocationUpdates:YES];
            }
        }
#endif /* __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_4 */
#endif /* __IPHONE_8_4 */
        
        _locationRequests = @[];
        
        // 初始化百度地址解析服务
        _bmkMap =[[BMKMapManager alloc] init];
        BOOL testbool = [_bmkMap start:@"cr7W1mRzk1fMR9FSpL0MmSr8" generalDelegate:self];
        if (testbool) {
            NSLog(@"testbool ");
        }else{
            NSLog(@"failure");
        }
    }
    return self;
}

#pragma mark - public method
static id _sharedInstance;

+ (instancetype)sharedInstance {
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (eLongLocationServicesState)locationServicesState {
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return eLongLocationServicesStateDisabled;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return eLongLocationServicesStateNotDetermined;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return eLongLocationServicesStateDenied;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return eLongLocationServicesStateRestricted;
    }
    return eLongLocationServicesStateAvailable;
}

- (eLongLocationRequestID)requestLocationWithDesiredAccuracy:(eLongLocationAccuracy)desiredAccuracy
                                                     timeout:(NSTimeInterval)timeout
                                                       block:(eLongLocationRequestBlock)block {
    return [self requestLocationWithDesiredAccuracy:desiredAccuracy
                                            timeout:timeout
                               delayUntilAuthorized:NO
                                              block:block];
    
}

- (eLongLocationRequestID)requestLocationWithDesiredAccuracy:(eLongLocationAccuracy)desiredAccuracy
                                                     timeout:(NSTimeInterval)timeout
                                        delayUntilAuthorized:(BOOL)delayUntilAuthorized
                                                       block:(eLongLocationRequestBlock)block {
    NSAssert([NSThread isMainThread], @"eLongLocationManager should only be called from the main thread.");
    
    if (desiredAccuracy == eLongLocationAccuracyNone) {
        NSAssert(desiredAccuracy != eLongLocationAccuracyNone, @"eLongLocationAccuracyNone is not a valid desired accuracy.");
        desiredAccuracy = eLongLocationAccuracyCity; // default to the lowest valid desired accuracy
    }
    
    eLongLocationRequest *locationRequest = [[eLongLocationRequest alloc] initWithType:eLongLocationRequestTypeSingle];
    locationRequest.delegate = self;
    locationRequest.desiredAccuracy = desiredAccuracy;
    locationRequest.timeout = timeout;
    locationRequest.block = block;
    
    BOOL deferTimeout = delayUntilAuthorized && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
    if (!deferTimeout) {
        [locationRequest startTimeoutTimerIfNeeded];
    }
    
    [self addLocationRequest:locationRequest];
    
    return locationRequest.requestID;
    
}

- (eLongLocationRequestID)subscribeToLocationUpdatesWithBlock:(eLongLocationRequestBlock)block {
    return [self subscribeToLocationUpdatesWithDesiredAccuracy:eLongLocationAccuracyRoom
                                                         block:block];
}

- (eLongLocationRequestID)subscribeToLocationUpdatesWithDesiredAccuracy:(eLongLocationAccuracy)desiredAccuracy
                                                                  block:(eLongLocationRequestBlock)block {
    NSAssert([NSThread isMainThread], @"eLongLocationManager should only be called from the main thread.");
    
    eLongLocationRequest *locationRequest = [[eLongLocationRequest alloc] initWithType:eLongLocationRequestTypeSubscription];
    locationRequest.desiredAccuracy = desiredAccuracy;
    locationRequest.block = block;
    
    [self addLocationRequest:locationRequest];
    
    return locationRequest.requestID;
    
}

- (eLongLocationRequestID)subscribeToSignificantLocationChangesWithBlock:(eLongLocationRequestBlock)block {
    NSAssert([NSThread isMainThread], @"eLongLocationManager should only be called from the main thread.");
    
    eLongLocationRequest *locationRequest = [[eLongLocationRequest alloc] initWithType:eLongLocationRequestTypeSignificantChanges];
    locationRequest.block = block;
    
    [self addLocationRequest:locationRequest];
    
    return locationRequest.requestID;
}

- (void)forceCompleteLocationRequest:(eLongLocationRequestID)requestID {
    NSAssert([NSThread isMainThread], @"eLongLocationManager should only be called from the main thread.");
    
    for (eLongLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.requestID == requestID) {
            if (locationRequest.isRecurring) {
                // Recurring requests can only be canceled
                [self cancelLocationRequest:requestID];
            } else {
                [locationRequest forceTimeout];
                [self completeLocationRequest:locationRequest];
            }
            break;
        }
    }
}

- (void)cancelLocationRequest:(eLongLocationRequestID)requestID {
    NSAssert([NSThread isMainThread], @"eLongLocationManager should only be called from the main thread.");
    
    for (eLongLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.requestID == requestID) {
            [locationRequest cancel];
            [self removeLocationRequest:locationRequest];
            break;
        }
    }
}

#pragma mark - Internal methods
- (void)addLocationRequest:(eLongLocationRequest *)locationRequest {
    eLongLocationServicesState locationServicesState = [eLongLocationManager locationServicesState];
    if (locationServicesState == eLongLocationServicesStateDisabled ||
        locationServicesState == eLongLocationServicesStateDenied ||
        locationServicesState == eLongLocationServicesStateRestricted) {
        [self completeLocationRequest:locationRequest];
        return;
    }
    
    switch (locationRequest.type) {
        case eLongLocationRequestTypeSingle:
        case eLongLocationRequestTypeSubscription:
        {
            eLongLocationAccuracy maximumDesiredAccuracy = eLongLocationAccuracyNone;
            for (eLongLocationRequest *locationRequest in [self activeLocationRequestsExcludingType:eLongLocationRequestTypeSignificantChanges]) {
                if (locationRequest.desiredAccuracy > maximumDesiredAccuracy) {
                    maximumDesiredAccuracy = locationRequest.desiredAccuracy;
                }
            }
            maximumDesiredAccuracy = MAX(locationRequest.desiredAccuracy, maximumDesiredAccuracy);
            [self updateWithMaximumDesiredAccuracy:maximumDesiredAccuracy];
            
            [self startUpdatingLocationIfNeeded];
        }
            break;
        case eLongLocationRequestTypeSignificantChanges:
            [self startMonitoringSignificantLocationChangesIfNeeded];
            break;
    }
    NSMutableArray *newLocationRequests = [NSMutableArray arrayWithArray:self.locationRequests];
    [newLocationRequests addObject:locationRequest];
    self.locationRequests = newLocationRequests;
    [self processLocationRequests];
}

- (void)completeLocationRequest:(eLongLocationRequest *)locationRequest {
    if (!locationRequest) {
        return;
    }
    
    [locationRequest complete];
    [self removeLocationRequest:locationRequest];
    
    eLongLocationStatus status = [self statusForLocationRequest:locationRequest];
    CLLocation *currentLocation = self.currentLocation;
    eLongLocationAccuracy achievedAccuracy = [self achievedAccuracyForLocation:currentLocation];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (locationRequest.block) {
            locationRequest.block(currentLocation, achievedAccuracy, status);
        }
    });
}

- (void)completeAllLocationRequests {
    NSArray *locationRequests = [self.locationRequests copy];
    for (eLongLocationRequest *locationRequest in locationRequests) {
        [self completeLocationRequest:locationRequest];
    }
}

- (void)processRecurringRequest:(eLongLocationRequest *)locationRequest {
    NSAssert(locationRequest.isRecurring, @"This method should only be called for recurring location requests.");
    
    eLongLocationStatus status = [self statusForLocationRequest:locationRequest];
    CLLocation *currentLocation = self.currentLocation;
    eLongLocationAccuracy achievedAccuracy = [self achievedAccuracyForLocation:currentLocation];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (locationRequest.block) {
            locationRequest.block(currentLocation, achievedAccuracy, status);
        }
    });
}

- (NSArray *)activeLocationRequestsWithType:(eLongLocationRequestType)locationRequestType {
    return [self.locationRequests filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(eLongLocationRequest *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.type == locationRequestType;
    }]];
}

- (NSArray *)activeLocationRequestsExcludingType:(eLongLocationRequestType)locationRequestType {
    return [self.locationRequests filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(eLongLocationRequest *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.type != locationRequestType;
    }]];
}

- (eLongLocationStatus)statusForLocationRequest:(eLongLocationRequest *)locationRequest {
    eLongLocationServicesState locationServicesState = [eLongLocationManager locationServicesState];
    
    if (locationServicesState == eLongLocationServicesStateDisabled) {
        return eLongLocationStatusServicesDisabled;
    } else if (locationServicesState == eLongLocationServicesStateNotDetermined) {
        return eLongLocationStatusServicesNotDetermined;
    } else if (locationServicesState == eLongLocationServicesStateDenied) {
        return eLongLocationStatusServicesDenied;
    } else if (locationServicesState == eLongLocationServicesStateRestricted) {
        return eLongLocationStatusServicesRestricted;
    } else if (self.updateFailed) {
        return eLongLocationStatusError;
    } else if (locationRequest.hasTimedOut) {
        return eLongLocationStatusTimedOut;
    }
    return eLongLocationStatusSuccess;
}

- (eLongLocationAccuracy)achievedAccuracyForLocation:(CLLocation *)location {
    if (!location) {
        return eLongLocationAccuracyNone;
    }
    
    NSTimeInterval timeSinceUpdate = fabs([location.timestamp timeIntervalSinceNow]);
    CLLocationAccuracy horizontalAccuracy = location.horizontalAccuracy;
    
    if (horizontalAccuracy <= kHorizontalAccuracyThresholdRoom &&
        timeSinceUpdate <= kUpdateTimeStaleThresholdRoom) {
        return eLongLocationAccuracyRoom;
    } else if (horizontalAccuracy <= kHorizontalAccuracyThresholdHouse &&
             timeSinceUpdate <= kUpdateTimeStaleThresholdHouse) {
        return eLongLocationAccuracyHouse;
    } else if (horizontalAccuracy <= kHorizontalAccuracyThresholdBlock &&
             timeSinceUpdate <= kUpdateTimeStaleThresholdBlock) {
        return eLongLocationAccuracyBlock;
    } else if (horizontalAccuracy <= kHorizontalAccuracyThresholdNeighborhood &&
             timeSinceUpdate <= kUpdateTimeStaleThresholdNeighborhood) {
        return eLongLocationAccuracyNeighborhood;
    } else if (horizontalAccuracy <= kHorizontalAccuracyThresholdCity &&
             timeSinceUpdate <= kUpdateTimeStaleThresholdCity) {
        return eLongLocationAccuracyCity;
    } else {
        return eLongLocationAccuracyNone;
    }
}

- (void)requestAuthorizationIfNeeded {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
        BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
        if (hasAlwaysKey) {
            [self.locationManager requestAlwaysAuthorization];
        } else if (hasWhenInUseKey) {
            [self.locationManager requestWhenInUseAuthorization];
        } else {
            NSAssert(hasAlwaysKey || hasWhenInUseKey, @"To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.");
        }
    }
#endif /* __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 */
}

- (void)updateWithMaximumDesiredAccuracy:(eLongLocationAccuracy)maximumDesiredAccuracy {
    switch (maximumDesiredAccuracy) {
        case eLongLocationAccuracyNone:
            break;
        case eLongLocationAccuracyCity:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyThreeKilometers) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            }
            break;
        case eLongLocationAccuracyNeighborhood:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyKilometer) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            }
            break;
        case eLongLocationAccuracyBlock:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyHundredMeters) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            }
            break;
        case eLongLocationAccuracyHouse:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyNearestTenMeters) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            }
            break;
        case eLongLocationAccuracyRoom:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyBest) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            }
            break;
        default:
            NSAssert(nil, @"Invalid maximum desired accuracy!");
            break;
    }
}

- (void)startMonitoringSignificantLocationChangesIfNeeded {
    [self requestAuthorizationIfNeeded];
    
    NSArray *locationRequests = [self activeLocationRequestsWithType:eLongLocationRequestTypeSignificantChanges];
    if (locationRequests.count == 0) {
        [self.locationManager startMonitoringSignificantLocationChanges];
        if (self.isMonitoringSignificantLocationChanges == NO) {
        }
        self.isMonitoringSignificantLocationChanges = YES;
    }
}

- (void)startUpdatingLocationIfNeeded {
    [self requestAuthorizationIfNeeded];
    
    NSArray *locationRequests = [self activeLocationRequestsExcludingType:eLongLocationRequestTypeSignificantChanges];
    if (locationRequests.count == 0) {
        [self.locationManager startUpdatingLocation];
        if (self.isUpdatingLocation == NO) {
        }
        self.isUpdatingLocation = YES;
    }
}

- (void)stopMonitoringSignificantLocationChangesIfPossible {
    NSArray *locationRequests = [self activeLocationRequestsWithType:eLongLocationRequestTypeSignificantChanges];
    if (locationRequests.count == 0) {
        [self.locationManager stopMonitoringSignificantLocationChanges];
        if (self.isMonitoringSignificantLocationChanges) {
        }
        self.isMonitoringSignificantLocationChanges = NO;
    }
}

- (void)stopUpdatingLocationIfPossible {
    NSArray *locationRequests = [self activeLocationRequestsExcludingType:eLongLocationRequestTypeSignificantChanges];
    if (locationRequests.count == 0) {
        [self.locationManager stopUpdatingLocation];
        if (self.isUpdatingLocation) {
        }
        self.isUpdatingLocation = NO;
    }
}

- (void)processLocationRequests {
    CLLocation *mostRecentLocation = self.currentLocation;
    
    for (eLongLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.hasTimedOut) {
            [self completeLocationRequest:locationRequest];
            continue;
        }
        
        if (mostRecentLocation != nil) {
            if (locationRequest.isRecurring) {
                [self processRecurringRequest:locationRequest];
                continue;
            } else {
                NSTimeInterval currentLocationTimeSinceUpdate = fabs([mostRecentLocation.timestamp timeIntervalSinceNow]);
                CLLocationAccuracy currentLocationHorizontalAccuracy = mostRecentLocation.horizontalAccuracy;
                NSTimeInterval staleThreshold = [locationRequest updateTimeStaleThreshold];
                CLLocationAccuracy horizontalAccuracyThreshold = [locationRequest horizontalAccuracyThreshold];
                if (currentLocationTimeSinceUpdate <= staleThreshold &&
                    currentLocationHorizontalAccuracy <= horizontalAccuracyThreshold) {
                    [self completeLocationRequest:locationRequest];
                    continue;
                }
            }
        }
    }
}

- (void)removeLocationRequest:(eLongLocationRequest *)locationRequest {
    NSMutableArray *newLocationRequests = [NSMutableArray arrayWithArray:self.locationRequests];
    [newLocationRequests removeObject:locationRequest];
    self.locationRequests = newLocationRequests;
    
    switch (locationRequest.type) {
        case eLongLocationRequestTypeSingle:
        case eLongLocationRequestTypeSubscription:
        {
            eLongLocationAccuracy maximumDesiredAccuracy = eLongLocationAccuracyNone;
            for (eLongLocationRequest *locationRequest in [self activeLocationRequestsExcludingType:eLongLocationRequestTypeSignificantChanges]) {
                if (locationRequest.desiredAccuracy > maximumDesiredAccuracy) {
                    maximumDesiredAccuracy = locationRequest.desiredAccuracy;
                }
            }
            [self updateWithMaximumDesiredAccuracy:maximumDesiredAccuracy];
            
            [self stopUpdatingLocationIfPossible];
        }
            break;
        case eLongLocationRequestTypeSignificantChanges:
            [self stopMonitoringSignificantLocationChangesIfPossible];
            break;
    }
}

#pragma mark - eLongLocationRequestDelegate method
- (void)locationRequestDidTimeout:(eLongLocationRequest *)locationRequest {
    for (eLongLocationRequest *activeLocationRequest in self.locationRequests) {
        if (activeLocationRequest.requestID == locationRequest.requestID) {
            [self completeLocationRequest:locationRequest];
            break;
        }
    }
}

#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.updateFailed = NO;
    
    CLLocation *mostRecentLocation = [locations lastObject];
    self.currentLocation = mostRecentLocation;
    
    [self processLocationRequests];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.updateFailed = YES;
    
    for (eLongLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.isRecurring) {
            [self processRecurringRequest:locationRequest];
        } else {
            [self completeLocationRequest:locationRequest];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        [self completeAllLocationRequests];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
#else
    else if (status == kCLAuthorizationStatusAuthorized) {
#endif /* __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 */
        for (eLongLocationRequest *locationRequest in self.locationRequests) {
            [locationRequest startTimeoutTimerIfNeeded];
        }
    }
}

#pragma mark - BMKGeneralDelegate
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
    
@end