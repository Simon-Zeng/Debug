//
//  eLongFileWriteModel.m
//  eLongFramework
//
//  Created by lvyue on 15/5/6.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongFileWriteModel.h"
#import <UIKit/UIKit.h>
#import "eLongFileIOUtils.h"
#import "FCFileManager.h"


#define STRINGHASVALUE(str)		(str && [str isKindOfClass:[NSString class]] && [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)


@implementation eLongFileWriteModel

#pragma  mark - Init 唯一方法
+ (instancetype)createWithBuilder:(invoikeBlock)block {
    NSParameterAssert(block);
    eLongFileWriteModelBuilder *builder = [[eLongFileWriteModelBuilder alloc] init];
    block(builder);
    return [builder build];
}

- (NSString *)dirPathWithEumArray:(NSArray *)eumArray{
    if (!STRINGHASVALUE(_fileName)) {
        return nil;
    }
    NSString *dirName = [eumArray safeObjectAtIndex:_bussinessLine];
    if (STRINGHASVALUE(dirName)) {
        NSString *filePath = nil;
        id content = _data;
        if (!content) {
            return nil;
        }
        if([content isKindOfClass:[NSMutableArray class]]){
            NSMutableArray *array = (NSMutableArray *)content;
            if ([array count] > 0) {
                filePath = [NSString stringWithFormat:@"%@/%@",[FCFileManager pathForDocumentsDirectory],dirName];
            }
        }
        else if([content isKindOfClass:[NSArray class]]){
            NSArray *array = (NSArray *)content;
            if ([array count] > 0) {
                filePath = [NSString stringWithFormat:@"%@/%@",[FCFileManager pathForDocumentsDirectory],dirName];
            }
        }
        else if([content isKindOfClass:[NSMutableDictionary class]]){
            NSMutableDictionary *dic = (NSMutableDictionary *)content;
            if ([dic count] > 0) {
                filePath = [NSString stringWithFormat:@"%@/%@",[FCFileManager pathForDocumentsDirectory],dirName];
            }
        }
        else if([content isKindOfClass:[NSDictionary class]]){
            NSDictionary *dic = (NSDictionary *)content;
            if ([dic count] > 0) {
                filePath = [NSString stringWithFormat:@"%@/%@",[FCFileManager pathForDocumentsDirectory],dirName];
            }
        }
        else if([content isKindOfClass:[UIImage class]]){
            filePath = [NSString stringWithFormat:@"%@/%@",[FCFileManager pathForCachesDirectory],dirName];
        }
        if (STRINGHASVALUE(filePath)) {
            return filePath;
        }
    }
    return nil;
}

@end


#pragma  mark - eLongFileWriteModelBuilder
@implementation eLongFileWriteModelBuilder

#pragma  mark - build
- (eLongFileWriteModel *)build
{
    // 可以在这里对 property 做检查
    NSAssert(STRINGHASVALUE(_fileName), @"文件名别忘了填哦");
    NSAssert([self checkBussnessLine], @"业务线出错哦");
    NSAssert([self checkDataVaild], @"数据出错或为空哦");
    eLongFileWriteModel *model = [[eLongFileWriteModel alloc] init];
    model.fileName = _fileName;
    model.data = _data;
    model.bussinessLine = _bussinessLine;
    return model;
}

#pragma  mark - 校验
- (BOOL)checkBussnessLine{
    if (_bussinessLine < 0 || _bussinessLine > eLongFileIOEnum_Groupon) {
        return NO;
    }
    return YES;
}

- (BOOL)checkDataVaild{
    if (!_data) {
        return NO;
    }
    id content = _data;
    if (!content) {
        return NO;
    }
    if([content isKindOfClass:[NSMutableArray class]])
    {
        return [(NSMutableArray *)content count] > 0;
    }
    else if([content isKindOfClass:[NSArray class]])
    {
        return [(NSArray *)content count] > 0;
    }
    else if([content isKindOfClass:[NSMutableDictionary class]])
    {
        return [(NSMutableDictionary *)content count] > 0;
    }
    else if([content isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)content count] > 0;
    }
    else if([content isKindOfClass:[UIImage class]])
    {
        return YES;
    }
    /**
     *  可拓展
     */
    //    else if([content isKindOfClass:[NSMutableData class]])
    //    {
    //    }
    //    else if([content isKindOfClass:[NSData class]])
    //    {
    //    }
    
    //    else if([content isKindOfClass:[NSJSONSerialization class]])
    //    {
    //    }
    //    else if([content isKindOfClass:[NSMutableString class]])
    //    {
    //    }
    //    else if([content isKindOfClass:[NSString class]])
    //    {
    //    }
    
    //    else if([content isKindOfClass:[UIImageView class]])
    //    {
    //    }
    //    else if([content conformsToProtocol:@protocol(NSCoding)])
    //    {
    ////        [NSKeyedArchiver archiveRootObject:content toFile:absolutePath];
    //    }
    else {
        [NSException raise:@"Invalid content type" format:@"content of type %@ is not handled.", NSStringFromClass([content class])];
        
        return NO;
    }
    return NO;
}

@end

