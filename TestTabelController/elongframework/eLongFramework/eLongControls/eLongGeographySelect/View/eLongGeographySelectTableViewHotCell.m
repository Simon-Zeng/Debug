//
//  eLongGeographySelectTableViewHotCell.m
//  Pods
//
//  Created by chenggong on 15/9/23.
//
//

#import "eLongGeographySelectTableViewHotCell.h"
#import "eLongDefine.h"
#import "eLongGeographyCountlyEventDefine.h"
#import "eLongFileIOUtils.h"

@implementation eLongGeographySelectTableViewHotCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    
    return self;
}

-(void)setGeographies:(NSArray *)geographies {
    _geographies = geographies;
    
    CGFloat x = 10;
    CGFloat y = 10;
    
    NSInteger columns = 4;
    NSInteger seperate = 10;
    CGFloat marginRight = 20;
    CGFloat buttonHeight = 40;
    
    CGFloat buttonWidth = (SCREEN_WIDTH - seperate*(columns + 1) - marginRight) / columns;
    
    NSInteger i = 0;
    
    for (NSArray *geography in _geographies) {
        CGFloat buttonX = x + (buttonWidth+seperate)*(i%columns);
        CGFloat buttonY = y + (buttonHeight+seperate)*(i/columns);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        button.layer.borderWidth = 1.0;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.9, 0.9, 0.9, 1 });
        button.layer.borderColor = colorref;
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        
        [button setTitle:[geography safeObjectAtIndex:0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = FONT_14;
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        button.backgroundColor = [UIColor whiteColor];
        button.tag = i;
        
        [button addTarget:self action:@selector(clickHotGeography:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
        
        [self.contentView addSubview:button];
        
        i++;
    }
}

-(void)clickHotGeography:(UIButton *)target{
    if (STRINGHASVALUE(_countlyPage) && STRINGHASVALUE(_countlySpot)) {
        eLongCountlyEventClick *countlyEventClick = [[eLongCountlyEventClick alloc] init];
        countlyEventClick.page = _countlyPage;
        countlyEventClick.clickSpot = _countlySpot;
        [countlyEventClick sendEventCount:1];
    }
    
    if (_geographySelectHotClickBlock) {
        NSArray *geography = [self.geographies safeObjectAtIndex:target.tag];
        eLongGeographySelectDetailModel *geographySelectDetailModel = [[eLongGeographySelectDetailModel alloc] init];
        geographySelectDetailModel.cityName = [geography safeObjectAtIndex:0];
        geographySelectDetailModel.cityPy = [geography safeObjectAtIndex:1];
        geographySelectDetailModel.cityNum = [geography safeObjectAtIndex:2];
        geographySelectDetailModel.advisedkeyword = [geography safeObjectAtIndex:3];
        geographySelectDetailModel.chinaCity = [[geography safeObjectAtIndex:4] boolValue];
        geographySelectDetailModel.chinaCityId = [NSString stringWithFormat:@"%zd",[[geography safeObjectAtIndex:5] integerValue]];
        geographySelectDetailModel.chinaCityName = [geography safeObjectAtIndex:6];
        self.geographySelectHotClickBlock(geographySelectDetailModel);
    }
}

@end
