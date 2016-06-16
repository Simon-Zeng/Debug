//
//  eLongFileIOManager.m
//  eLongFramework
//
//  Created by lvyue on 15/5/6.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongFileIOManager.h"
#import "FCFileManager.h"
#import "eLongExtension.h"
#import "eLongFileIOUtils.h"
#import "eLongUserDefault.h"
#import "eLongDefine.h"


//待放到公共define中，暂时不能暴露给主程序
#define USERDEFUALT_HOTEL_SEARCHKEYWORD             @"HOTEL_SEARCHKEYWORD"          // 记录酒店搜索历史
// 酒店关键词搜索历史记录数量
#define HOTEL_KEYWORDHISTORY_NUM    3

@implementation eLongFileIOManager

static NSArray *dirNameArray;
#pragma mark -ShareInstance
+ (instancetype) fileIOManager{
    static eLongFileIOManager *fileManager;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        fileManager = [[eLongFileIOManager alloc] init];
        [self eumDirNameArray];
    });
    return fileManager;
}

#pragma mark -Data
+ (NSArray *)eumDirNameArray{
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"eLongFileDirTypeKey_NameValue" ofType:@"plist"];
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]] && [dataDic count] > 0) {
            dirNameArray = [dataDic safeObjectForKey:@"FileDirName"];
        }
    });
    if (!(dirNameArray && [dirNameArray isKindOfClass:[NSArray class]] && dirNameArray.count > 0))
        dirNameArray = nil;
    return dirNameArray;
}

#pragma mark -Write
- (BOOL) writeFileWithModel:(eLongFileWriteModel *)writeModel{
    NSString *dirPath = [writeModel dirPathWithEumArray:dirNameArray];
    NSString *megStr = @"OK";
    if ([dirPath notEmpty]) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,writeModel.fileName];
        NSLog(@"%@",filePath);
        NSError *error;
        if ([FCFileManager existsItemAtPath:filePath]) {
            //exists
            [FCFileManager removeItemAtPath:filePath error:&error];
            if (!error) {
                [FCFileManager writeFileAtPath:filePath content:writeModel.data error:&error];
                if (!error) {
                    return YES;
                }else{
                    megStr = @"写入失败";
                    return NO;
                }
            }else{
                megStr = @"删除失败";
                return NO;
            }
        }else{
            //not exists
            [FCFileManager writeFileAtPath:filePath content:writeModel.data error:&error];
            if (!error) {
                return YES;
            }
        }
    }
    megStr = @"路径为空";
    return NO;
}

#pragma mark -Read

- (id) readFileWithModel:(eLongFileReadModel *)readModel{
    NSString * path = [readModel readFilePath];
    if (readModel.inMainBundle) {
       path =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:readModel.fileName];
    }
    NSObject * data = nil;
    
    // 文件路径不存在
    if ([path empty]) {
        return nil;
    }
    // 读权限
    if (![FCFileManager isReadableItemAtPath:path]) {
        return nil;
    }
    
    // 若扩展名隐藏，则显示扩展名
    if ([[FCFileManager attributesOfItemAtPath:path] fileExtensionHidden]) {
        NSDictionary * attributes = [FCFileManager attributesOfItemAtPath:path];
        NSMutableDictionary * mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
        
        [mutableAttributes setObject:@(NO) forKey:NSFileExtensionHidden];
        
        [FCFileManager setAttributes:mutableAttributes ofItemAtPath:path];
    }
    
    // 扩展名为plist的，读取数据 NSArray, NSDictionary
    if ([FCFileManager isPath:path hasExtension:@"plist"]) {
        NSDictionary * dict = [FCFileManager readFileAtPathAsDictionary:path];
        if (dict && [dict isKindOfClass:[NSDictionary class]] && [dict count] > 0) {
            data = dict;
        }
        else{
            NSArray * array = [FCFileManager readFileAtPathAsArray:path];
            if (array && [array isKindOfClass:[NSArray class]] && array.count > 0){
                data = array;
            }
        }
    }
    // 扩展名为png, jpg,jpeg的，读取数据  UIImage
    else if ([FCFileManager isPath:path hasExtension:@"png"]
             || [FCFileManager isPath:path hasExtension:@"jpg"]
             || [FCFileManager isPath:path hasExtension:@"jpeg"]){
        UIImage * image = [FCFileManager readFileAtPathAsImage:path];
        if (image) {
            data = image;
        }
    }
    // 扩展名为txt 的，读取数据 NSString
    else if ([FCFileManager isPath:path hasExtension:@"txt"]){
        NSString * string = [FCFileManager readFileAtPathAsString:path];
        if ([string notEmpty]) {
            data = string;
        }
    }
    
    return data;
}

+ (void) saveObject:(NSObject *)obj InUserdefaultsforKey:(NSString *)key{
    [[NSUserDefaults  standardUserDefaults]setObject:obj forKey:key];
    [[NSUserDefaults   standardUserDefaults]synchronize];
}

+ (NSObject *) getObjectFromUserdefaultsForKey:(NSString *)key{
    return  [[NSUserDefaults  standardUserDefaults]objectForKey:key];
}

+ (void)saveSearchKey:(NSString *)key forCity:(NSString *)city {
    [self saveSearchKey:key type:nil propertiesId:nil lat:nil lng:nil forCity:city];
}

+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSString *)pid lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city{
    [self saveSearchKey:key type:type propertiesId:pid propertiesType:nil lat:lat lng:lng forCity:city];
}

+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSString *)pid propertiesType:(NSNumber *)pidType lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city{
    NSMutableDictionary *hotelSearchKeywordDict = nil;
    NSObject* hotelSearchKeywordObj = [eLongUserDefault objectForKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
    if (![hotelSearchKeywordObj isKindOfClass:[NSDictionary class]]) {
        hotelSearchKeywordDict = [NSMutableDictionary dictionary];
    }else{
        hotelSearchKeywordDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)hotelSearchKeywordObj];
    }
    
    if (STRINGHASVALUE(key) && STRINGHASVALUE(city)) {
        NSMutableArray *hotelSearchKeywordArray = [NSMutableArray arrayWithArray:[hotelSearchKeywordDict objectForKey:city]];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict safeSetObject:key forKey:@"Name"];
        if (type) {
            [dict setObject:type forKey:@"Type"];
        }
        if (pid) {
            [dict setObject:pid forKey:@"PropertiesId"];
        }
        if (pidType) {
            [dict setObject:pidType forKey:@"PropertiesIdType"];
        }
        if (lat) {
            [dict setObject:lat forKey:@"Lat"];
        }
        if (lng) {
            [dict setObject:lng forKey:@"Lng"];
        }
        
        if (![hotelSearchKeywordArray containsObject:dict]) {
            [hotelSearchKeywordArray insertObject:dict atIndex:0];
            
            while (hotelSearchKeywordArray.count > HOTEL_KEYWORDHISTORY_NUM) {
                [hotelSearchKeywordArray removeLastObject];
            }
            
            [hotelSearchKeywordDict setObject:hotelSearchKeywordArray forKey:city];
            [eLongUserDefault setObject:hotelSearchKeywordDict forKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
        }
    }
}

// 获取保存的数据
+ (NSMutableArray *)arrayDateSaved:(NSString *)saveFileName andSaveKey:(NSString *)keyName
{
    NSMutableArray *arrayDataSaved = [NSMutableArray arrayWithCapacity:0];
    
    // 获取document文件夹位置
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths safeObjectAtIndex:0];
    
    // 加载文件
    NSString *saveDataPath = [documentDirectory stringByAppendingPathComponent:saveFileName];
    
    // 文件存在
    if([[NSFileManager defaultManager] fileExistsAtPath:saveDataPath] == YES)
    {
        NSData *decoderdata = [[NSData alloc] initWithContentsOfFile:saveDataPath];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:decoderdata];
        
        //解档出数据模型
        NSMutableArray *dataFromFile = [unarchiver decodeObjectForKey:keyName];
        [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
        
        arrayDataSaved = [NSMutableArray arrayWithArray:dataFromFile];
        
    }
    
    return arrayDataSaved;
}
// 保存数据
+ (void)saveData:(NSMutableArray *)arrayDataSaved withFileName:(NSString *)saveFileName andSaveKey:(NSString *)keyName
{
    if (arrayDataSaved != nil)
    {
        // 获取document文件夹位置
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths safeObjectAtIndex:0];
        NSString *dataFilePath = [documentDirectory stringByAppendingPathComponent:saveFileName];
        
        // 写入文件
        NSMutableData * data = [[NSMutableData alloc] init];
        // 这个NSKeyedArchiver是进行编码用的
        NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:arrayDataSaved forKey:keyName];
        [archiver finishEncoding];
        // 编码完成后的NSData，使用其写文件接口写入文件存起来
        [data writeToFile:dataFilePath atomically:YES];
    }
}


@end
