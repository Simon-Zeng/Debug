//
//  eLongCountryManager.m
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/21.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongCountryManager.h"
#import "eLongUserdefault.h"
#import "eLongDefine.h"
#import "eLongHTTPRequest.h"
#import "eLongNetworkRequest.h"
#import "eLongNetUtil.h"
#import "eLongCountryListModel.h"

#define ELONG_COUNTRY_DATA_VERSION             @"ELONG_COUNTRY_DATA_VERSION"
#define kForeignCardCountryDataDirectoryPath   @"ForeignCardCountryData"          //外卡国家列表文件夹
#define kForeignCardCountryPlistName           @"foreignCardCountry_s.plist"      //外卡国家列表文件名

typedef void(^countryListCallBack)(eLongCountryListModel *listModel);

@interface eLongCountryManager()

@property (nonatomic, copy) eLongCountryListCallBack listCallBack;

@end

@implementation eLongCountryManager

- (void)getCountryList:(eLongCountryListCallBack)callBack
{
    self.listCallBack = callBack;
    NSString *version = [eLongUserDefault objectForKey:ELONG_COUNTRY_DATA_VERSION];
    
    [self getCountryListWithVersion:version callBack:^(eLongCountryListModel *listModel) {
        
        if (listModel && ARRAYHASVALUE(listModel.countryList)) { // 本地没有数据或者服务器数据有更新
            
            NSString *dataVersion = listModel.dataVersion;
            
            [self writeListCacheToLocal:listModel dataVersion:dataVersion];
            
            callBack(listModel.countryList);
        }
        else if (STRINGHASVALUE(version)) { // 本地有数据并且服务器数据没有更新
            
            NSArray *list = [self getCountryListFromLocal];
            callBack(list);
        }
        else {
            
            callBack(nil);
        }
    }];
}

- (void)getCountryListWithVersion:(NSString *)version callBack:(countryListCallBack)callBack
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    
    if (STRINGHASVALUE(version)) {
        
        [content setObject:version forKey:@"dataVersion"];
    }
    else {
        
        [content setObject:@"" forKey:@"dataVersion"];
    }
    
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"myelong/getCountryList"
                                                                       params:content
                                                                       method:eLongNetworkRequestMethodGET];
    
    [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *operation, id responseObject) {
        
        if ([eLongNetUtil checkJsonIsErrorNoAlert:responseObject]) {
            
            callBack(nil);
        }
        else {
            
            eLongCountryListModel *listModel = [[eLongCountryListModel alloc] initWithDictionary:responseObject error:nil];
            callBack(listModel);
        }
        
    } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
        
        callBack(nil);
    }];
}

- (NSMutableArray *)getCountryListFromLocal
{
    NSMutableArray *arr = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kForeignCardCountryDataDirectoryPath];
    cPath = [cPath stringByAppendingPathComponent:kForeignCardCountryPlistName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cPath]) {
        
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:cPath];
        eLongCountryListModel *listModel = [[eLongCountryListModel alloc] initWithDictionary:dict error:nil];
        arr = [[NSMutableArray alloc] initWithArray:listModel.countryList];
    }
    
    return arr;
}

- (BOOL)writeListCacheToLocal:(eLongCountryListModel *)list dataVersion:(NSString *)dataVersion
{
    BOOL success = NO;
    
    if (STRINGHASVALUE(dataVersion)) {
        
        NSDictionary *parseData = [list toDictionary];
        
        //生成plist
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *cPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kForeignCardCountryDataDirectoryPath];
        
        //检测是否存在
        if (![[NSFileManager defaultManager] fileExistsAtPath:cPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        cPath = [cPath stringByAppendingPathComponent:kForeignCardCountryPlistName];
        
        //保存
        success = [parseData writeToFile:cPath atomically:YES];
        
        //保存版本
        if (success) {
            
            [eLongUserDefault setObject:dataVersion forKey:ELONG_COUNTRY_DATA_VERSION];
        }
    }
    
    return success;
}

@end
