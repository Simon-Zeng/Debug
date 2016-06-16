//
//  eLongGeographySelectDetailModel.h
//  Pods
//
//  Created by chenggong on 15/9/24.
//
//

#import <Foundation/Foundation.h>
#import "eLongResponseBaseModel.h"

@protocol eLongGeographySelectDetailModel
@end

@interface eLongGeographySelectDetailModel : eLongResponseBaseModel

/**
 *  城市名称
 */
@property (nonatomic,strong) NSString *cityName;
/**
 *  城市编号
 */
@property (nonatomic,strong) NSString *cityNum;
/**
 *  城市名称-字母
 */
@property (nonatomic,strong) NSString *cityCode;
/**
 *  城市名称拼音
 */
@property (nonatomic,strong) NSString *cityPy;
/**
 *  组合名字
 */
@property (nonatomic,strong) NSString *composedName;
/**
 *  国家区域
 */
@property (nonatomic,strong) NSString *country;
/**
 *  关键字框建议的输入
 */
@property (nonatomic,strong) NSString *advisedkeyword;
/**
 *  是否是国内城市
 */
@property (nonatomic,assign) BOOL chinaCity;
/**
 *  国内城市 - id
 */
@property (nonatomic,copy)   NSString *chinaCityId;
/**
 *  国内城市 - name
 */
@property (nonatomic,copy)   NSString *chinaCityName;
@end
