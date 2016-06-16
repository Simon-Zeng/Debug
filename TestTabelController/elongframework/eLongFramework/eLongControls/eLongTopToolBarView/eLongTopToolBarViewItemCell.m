//
//  eLongTopToolBarViewItemCell.m
//  eLongHotel
//
//  Created by top on 16/3/2.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongTopToolBarViewItemCell.h"
#import "eLongTopToolBarViewDefine.h"
#import "eLongTopToolBarViewItemCellModel.h"
#import "UIView+LayoutMethods.h"
#import "UIImageView+Extension.h"
#import "eLongDefine.h"
#import "NSString+TextSize.h"

@interface eLongTopToolBarViewItemCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *selectedIV;

@end

@implementation eLongTopToolBarViewItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureContentView];
    }
    return self;
}

- (void)configureContentView {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:12.0];
    _titleLabel.textColor = kBarItemCellTitleDefaultTextColor;
    _titleLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.lineBreakMode =NSLineBreakByCharWrapping;
    [self addSubview:_titleLabel];
    
    _selectedIV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _selectedIV.backgroundColor = [UIColor clearColor];
    _selectedIV.image = [UIImage imageNamed:@"elong_top_bar_view_item_default_down_bg"];
    [self addSubview:_selectedIV];
    
    int lineHeight = ceil(self.height*0.33);
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(ceil(self.width-SCREEN_SCALE),
                                                                    ceil((self.height-lineHeight)/2),
                                                                    SCREEN_SCALE,
                                                                    lineHeight)]];
}

- (void)refreshContentViewWithCellModel:(eLongTopToolBarViewItemCellModel *)model {
    int contentWidth = ceil(self.width*0.8);
    int selectedIV_length = 7;
    int interval = ceil(self.width*0.0625);
    int titleLabelWidth = contentWidth - selectedIV_length - interval;
    NSString *title = model.hasSelected ? model.selectedTitle : model.defaultTitle;
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT,
                                                         CGRectGetHeight(_titleLabel.frame))
                                         font:[UIFont systemFontOfSize:12.0] ];
    if (size.width < titleLabelWidth) {
        int titleLabel_X = (self.width-size.width-selectedIV_length-interval)/2;
        self.titleLabel.frame = CGRectMake(titleLabel_X, 0, size.width, self.frame.size.height);
    } else {
        self.titleLabel.frame = CGRectMake((self.width-contentWidth)/2,
                                           0,
                                           titleLabelWidth,
                                           self.height);
    }
    self.selectedIV.frame = CGRectMake(self.titleLabel.right+interval,
                                       (self.height-selectedIV_length)/2,
                                       selectedIV_length,
                                       selectedIV_length);
    self.titleLabel.text = title;
    if (model.hasOpened) {
        self.titleLabel.textColor = kBarItemCellTitleSelectedTextColor;
        self.selectedIV.image = [UIImage imageNamed:@"elong_top_bar_view_item_select_up_bg"];
    } else {
        self.titleLabel.textColor = model.hasSelected ?
                                    kBarItemCellTitleSelectedTextColor :
                                    kBarItemCellTitleDefaultTextColor;
        self.selectedIV.image = model.hasSelected ? [UIImage imageNamed:@"elong_top_bar_view_item_select_down_bg"] : [UIImage imageNamed:@"elong_top_bar_view_item_default_down_bg"];
    }
}

@end
