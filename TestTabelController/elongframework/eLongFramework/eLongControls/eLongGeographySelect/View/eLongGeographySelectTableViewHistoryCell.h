//
//  eLongGeographySelectTableViewHistoryCell.h
//  Pods
//
//  Created by chenggong on 15/9/25.
//
//

#import <UIKit/UIKit.h>
#import "eLongGeographySelectDetailModel.h"

typedef void (^GeographySelectHistoryClickBlock)(eLongGeographySelectDetailModel *geographySelectDetailModel);

@interface eLongGeographySelectTableViewHistoryCell : UITableViewCell

@property (nonatomic, strong) NSArray *geographies;
@property (nonatomic, copy) GeographySelectHistoryClickBlock geographySelectHistoryClickBlock;
@property (nonatomic, copy) NSString *countlyPage;
@property (nonatomic, copy) NSString *countlySpot;

@end
