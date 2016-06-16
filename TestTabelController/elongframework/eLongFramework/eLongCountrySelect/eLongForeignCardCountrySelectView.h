//
//  eLongForeignCardCountrySelectView.h
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/25.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongCustomPopView.h"
#import "eLongCountrySelectView.h"

@interface eLongForeignCardCountrySelectView : eLongCustomPopView

@property (nonatomic, strong) eLongCountrySelectView *selectView;

- (id)initWithCountryList:(NSArray *)countryList;

@end
