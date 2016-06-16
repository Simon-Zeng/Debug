//
//  eLongGeographySelectTableViewCell.m
//  Pods
//
//  Created by chenggong on 15/9/23.
//
//

#import "eLongGeographySelectTableViewCell.h"
#import "eLongDefine.h"

@implementation eLongGeographySelectTableViewCell

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
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
        self.gpsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        _gpsView.image = [UIImage imageNamed:@"elong_gps_h.png"];// inBundle:[NSBundle currentBundle] compatibleWithTraitCollection:nil];
        _gpsView.hidden = YES;
        _gpsView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_gpsView];
        
        self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 260 * FITSCALE, 44)];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.textColor = RGBACOLOR(85, 85, 85, 1);
        _cityLabel.font = FONT_B14;
        _cityLabel.adjustsFontSizeToFitWidth = YES;
        _cityLabel.minimumScaleFactor = .8f;
        [self.contentView addSubview:_cityLabel];
        
        self.cityTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(247 * FITSCALE, 0, 60 * FITSCALE, 44)];
        _cityTypeLabel.backgroundColor = [UIColor clearColor];
        _cityTypeLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _cityTypeLabel.font = FONT_12;
        _cityTypeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_cityTypeLabel];
        
        self.splitView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 40 - SCREEN_SCALE, SCREEN_WIDTH - 17, SCREEN_SCALE)];
        _splitView.image= [UIImage imageNamed:@"dashed.png"];// inBundle:[NSBundle currentBundle] compatibleWithTraitCollection:nil];
        [self.contentView addSubview:_splitView];
    }
    return self;
}

@end
