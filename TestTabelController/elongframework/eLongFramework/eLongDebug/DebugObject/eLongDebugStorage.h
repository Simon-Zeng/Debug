//
//  eLongDebugStorage.h
//  ElongClient
//
//  Created by Kirn on 15/3/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugObject.h"
#import "eLongDebugUserDefaultModel.h"
#import "eLongDebugKeychainModel.h"

@interface eLongDebugStorage : eLongDebugObject
/**
 *  NSUserDefault数据
 *
 *  @return NSUserDefaults
 */
- (NSArray *) userDefaults;

/**
 *  Keychain数据
 *
 *  @return Keychains
 */
- (NSArray *) keychains;
@end
