//
//  eLongDebugBusinessLine.m
//  ElongClient
//
//  Created by Kirn on 15/3/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugBusinessLine.h"
#import "eLongDebugDB.h"

static NSString *businessDebugModelName = @"Business";        // 业务线储数据表名

@implementation eLongDebugBusinessLine


- (void) addBusinessLineName:(NSString *)name tag:(NSUInteger)tag{
    if (!self.enabled) {
        return;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    
    // 新增server model
    eLongDebugBusinessModel *businessModel = [debugDB insertEntity:businessDebugModelName];
    businessModel.name = name;
    businessModel.tag = @(tag);
    businessModel.enabled = @(YES);
    
    // 存储入库
    [debugDB saveContext];
}

- (void) removeBusinessLine:(eLongDebugBusinessModel *)businessModel{
    if (!self.enabled) {
        return;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB remove:businessModel];
    
    [debugDB saveContext];
}

- (BOOL) isEnabled:(eLongDebugBLType)type{
    if (!self.enabled) {
        // 全部可用
        return YES;
    }
    NSArray *businessLines = [self businessLines];
    for (eLongDebugBusinessModel *model in businessLines) {
        if ([model.enabled boolValue] && [model.tag integerValue] == type) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *) businessLines{
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    NSArray *servers = [debugDB selectDataFromEntity:businessDebugModelName query:nil];
    if (servers && servers.count) {
        return servers;
    }else{
        // 在没有数据的情况下返回固定数据
        NSArray *tempBusinessLines = @[@{@"name":@"顶部广告",@"tag":@(eLongDebugBLTopAd),@"enabled":@(YES)},
                                       @{@"name":@"底部广告",@"tag":@(eLongDebugBLBottomAd),@"enabled":@(YES)},
                                       @{@"name":@"酒店",@"tag":@(eLongDebugBLHotel),@"enabled":@(YES)},
                                       @{@"name":@"今日特价",@"tag":@(eLongDebugBLLMHotel),@"enabled":@(YES)},
                                       @{@"name":@"团购酒店",@"tag":@(eLongDebugBLGrouponHotel),@"enabled":@(YES)},
                                       @{@"name":@"附近酒店",@"tag":@(eLongDebugBLNearbyHotel),@"enabled":@(YES)},
                                       @{@"name":@"公寓",@"tag":@(eLongDebugBLApartment),@"enabled":@(YES)},
                                       @{@"name":@"机票",@"tag":@(eLongDebugBLFlight),@"enabled":@(YES)},
                                       @{@"name":@"火车",@"tag":@(eLongDebugBLTrain),@"enabled":@(YES)},
                                       @{@"name":@"用车",@"tag":@(eLongDebugBLTexi),@"enabled":@(YES)},
                                       @{@"name":@"当地",@"tag":@(eLongDebugBLLocation),@"enabled":@(YES)},
                                       @{@"name":@"旅行清单",@"tag":@(eLongDebugBLTravelList),@"enabled":@(YES)},
                                       @{@"name":@"汇率",@"tag":@(eLongDebugBLExchangeRate),@"enabled":@(YES)},
                                       @{@"name":@"找驴友",@"tag":@(eLongDebugBLLvyou),@"enabled":@(YES)},
                                       @{@"name":@"意见反馈",@"tag":@(eLongDebugBLFeedback),@"enabled":@(YES)},
                                       @{@"name":@"首页",@"tag":@(eLongDebugBLHome),@"enabled":@(YES)},
                                       @{@"name":@"订单",@"tag":@(eLongDebugBLOrder),@"enabled":@(YES)},
                                       @{@"name":@"客服",@"tag":@(eLongDebugBLCallCenter),@"enabled":@(YES)},
                                       @{@"name":@"我的",@"tag":@(eLongDebugBLMyElong),@"enabled":@(YES)},
                                       @{@"name":@"各类成单",@"tag":@(eLongDebugBLBooking),@"enabled":@(YES)},
                                       @{@"name":@"汽车票",@"tag":@(eLongDebugBLBus),@"enabled":@(YES)},
                                       @{@"name":@"首页活动动画",@"tag":@(eLongDebugBLHomeActivityAnimation),@"enabled":@(YES)}];
        
        NSMutableArray *staticBusinessLines = [NSMutableArray array];
        eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
        for (NSDictionary *dict in tempBusinessLines) {
            eLongDebugBusinessModel *businessModel = [debugDB insertEntity:businessDebugModelName];
            businessModel.name = dict[@"name"];
            businessModel.tag = dict[@"tag"];
            businessModel.enabled = dict[@"enabled"];
            [staticBusinessLines addObject:businessModel];
        }
        [debugDB saveContext];
        return staticBusinessLines;
    }
}

- (void) saveBusinessLine:(eLongDebugBusinessModel *)businessLineModel{
    if (!self.enabled) {
        return;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB saveContext];
}

@end
