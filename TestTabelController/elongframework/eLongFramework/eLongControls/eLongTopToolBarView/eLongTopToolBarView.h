//
//  eLongTopToolBarView.h
//  eLongHotel
//
//  Created by top on 16/3/2.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongTopToolBarViewItemCellModel.h"

@protocol eLongTopToolBarViewDelegate;

@interface eLongTopToolBarView : UIView

@property (nonatomic, weak) id<eLongTopToolBarViewDelegate> delegate;

@property (nonatomic, strong) NSArray<eLongTopToolBarViewItemCellModel *> *itemsArray;

- (void)reloadView;

@end

@protocol eLongTopToolBarViewDelegate <NSObject>

- (void)eLongTopToolBarView:(eLongTopToolBarView *)view didOpenItemCellModel:(eLongTopToolBarViewItemCellModel *)model;

@end