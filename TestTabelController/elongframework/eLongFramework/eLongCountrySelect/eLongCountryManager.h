//
//  eLongCountryManager.h
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/21.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^eLongCountryListCallBack)(NSArray *list);

@interface eLongCountryManager : NSObject

- (void)getCountryList:(eLongCountryListCallBack)callBack;

@end
