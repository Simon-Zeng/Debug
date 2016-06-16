//
//  eLongFileIOManager.h
//  eLongFramework
//
//  Created by lvyue on 15/5/6.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongFileReadModel.h"
#import "eLongFileWriteModel.h"

@interface eLongFileIOManager : NSObject

/**
 *  实例方法
 *
 *  @return 实例方法获得实例
 */
+ (instancetype) fileIOManager;

/**
 *  读取文件
 *
 *  @param readModel 读取文件需要的Model
 *
 *  @return 读取出来的数据文件
 */

- (id) readFileWithModel:(eLongFileReadModel *)readModel;
/**
 *  写入文件
 *
 *  @param writeModel 写入文件所需要的Model
 *
 *  @return 是否写入成功的操作返回
 */

- (BOOL) writeFileWithModel:(eLongFileWriteModel *)writeModel;
/**
 *  userdefaulf
 *
 *  @param key 写入userdefaults所需要的key
 *
 */
+ (void)saveObject:(NSObject  *)obj InUserdefaultsforKey:(NSString *)key;
/**
 *  取出Userdefaults
 *
 *  @param key 写入文件所需要的key
 *
 */
+ (NSObject *)getObjectFromUserdefaultsForKey:(NSString *)key;


+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSString *)pid lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city;

+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSString *)pid propertiesType:(NSNumber *)pidType lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city;

// 获取保存的数据
+ (NSMutableArray *)arrayDateSaved:(NSString *)saveFileName andSaveKey:(NSString *)keyName;
// 保存数据
+ (void)saveData:(NSMutableArray *)arrayDataSaved withFileName:(NSString *)saveFileName andSaveKey:(NSString *)keyName;
@end
