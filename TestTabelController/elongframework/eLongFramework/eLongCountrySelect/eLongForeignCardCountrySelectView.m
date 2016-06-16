//
//  eLongForeignCardCountrySelectView.m
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/25.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongForeignCardCountrySelectView.h"
#import "eLongDefine.h"
#import "UIColor+eLongExtension.h"
#import "eLongCountrySelectView.h"
#import "UIImageView+Extension.h"

@interface eLongForeignCardCountrySelectView()

@end

@implementation eLongForeignCardCountrySelectView

- (id)initWithCountryList:(NSArray *)countryList
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 142)]) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor colorWithHexStr:@"0x444444"];
        titleLabel.font = FONT_B15;
        titleLabel.text = @"选择国家";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        self.selectView = [[eLongCountrySelectView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, SCREEN_WIDTH, self.frame.size.height - 44.0f) countryList:countryList];
        [self addSubview:self.selectView];
        
        [self addSubview:[UIImageView separatorWithFrame:CGRectMake(0.0f, 43.0f, SCREEN_WIDTH, 1.0f)]];
    }
    
    return self;
}

@end
