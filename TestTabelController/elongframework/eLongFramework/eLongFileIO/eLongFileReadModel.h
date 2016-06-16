//
//  eLongFileReadModel.h
//  eLongFramework
//
//  Created by lvyue on 15/5/6.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongFileIOEnum.h"

@class eLongFileReadModelBuilder;
typedef void (^builderBlock)(eLongFileReadModelBuilder *builder);

@interface eLongFileReadModel : NSObject

@property (nonatomic,copy) NSString *fileName;  // 文件名
@property (nonatomic,assign) eLongFileIOEnum bussinessLine;     // 业务线名
@property (nonatomic, assign) BOOL inMainBundle;    //是否是app内资源路径


/**
 *  初始化eLongFileReadModel
 *
 *  @param block eLongFileReadModelBuilder
 *
 *  @return eLongFileReadModel
 */
+ (instancetype)createWithBuilder:(builderBlock)block;

/**
 *  得到读文件目录
 *
 *  @return 读文件目录
 */
- (NSString *) readFilePath;


-(NSString *) rootDirWithfileName:(NSString *)filename;

@end


@interface eLongFileReadModelBuilder : NSObject
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) eLongFileIOEnum bussinessLine;
@property (nonatomic, assign) BOOL inMainBundle;    //是否是app内资源路径


- (eLongFileReadModel *)build;
@end