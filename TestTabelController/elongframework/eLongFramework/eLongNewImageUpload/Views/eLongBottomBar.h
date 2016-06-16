//
//  eLongBottomToolBar.h
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/27.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, eLongBottomBarType) {
    eLongCollectionBottomBar,
    eLongPreviewBottomBar,
    eLongPreviewBottomSend,
};

@interface eLongBottomBar: UIView

@property (nonatomic, assign, readonly) eLongBottomBarType barType;
@property (nonatomic, assign, readonly) CGFloat totalSize;
@property (nonatomic, assign, readonly) BOOL selectOriginEnable;
@property (nonatomic, copy)   void(^confirmBlock)();
@property (nonatomic, copy)   void(^sendBlock)();
@property (nonatomic, copy)   void(^cancelBlock)();




- (instancetype)initWithBarType:(eLongBottomBarType)barType;

- (void)updateBottomBarWithAssets:(NSArray *)assets;

@end
