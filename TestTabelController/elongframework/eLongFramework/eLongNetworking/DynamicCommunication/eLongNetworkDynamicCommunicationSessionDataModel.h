//
//  eLongNetworkDynamicCommunicationSessionDataModel.h
//  ElongClient
//
//  Created by top on 16/3/10.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface eLongNetworkDynamicCommunicationSessionDataModel : JSONModel

@property (nonatomic, copy) NSString *sessionkey;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *expiredTime;

@property (nonatomic, copy) NSString *status;

@end
