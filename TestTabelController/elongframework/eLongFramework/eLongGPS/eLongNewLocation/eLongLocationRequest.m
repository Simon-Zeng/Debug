//
//  eLongLocationRequest.m
//  TestLocation
//
//  Created by top on 15/12/29.
//  Copyright © 2015年 robotnik911. All rights reserved.
//

#import "eLongLocationRequest.h"

@interface eLongLocationRequest ()

@property (nonatomic, assign, readwrite) BOOL hasTimedOut;

@property (nonatomic, strong) NSDate *requestStartTime;

@property (nonatomic, strong) NSTimer *timeoutTimer;

@end

@implementation eLongLocationRequest

static eLongLocationRequestID _nextRequestID = 0;

+ (eLongLocationRequestID)getUniqueRequestID {
    _nextRequestID++;
    return _nextRequestID;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use initWithType: instead." userInfo:nil];
    return [self initWithType:eLongLocationRequestTypeSingle];
}

#pragma mark - public method
- (instancetype)initWithType:(eLongLocationRequestType)type {
    self = [super init];
    if (self) {
        _requestID = [eLongLocationRequest getUniqueRequestID];
        _type = type;
        _hasTimedOut = NO;
    }
    return self;
}

- (void)complete {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    self.requestStartTime = nil;
}

- (void)forceTimeout {
    if (self.isRecurring == NO) {
        self.hasTimedOut = YES;
    } else {
        NSAssert(self.isRecurring == NO, @"Only single location requests (not recurring requests) should ever be considered timed out.");
    }
}

- (void)cancel {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    self.requestStartTime = nil;
}

- (void)startTimeoutTimerIfNeeded {
    if (self.timeout > 0 && !self.timeoutTimer) {
        self.requestStartTime = [NSDate date];
        self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(timeoutTimerFired:) userInfo:nil repeats:NO];
    }
}

- (NSTimeInterval)updateTimeStaleThreshold {
    switch (self.desiredAccuracy) {
        case eLongLocationAccuracyRoom:
            return kUpdateTimeStaleThresholdRoom;
            break;
        case eLongLocationAccuracyHouse:
            return kUpdateTimeStaleThresholdHouse;
            break;
        case eLongLocationAccuracyBlock:
            return kUpdateTimeStaleThresholdBlock;
            break;
        case eLongLocationAccuracyNeighborhood:
            return kUpdateTimeStaleThresholdNeighborhood;
            break;
        case eLongLocationAccuracyCity:
            return kUpdateTimeStaleThresholdCity;
            break;
        default:
            NSAssert(NO, @"Unknown desired accuracy.");
            return 0.0;
            break;
    }
}

- (CLLocationAccuracy)horizontalAccuracyThreshold {
    switch (self.desiredAccuracy) {
        case eLongLocationAccuracyRoom:
            return kHorizontalAccuracyThresholdRoom;
            break;
        case eLongLocationAccuracyHouse:
            return kHorizontalAccuracyThresholdHouse;
            break;
        case eLongLocationAccuracyBlock:
            return kHorizontalAccuracyThresholdBlock;
            break;
        case eLongLocationAccuracyNeighborhood:
            return kHorizontalAccuracyThresholdNeighborhood;
            break;
        case eLongLocationAccuracyCity:
            return kHorizontalAccuracyThresholdCity;
            break;
        default:
            NSAssert(NO, @"Unknown desired accuracy.");
            return 0.0;
            break;
    }
}

- (BOOL)isRecurring {
    return (self.type == eLongLocationRequestTypeSubscription) || (self.type == eLongLocationRequestTypeSignificantChanges);
}

- (NSTimeInterval)timeAlive {
    if (self.requestStartTime == nil) {
        return 0.0;
    }
    return fabs([self.requestStartTime timeIntervalSinceNow]);
}

#pragma mark - internal method
- (void)timeoutTimerFired:(NSTimer *)timer {
    self.hasTimedOut = YES;
    [self.delegate locationRequestDidTimeout:self];
}

- (BOOL)hasTimedOut {
    if (self.timeout > 0.0 && self.timeAlive > self.timeout) {
        _hasTimedOut = YES;
    }
    return _hasTimedOut;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    if (((eLongLocationRequest *)object).requestID == self.requestID) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return [[NSString stringWithFormat:@"%ld", (long)self.requestID] hash];
}

- (void)dealloc {
    [_timeoutTimer invalidate];
}

@end
