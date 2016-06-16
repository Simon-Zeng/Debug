//
//  eLongTopToolBarViewItemCellModel.h
//  eLongHotel
//
//  Created by top on 16/3/2.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSInteger, eLongTopToolBarViewItemType) {
    eLongTopToolBarViewItemTypeBrand,
    eLongTopToolBarViewItemTypeArea,
    eLongTopToolBarViewItemTypeStarAndPrice,
    eLongTopToolBarViewItemTypeSort,
};

@interface eLongTopToolBarViewItemCellModel : JSONModel

@property (nonatomic, assign) eLongTopToolBarViewItemType itemType;

@property (nonatomic, copy) NSString *defaultTitle;

@property (nonatomic, copy) NSString *selectedTitle;

@property (nonatomic, assign) BOOL hasSelected;

@property (nonatomic, assign) BOOL hasOpened;

@end
