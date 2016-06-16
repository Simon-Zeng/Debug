//
//  eLongGeographySelectDataSourceModel.h
//  Pods
//
//  Created by chenggong on 15/9/16.
//
//

#import <Foundation/Foundation.h>
#import "eLongGeographySelectModel.h"
#import "eLongGeographyTableViewDelegate.h"
#import "eLongGeographySelectDetailModel.h"

@interface eLongGeographySelectDataSourceModel : NSObject

@property (nonatomic, strong) NSMutableArray *geographySelectSections;
@property (nonatomic, strong) NSMutableArray *geographySelectSectionIndexTitles;
@property (nonatomic, strong) NSString *currentPosition;
@property (nonatomic, strong) NSString *currentPositionWithFullAddress;

- (instancetype)initWithGeographySelectModel:(eLongGeographySelectModel *)model;
- (void)saveSearchHistory:(eLongGeographySelectDetailModel *)geographySelectDetailModel;

@end
