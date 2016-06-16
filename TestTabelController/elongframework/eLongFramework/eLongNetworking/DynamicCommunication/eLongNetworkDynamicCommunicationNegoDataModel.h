//
//  eLongNetworkDynamicCommunicationNegoDataModel.h
//  ElongClient
//
//  Created by top on 16/3/10.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface eLongNetworkDynamicCommunicationNegoDataModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *negoKey;

@property (nonatomic, copy) NSString<Optional> *sign;

@property (nonatomic, copy) NSString<Optional> *url;

@property (nonatomic, strong) NSArray<Optional> *whitelist;

@property (nonatomic, strong) NSArray<Optional> *blacklist;

@property (nonatomic, assign) long negoversion;

@end
