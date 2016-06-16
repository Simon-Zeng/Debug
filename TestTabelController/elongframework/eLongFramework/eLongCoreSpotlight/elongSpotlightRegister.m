//
//  elongSpotlightRegister.m
//  ElongClient
//
//  Created by ksy on 15/9/21.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "elongSpotlightRegister.h"
#import "eLongDefine.h"
#import "NSDictionary+CheckDictionary.h"
#import "JSONKit.h"

@implementation elongSpotlightRegister

+(void)registerSpotlightTitle:(NSString *)title contentDescription:(NSString *)contentDescription thumbnailData:(NSData *)thumbnailData route:(NSString *)routeString params:(NSDictionary *)params
{
    if (![CSSearchableIndex isIndexingAvailable]) {
        return;
    }
    if (!STRINGHASVALUE(routeString)) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    CSSearchableItemAttributeSet *set = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"image"];
    NSMutableArray *keywords = [NSMutableArray array];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if ( [params safeObjectForKey:@"keywords"] &&  [[params safeObjectForKey:@"keywords"] isKindOfClass:[NSArray class]] ) {
        [keywords  addObjectsFromArray:[params safeObjectForKey:@"keywords"]];
        [dicParams removeObjectForKey:@"keywords"];
    }
    if (title) {
        [keywords addObject:title];
    }
    set.keywords =keywords;
    set.title = title;
    set.contentDescription = contentDescription;
    set.thumbnailData = thumbnailData;
    NSString *identifier = nil;
    if (DICTIONARYHASVALUE(dicParams)) {
        identifier = [NSString stringWithFormat:@"%@%@%@",routeString,elongSpotlightSeparated,[dicParams JSONString]];
    }else{
        identifier = routeString;
    }
    //注册过就返回
    NSArray *hotelIds = [eLongUserDefault objectForKey:elongSpotlightHotelIds];
    if ([hotelIds containsObject:identifier] ) {
        return;
    }
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:routeString attributeSet:set];
    [array addObject:item];
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:array completionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSMutableArray *hotelIds = [NSMutableArray arrayWithArray:[eLongUserDefault objectForKey:elongSpotlightHotelIds]];
            if (!hotelIds) {
                hotelIds = [[NSMutableArray alloc] init];
            }
            for (CSSearchableItem *successItem in array) {
                if (![hotelIds containsObject:successItem.uniqueIdentifier]) {
                    [hotelIds addObject:successItem.uniqueIdentifier];
                    //保存
                    [eLongUserDefault setObject:hotelIds forKey:elongSpotlightHotelIds];
                }
            }
        }else{
            NSLog(@"%@ %@" ,error.userInfo ,array);
        }
    }];
}
+ (void)deleteSpotlightRouteDomainIdentifier:(NSString *)routeString
{
    if (![CSSearchableIndex isIndexingAvailable]) {
        return;
    }
    if (!STRINGHASVALUE(routeString)) {
        return;
    }
    NSMutableArray *hotelIds = [NSMutableArray arrayWithArray:[eLongUserDefault objectForKey:elongSpotlightHotelIds]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",routeString];
    NSArray *array = [hotelIds filteredArrayUsingPredicate:pred];
    if (!ARRAYHASVALUE(array)) {
        return;
    }
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:@[routeString] completionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@",error.userInfo);
        if (!error) {
            NSMutableArray *hotelIds = [NSMutableArray arrayWithArray:[eLongUserDefault objectForKey:elongSpotlightHotelIds]];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",routeString];
            NSArray *array = [hotelIds filteredArrayUsingPredicate:pred];
            [hotelIds removeObjectsInArray:array];
            //保存
            [eLongUserDefault setObject:hotelIds forKey:elongSpotlightHotelIds];
        }
    }];
}

+ (void)deleteSpotlightRouteIdentifier:(NSString *)routeString params:(NSDictionary *)params
{
    if (![CSSearchableIndex isIndexingAvailable]) {
        return;
    }
    if (!STRINGHASVALUE(routeString)) {
        return;
    }
    NSString *identifier = nil;
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if ( [params safeObjectForKey:@"keywords"] &&  [[params safeObjectForKey:@"keywords"] isKindOfClass:[NSArray class]] ) {
        [dicParams removeObjectForKey:@"keywords"];
    }
    
    if (DICTIONARYHASVALUE(dicParams)) {
        identifier = [NSString stringWithFormat:@"%@%@%@",routeString,elongSpotlightSeparated,[dicParams JSONString]];
    }else{
        identifier = routeString;
    }
    //没注册过就返回
    NSMutableArray *hotelIds =[NSMutableArray arrayWithArray:[eLongUserDefault objectForKey:elongSpotlightHotelIds]];
    if (![hotelIds containsObject:identifier] ) {
        return;
    }
    
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:@[identifier] completionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@",error.userInfo);
        if (!error) {
             NSMutableArray *hotelIds =[NSMutableArray arrayWithArray:[eLongUserDefault objectForKey:elongSpotlightHotelIds]];
            [hotelIds removeObject:identifier];
            //保存
            [eLongUserDefault setObject:hotelIds forKey:elongSpotlightHotelIds];
        }
    }];
}

+ (NSArray *)identifierSeparated:(NSString *)identifier
{
    NSArray *array = [identifier componentsSeparatedByString:elongSpotlightSeparated];
    NSMutableArray *separatedArray = [NSMutableArray arrayWithArray:array];
    if ([array count] == 2 ) {
        id type = [array[1] objectFromJSONString];
        if ([type isKindOfClass:[NSDictionary class]]) {
            [separatedArray replaceObjectAtIndex:1 withObject:type];
        }else{
            [separatedArray replaceObjectAtIndex:1 withObject:[NSDictionary dictionary]];
        }
        return separatedArray;
    }else{
        [separatedArray addObject:[NSDictionary dictionary]];
        return separatedArray;
    }
    
}

@end
