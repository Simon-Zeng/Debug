//
//  eLongFileWriteModel.h
//  eLongFramework
//
//  Created by lvyue on 15/5/6.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongFileIOEnum.h"

@class eLongFileWriteModel;
@interface eLongFileWriteModelBuilder : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) eLongFileIOEnum bussinessLine;
@property (nonatomic, strong) id data;

- (eLongFileWriteModel *)build;

@end

typedef void (^invoikeBlock)(eLongFileWriteModelBuilder *builder);
@interface eLongFileWriteModel : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) eLongFileIOEnum bussinessLine;
@property (nonatomic, strong) id data;
/**
 *  初始化eLongFileWriteModel
 *
 *  @param block eLongFileWriteModelBuilder
 *
 *  @return eLongFileWriteModel
 */
+ (instancetype)createWithBuilder:(invoikeBlock)block;

- (NSString *)dirPathWithEumArray:(NSArray *)eumArray;

@end



