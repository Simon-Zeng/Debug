//
//  eLongGeographySelectTableViewDelegate.h
//  Pods
//
//  Created by chenggong on 15/9/22.
//
//

#import <Foundation/Foundation.h>
#import "eLongGeographySelectModel.h"
#import "eLongGeographySelectDataSourceModel.h"
#import "eLongGeographyTableViewDelegate.h"

@interface eLongGeographySelectTableViewDelegate : NSObject<UITableViewDelegate>

@property (nonatomic, copy) UITableViewDidSelectRowAtIndexPathBlock didSelectRowAtIndexPath;
@property (nonatomic, copy) UITableViewHeightForFooterInSectionBlock heightForFooterInSection;
@property (nonatomic, copy) UITableViewHeightForHeaderInSectionBlock heightForHeaderInSection;
@property (nonatomic, copy) UITableViewHeightForRowAtIndexPathBlock heightForRowAtIndexPath;
@property (nonatomic, copy) UITableViewViewForFooterInSectionBlock viewForFooterInSection;
@property (nonatomic, copy) UITableViewViewForHeaderInSectionBlock viewForHeaderInSection;

- (instancetype)initWithSelectModel:(eLongGeographySelectModel *)selectModel withDataSourceModel:(eLongGeographySelectDataSourceModel *)dataSourceModel;

@end
