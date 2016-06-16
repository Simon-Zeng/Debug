//
//  eLongDebugKeychainModel.h
//  ElongClient
//
//  Created by Kirn on 15/3/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongDebugKeychainModel : NSObject
/**
 *  key
 */
@property (nonatomic,copy) NSString *key;
/**
 *  value
 */
@property (nonatomic,copy) NSString *value;
@end
