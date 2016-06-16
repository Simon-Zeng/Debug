//
//  eLongFileReadModel.m
//  eLongFramework
//
//  Created by lvyue on 15/5/6.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongFileReadModel.h"
#import "FCFileManager.h"
#import "eLongExtension.h"


@interface eLongFileReadModel()

@end

@implementation eLongFileReadModel

+ (instancetype)createWithBuilder:(builderBlock)block {
    NSParameterAssert(block);
    eLongFileReadModelBuilder *builder = [[eLongFileReadModelBuilder alloc] init];
    block(builder);
    return [builder build];
}

- (NSString *) readFilePath{
    NSString * dir = [NSString string];
    NSMutableString * bussinessLinePath = [NSMutableString string];
    
    switch (_bussinessLine) {
        case eLongFileIOEnum_MyElong:
            [bussinessLinePath appendString:@"MyElong"];
            break;
        case eLongFileIOEnum_CustomerService:
            [bussinessLinePath appendString:@"CustomerService"];
            break;
        case eLongFileIOEnum_Train:
            [bussinessLinePath appendString:@"Train"];
            break;
        case eLongFileIOEnum_Flight:
            [bussinessLinePath appendString:@"Flight"];
            break;
        case eLongFileIOEnum_Hotel:
            [bussinessLinePath appendString:@"Hotel"];
            break;
        case eLongFileIOEnum_LoginAndRegister:
            [bussinessLinePath appendString:@"LoginAndRegister"];
            break;
        case eLongFileIOEnum_InterHotel:
            [bussinessLinePath appendString:@"InterHotel"];
            break;
        case eLongFileIOEnum_Home:
            [bussinessLinePath appendString:@"Home"];
            break;
        case eLongFileIOEnum_Apartment:
            [bussinessLinePath appendString:@"Apartment"];
            break;
        case eLongFileIOEnum_PlayLocal:
            [bussinessLinePath appendString:@"PlayLocal"];
            break;
        case eLongFileIOEnum_Taxi:
            [bussinessLinePath appendString:@"Taxi"];
            break;
        case eLongFileIOEnum_Groupon:
            [bussinessLinePath appendString:@"Groupon"];
            break;
        default:
            break;
    }
    [bussinessLinePath appendFormat:@"/%@",_fileName];
    
    // 根据相对路径得到绝对路径
    dir = [self rootDirWithfileName:bussinessLinePath];
    
    return dir;
}

-(NSString *) rootDirWithfileName:(NSString *)filename{
    NSMutableString * rootdir = [NSMutableString  string];
    
    // 扩展名为plist的，Document 目录下
    if ([FCFileManager isPath:filename hasExtension:@"plist"]
        || [FCFileManager isPath:filename hasExtension:@"txt"]) {
        [rootdir appendString:[FCFileManager pathForDocumentsDirectoryWithPath:filename]];
    }
    // 扩展名为png, jpg,jpeg，Cache目录下
    else if ([FCFileManager isPath:filename hasExtension:@"png"]
             || [FCFileManager isPath:filename hasExtension:@"jpg"]
             || [FCFileManager isPath:filename hasExtension:@"jpeg"]){
        [rootdir appendString:[FCFileManager pathForCachesDirectoryWithPath:filename]];

    }
    
    return rootdir;
}

@end


@implementation eLongFileReadModelBuilder

- (eLongFileReadModel *)build
{
    // 可以在这里对 property 做检查
    if ([_fileName empty]) {
        return nil;
    }
    if (![self checkBussnessLine]) {
        return nil;
    }
    
    eLongFileReadModel *model = [[eLongFileReadModel alloc] init];
    model.fileName = _fileName;
    model.bussinessLine = _bussinessLine;
    model.inMainBundle = _inMainBundle;

    return model;
}

- (BOOL)checkBussnessLine{
    if (_bussinessLine < eLongFileIOEnum_MyElong || _bussinessLine > eLongFileIOEnum_Groupon) {
        return NO;
    }
    return YES;
}

@end