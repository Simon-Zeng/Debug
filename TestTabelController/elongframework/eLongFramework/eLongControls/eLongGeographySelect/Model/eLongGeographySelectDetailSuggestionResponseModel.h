//
//  eLongGeographySelectDetailSuggestionResponseModel.h
//  Pods
//
//  Created by chenggong on 15/10/9.
//
//

#import "eLongResponseBaseModel.h"
#import "eLongGeographySelectDetailModel.h"

@interface eLongGeographySelectDetailSuggestionResponseModel : eLongResponseBaseModel

@property (nonatomic,strong) NSArray<eLongGeographySelectDetailModel> *suggestCityList;

@end
