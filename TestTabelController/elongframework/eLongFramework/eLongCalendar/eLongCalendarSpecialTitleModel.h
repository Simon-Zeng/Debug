//
//  eLongCalendarSpecialTitleModel.h
//  Pods
//
//  Created by top on 15/10/13.
//
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

@interface eLongCalendarSpecialTitleModel : JSONModel

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIColor *titleColor;

@end
