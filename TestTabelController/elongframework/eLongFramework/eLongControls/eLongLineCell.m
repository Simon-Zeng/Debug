//
//  eLongLineCell.m
//  ElongClient
//
//  Created by nieyun on 14-2-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongLineCell.h"
#import "eLongExtension.h"
#import "eLongDefine.h"

@implementation eLongLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        topLineView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        topLineView.image = [UIImage imageNamed:@"myelong_dashed"];
        [self.contentView  addSubview:topLineView];
//
//        
        bottomLineView  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, self.frame.size.height, SCREEN_WIDTH, SCREEN_SCALE)];
        [self.contentView  addSubview:bottomLineView];
        bottomLineView.image = [UIImage imageNamed:@"myelong_dashed"];
    }
    return self;
}


- (void )awakeFromNib
{
   
    [super awakeFromNib];
  
    topLineView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    topLineView.image = [UIImage imageNamed:@"myelong_dashed"];
    [self.contentView  addSubview:topLineView];
    //
    //
    bottomLineView  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, self.frame.size.height, SCREEN_WIDTH, SCREEN_SCALE)];
    [self.contentView  addSubview:bottomLineView];
    bottomLineView.image = [UIImage imageNamed:@"myelong_dashed"];  

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    topLineView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
    bottomLineView.frame  =CGRectMake(0, self.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    
}

- (void)setNotop:(BOOL)notop
{
    _notop = notop;
    if (_notop  && topLineView) {
        [topLineView removeFromSuperview];
    }
}

- (void) setNobottom:(BOOL)nobottom
{
    _nobottom = nobottom;
    if (_nobottom && bottomLineView) {
        [bottomLineView  removeFromSuperview];
    }
}

- (void)dealloc
{
    topLineView = nil;
    bottomLineView = nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
