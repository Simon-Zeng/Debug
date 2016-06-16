//
//  AdvertisementBusiness.m
//  ElongClient
//
//  Created by zhaoyingze on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAdBusiness.h"
#import <sys/sysctl.h>
#import "eLongHTTPRequest.h"
#import <UIKit/UIKit.h>
#import "eLongDefine.h"
#import "eLongNetworking.h"
#import "eLongNetUtil.h"
#import "eLongAdsResultModel.h"

@interface eLongAdBusiness()<eLongHTTPRequestDelegate>

@property (nonatomic,strong) NSArray *adKeyArray;
@property (nonatomic,strong) eLongHTTPRequest *adRequest;
@property (nonatomic,strong) eLongHTTPRequestOperation *adRequestOperation;


@end

@implementation eLongAdBusiness
- (NSArray *)adKeyArray{
    if (!_adKeyArray) {
        _adKeyArray = @[@"Default",@"HotelSearch",@"FlightSearch",@"RailwaySearch",@"HotelPayCounter",@"FlightPayCounter",@"GrouponPayCounter",@"HomePage",@"HotelList",@"FlatOne",@"FlatTwo",@"FlatThree",@"SplashScreen",@"H5Business",@"H5Activity",@"FlatList",@"H5ActivityPage",@"GlobalHotelListPage",@"H5GlobalHotelIndexPage",@"GlobalHotelIndexPage",@"FindlHotelIndexPage"];
    }
    return _adKeyArray;
}
- (id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)dealloc
{
    if (self.adRequestOperation) {
        [self.adRequestOperation cancel];
        self.adRequestOperation = nil;
    }
}
+ (void)getAdvInfoWithCountry:(NSString *)country city:(NSString *)city pageType:(AdPageType)pageType adInfoBlock:(adInfoBlock)adInfoBlock failureBlock:(failureBlock)failureBlock{
    eLongAdBusiness *adBusiness = [[eLongAdBusiness alloc] init];
    if (adBusiness.adRequestOperation) {
        [adBusiness.adRequestOperation cancel];
        adBusiness.adRequestOperation = nil;
    }
#if TARGET_IPHONE_SIMULATOR
    NSString *phoneType = @"iPhone Simulator";
#else
    size_t size = 256;
    char *machine = malloc(size);
#if TARGET_OS_IPHONE
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
#else
    sysctlbyname("hw.model", machine, &size, NULL, 0);
#endif
    NSString *phoneType = [[NSString alloc] initWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
#endif
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    NSString *dimension = [NSString stringWithFormat:@"%.f*%.f",SCREEN_WIDTH * scale,SCREEN_HEIGHT * scale];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:dimension forKey:@"dimension"];
    [dict setObject:phoneType forKey:@"phoneType"];
    
    if (STRINGHASVALUE(city)) {
        
        [dict setObject:city forKey:@"city"];
    }
    if (STRINGHASVALUE(country)) {
        [dict setObject:country forKey:@"country"];
    }
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"adv/advInfos"
                                                                       params:dict
                                                                       method:eLongNetworkRequestMethodGET];
    adBusiness.adRequestOperation = [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *operation, id responseObject) {
        if ([eLongNetUtil checkJsonIsErrorNoAlert:responseObject]) {
            return;
        }
        eLongAdsResultModel *resultModel = [[eLongAdsResultModel alloc] initWithDictionary:responseObject error:nil];
        for (eLongAdPageResultModel *pageModel in resultModel.pages) {
            if ([pageModel.key isEqualToString:[adBusiness.adKeyArray objectAtIndex:pageType]]) {
                if (adInfoBlock) {
                    for (eLongAdvInfoModel *infoModel in pageModel.infos) {
                        NSMutableString *urlStr  = [NSMutableString stringWithString:infoModel.jumpLink];
                        NSRange urlRange = [urlStr rangeOfString:@"gotourl:"];
                        if (urlRange.location != NSNotFound) {
                            [urlStr deleteCharactersInRange:urlRange];
                            infoModel.jumpLink = urlStr;
                            
                        }
                        
                    }
                    adInfoBlock(pageModel.infos);
                }
                break;
            }
        }
    } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}



@end
