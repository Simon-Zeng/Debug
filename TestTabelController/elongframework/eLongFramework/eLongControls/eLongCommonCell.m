//
//  CommonCell.m
//  ElongClient
//
//  Created by haibo on 11-12-31.
//  Copyright 2011 elong. All rights reserved.
//

#import "eLongCommonCell.h"
#import "eLongDefine.h"

@implementation eLongCommonCell

@synthesize cellImage;
@synthesize textLabel;

- (void)dealloc
{
    self.cellImage  = nil;
    self.textLabel  = nil;
}

- (id)initWithIdentifier:(NSString *)identifierString height:(CGFloat)cellHeight style:(CommonCellStyle)cellStyle
{
    curStyle=cellStyle;
    
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierString]) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.selectedBackgroundView = backView;
        //        backView.backgroundColor = RGBACOLOR(237, 237,237, 1);
        backView.backgroundColor=[UIColor clearColor];
        
        self.backgroundColor=[UIColor clearColor];
        
        // arrow
        UIImageView *img = [[UIImageView alloc] init];
        img.contentMode = UIViewContentModeCenter;
        if (CommonCellStyleDownArrow == cellStyle) {
            img.frame = CGRectMake(SCREEN_WIDTH - 16,0 , 12, cellHeight);
            img.image = [UIImage imageNamed:@"eLongExtension_ico_downarrow"];
        }
        else if (CommonCellStyleRightArrow == cellStyle) {
            img.frame = CGRectMake(SCREEN_WIDTH - 16, 0, 8, cellHeight);
            img.image = [UIImage imageNamed:@"eLongExtension_ico_rightarrow"];
        }
        else if (CommonCellStyleChoose == cellStyle) {
            img.frame = CGRectMake(SCREEN_WIDTH - 26, 0, 8, cellHeight);
            img.contentMode = UIViewContentModeCenter;
            img.image = [UIImage imageNamed:@"eLongFilterView_filter_select_bg"];
            img.highlightedImage = [UIImage imageNamed:@"eLongFilterView_filter_selected_bg"];
        }
        else if (CommonCellStyleCheckBox == cellStyle) {
            img.frame = CGRectMake(25, 0, 19, cellHeight);
            img.image = [UIImage imageNamed:@"eLongFilterView_btn_choice"];
        }else{
            img.frame = CGRectZero;
            img.image = nil;
        }
        
        [self setImgOther:img];
        
        [self.contentView addSubview:img];
        self.cellImage = img;
        
        // conditions
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((CommonCellStyleCheckBox == cellStyle)? 60 : 20, 10, BOTTOM_BUTTON_WIDTH, cellHeight - 20)];
        label.numberOfLines = 0;
        label.backgroundColor	= [UIColor clearColor];
        label.font				= FONT_15;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor	= 14;
        label.textColor = RGBACOLOR(52, 52, 52, 1);
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self setlabelOther:label];
        
        [self.contentView addSubview:label];
        self.textLabel = label;
        
        // dashed
        UIImageView *dashview = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        dashview.tag = 101;
        dashview.image = [UIImage imageNamed:@"basevc_dashed"];
        [self.contentView addSubview:dashview];
    }
    
    return self;
}

- (id)initWithIdentifier:(NSString *)identifierString leftMargin:(CGFloat)xValue  height:(CGFloat)cellHeight style:(CommonCellStyle)cellStyle
{
    curStyle=cellStyle;
    
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierString]) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.selectedBackgroundView = backView;
        //        backView.backgroundColor = RGBACOLOR(237, 237,237, 1);
        backView.backgroundColor=[UIColor clearColor];
        
        self.backgroundColor=[UIColor clearColor];
        
        // arrow
        UIImageView *img = [[UIImageView alloc] init];
        img.contentMode = UIViewContentModeCenter;
        if (CommonCellStyleDownArrow == cellStyle) {
            img.frame = CGRectMake(SCREEN_WIDTH - 16,0 , 12, cellHeight);
            img.image = [UIImage imageNamed:@"eLongExtension_ico_downarrow"];
        }
        else if (CommonCellStyleRightArrow == cellStyle) {
            img.frame = CGRectMake(SCREEN_WIDTH - 16, 0, 8, cellHeight);
            img.image = [UIImage imageNamed:@"eLongExtension_ico_rightarrow"];
        }
        else if (CommonCellStyleChoose == cellStyle) {
            img.frame = CGRectMake(xValue, 0, 19, cellHeight);
            img.contentMode = UIViewContentModeCenter;
            img.image = [UIImage imageNamed:@"eLongFilterView_btn_checkbox"];
            img.highlightedImage = [UIImage imageNamed:@"eLongFilterView_btn_checkbox_checked"];
        }
        else if (CommonCellStyleCheckBox == cellStyle) {
            img.frame = CGRectMake(xValue, 0, 19, cellHeight);
            img.image = [UIImage imageNamed:@"eLongFilterView_btn_choice"];
        }else{
            img.frame = CGRectZero;
            img.image = nil;
        }
        
        [self setImgOther:img];
        
        [self.contentView addSubview:img];
        self.cellImage = img;
        
        // conditions
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((CommonCellStyleChoose == cellStyle || CommonCellStyleCheckBox == cellStyle)? (xValue+CGRectGetWidth(img.frame)+20.0f) : 20, 10, BOTTOM_BUTTON_WIDTH, cellHeight - 20)];
        label.numberOfLines = 0;
        label.backgroundColor	= [UIColor clearColor];
        label.font				= [UIFont boldSystemFontOfSize:15];
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor	= 14;
        //        label.textColor = RGBACOLOR(52, 52, 52, 1);
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self setlabelOther:label];
        
        [self.contentView addSubview:label];
        self.textLabel = label;
        
        // dashed
        UIImageView *dashview = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        dashview.tag = 101;
        dashview.image = [UIImage imageNamed:@"basevc_dashed.png"];
        [self.contentView addSubview:dashview];
    }
    
    return self;
}


//设置图标的其他，子类可以实现
-(void) setImgOther:(UIImageView *)img
{
    
}

//设置label的其他，子类可以实现
-(void) setlabelOther:(UILabel *)label
{
    
}

- (void) setChecked:(BOOL)checked{
    _checked = checked;
    if (checked) {
        self.cellImage.image = [UIImage imageNamed:@"eLongFilterView_btn_choice_checked"];
    }else{
        self.cellImage.image = [UIImage imageNamed:@"eLongFilterView_btn_choice"];
    }
}

@end

@implementation RoundCornerSelectCell

@synthesize textLabel;
@synthesize cellImage;

- (void)dealloc
{
    self.topSplitView = nil;
    self.bottomSplitView = nil;
    self.textLabel  = nil;
    self.cellImage  = nil;
}

- (id)initWithIdentifier:(NSString *)identifierString height:(CGFloat)cellHeight
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierString]) {
        // 背景色
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.selectedBackgroundView = backView;
        backView.backgroundColor = RGBACOLOR(237, 237,237, 1);
        
        UIImageView *img = [[UIImageView alloc] init];
        img.frame = CGRectMake(18, (cellHeight-25) / 2, 28, 24);
        img.image = [UIImage imageNamed:@"eLongFilterView_btn_checkbox"];
        img.highlightedImage = [UIImage imageNamed:@"eLongFilterView_btn_checkbox_checked"];
        [self.contentView addSubview:img];
        img.contentMode = UIViewContentModeCenter;
        self.cellImage = img;
        
        // conditions
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, (cellHeight-21) / 2, BOTTOM_BUTTON_WIDTH, 20)];
        label.backgroundColor	= [UIColor clearColor];
        label.font				= FONT_15;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor	= 14;
        label.textColor = RGBACOLOR(102, 102, 102, 1);
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:label];
        self.textLabel = label;
        
        // dashed
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        self.topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        self.topSplitView.image = [UIImage imageNamed:@"basevc_dashed.png"];
        [self.contentView addSubview:self.topSplitView];
        
        self.bottomSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        self.bottomSplitView.image = [UIImage imageNamed:@"basevc_dashed.png"];
        [self.contentView addSubview:self.bottomSplitView];
    }
    
    return self;
}

- (void)setCellPosition:(RoundCornerSelectCellPosition)position
{
    if (position == RoundCornerSelectCellPositionTop) {
        self.topSplitView.hidden = NO;
        self.bottomSplitView.hidden = NO;
    }
    else if(position == RoundCornerSelectCellPositionCenter){
        self.topSplitView.hidden = YES;
        self.bottomSplitView.hidden = NO;
    }
    else {
        self.topSplitView.hidden = NO;
        self.bottomSplitView.hidden = NO;
    }
}

@end
