//
//  eLongGeographySelectTableViewCell.h
//  Pods
//
//  Created by chenggong on 15/9/23.
//
//

#import <UIKit/UIKit.h>

@interface eLongGeographySelectTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel* cityLabel;
@property (nonatomic ,strong) UILabel* cityTypeLabel;
@property (nonatomic ,strong) UIImageView* gpsView;
@property (nonatomic, assign) BOOL showCityType;
@property (nonatomic, strong) UIImageView *splitView;

- (void)setShowCityType:(BOOL)showCityType;

@end
