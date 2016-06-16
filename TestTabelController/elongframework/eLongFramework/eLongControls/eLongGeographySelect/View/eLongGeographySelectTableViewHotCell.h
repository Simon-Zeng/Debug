//
//  eLongGeographySelectTableViewHotCell.h
//  Pods
//
//  Created by chenggong on 15/9/23.
//
//

#import <UIKit/UIKit.h>
#import "eLongGeographySelectDetailModel.h"

typedef void (^GeographySelectHotClickBlock)(eLongGeographySelectDetailModel *geographySelectDetailModel);

@interface eLongGeographySelectTableViewHotCell : UITableViewCell

@property (nonatomic, strong) NSArray *geographies;
@property (nonatomic, copy) GeographySelectHotClickBlock geographySelectHotClickBlock;
@property (nonatomic, copy) NSString *countlyPage;
@property (nonatomic, copy) NSString *countlySpot;

@end
