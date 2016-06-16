//
//  eLongPopupTableViewCell.m
//  PopupController
//
//  Created by zhucuirong on 15/9/16.
//  Copyright (c) 2015年 SINOFAKE SINEP. All rights reserved.
//

#import "eLongPopupTableViewCell.h"
#import "eLongPopupDefine.h"

@interface eLongPopupTableViewCell ()
@property (nonatomic, strong) UIView *splitView;
@property (nonatomic, strong) UIImageView *checkImgView;

@end

@implementation eLongPopupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.backgroundColor	= [UIColor clearColor];
    nameLabel.font				= [UIFont systemFontOfSize:15.f];
    nameLabel.textColor = [UIColor colorWithRed:68/255.f green:68/255.f blue:68/255.f alpha:1];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIImageView *checkImgView = [[UIImageView alloc] initWithImage:SS_BundleImageWithName(@"cell_choose_icon")];
    checkImgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:checkImgView];
    self.checkImgView = checkImgView;
    
    self.splitView = [UIView new];
    self.splitView.backgroundColor = [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1];
    [self.contentView addSubview:self.splitView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat gap = 12.f;
    UIImage *testImg = SS_BundleImageWithName(@"cell_choose_icon");
    self.checkImgView.frame = CGRectMake(gap, (CGRectGetHeight(self.contentView.frame) - testImg.size.height)/2.f, testImg.size.width, testImg.size.height);
    CGFloat originX = CGRectGetMaxX(self.checkImgView.frame) + gap;
    self.nameLabel.frame = CGRectMake(originX, 0, CGRectGetWidth(self.frame) - originX, CGRectGetHeight(self.contentView.frame) - SS_SCREEN_SCALE);
    self.splitView.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), CGRectGetWidth(self.frame), SS_SCREEN_SCALE);
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    _checked = checked;
    if (checked) {
        self.checkImgView.image = SS_BundleImageWithName(@"cell_choose_icon_h");
    }
    else {
        self.checkImgView.image = SS_BundleImageWithName(@"cell_choose_icon");
    }
}


@end
