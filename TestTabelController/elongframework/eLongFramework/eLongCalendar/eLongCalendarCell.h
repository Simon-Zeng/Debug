//
//  eLongCalendarCell.h
//  TestCalendar
//
//  Created by top on 15/9/18.
//  Copyright (c) 2015年 top. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eLongCalendarDateModel;

@interface eLongCalendarCell : UICollectionViewCell

@property (nonatomic, strong, readonly) eLongCalendarDateModel *dateModel;

- (void)refreshContentViewWithDateModel:(eLongCalendarDateModel *)dateModel;

@end
