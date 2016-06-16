//
//  eLongNetworkDynamicCommunicationAPIAndVersionModel.h
//  ElongClient
//
//  Created by top on 16/3/10.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface eLongNetworkDynamicCommunicationAPIAndVersionModel : JSONModel

@property (nonatomic, strong) NSMutableArray<Optional> *whitelist;

@property (nonatomic, strong) NSMutableArray<Optional> *blacklist;

@property (nonatomic, assign) long negoversion;

@end
