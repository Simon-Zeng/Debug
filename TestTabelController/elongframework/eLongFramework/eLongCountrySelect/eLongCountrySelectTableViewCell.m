//
//  eLongCountrySelectTableViewCell.m
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/24.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongCountrySelectTableViewCell.h"
#import "eLongDefine.h"

@implementation eLongCountrySelectTableViewCell

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
        // Initialization code.
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 260 * FITSCALE, 44)];
        _countryLabel.backgroundColor = [UIColor clearColor];
        _countryLabel.textColor = [UIColor colorWithHexStr:@"0x858585"];
        _countryLabel.font = FONT_12;
        [self.contentView addSubview:_countryLabel];
        
//        self.splitView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 40 - SCREEN_SCALE, SCREEN_WIDTH - 17, SCREEN_SCALE)];
//        _splitView.image= [UIImage imageNamed:@"dashed.png"];// inBundle:[NSBundle currentBundle] compatibleWithTraitCollection:nil];
//        [self.contentView addSubview:_splitView];
    }
    return self;
}

@end
