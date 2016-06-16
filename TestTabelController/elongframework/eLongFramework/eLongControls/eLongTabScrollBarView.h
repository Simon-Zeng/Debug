//
//  eLongTabScrollBarView.h
//  MyElong
//
//  Created by yangfan on 15/12/29.
//  Copyright © 2015年 lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol eLongTabScrollBarViewDelegate <NSObject>

@optional
- (void)TabBarClick:(id)sender;
- (void)TabScrollBar:(id)tabScrollBar ClickIndex:(NSInteger)index;
- (void)TabScrollBarClickOver:(id)sender;

@end

@interface eLongTabScrollBarView : UIView
<eLongTabScrollBarViewDelegate, UIScrollViewDelegate>{
@private
    NSInteger lastSelectedIndex;
    BOOL adjustTitleHeight;
    NSMutableArray  *segAr;
}

@property (nonatomic, strong) UIScrollView * scroll;

@property (nonatomic, assign) NSInteger selectedIndex;		// 被选中的segment序号
@property (nonatomic, assign) id<eLongTabScrollBarViewDelegate> delegate;
@property (nonatomic,assign) NSMutableArray  *titleAr;

- (id)initWithTitles:(NSArray *)titles;

- (void)didSelect:(NSInteger)index;

// add by yangfan 2015.12.30
-(void) addItem:(NSString *)title;

@end
