//
//  NetworkSerialization.m
//  TestTabelController
//
//  Created by wzg on 16/6/30.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "NetworkSerialization.h"
#import <objc/runtime.h>

@implementation NetworkSerialization
+(NSString *)jsonStringWithObject:(id)object
{
    NSError  *error;
    NSString  *string= nil;
    if ([object  isKindOfClass:[NSDictionary  class]]) {
        
        if ([NetworkSerialization  adjustIsIos5]) {
            NSData  *data = [NSJSONSerialization  dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
            string = [[NSString  alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }else
        {
            string = nil;// [(NSDictionary *)object  JSONString];
        }
        return string;
    }
    if ([object  isKindOfClass:[NSArray  class]]) {
        if ([NetworkSerialization  adjustIsIos5]) {
            NSData  *data = [NSJSONSerialization  dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
            string = [[NSString  alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }else
        {
            string = nil;//[(NSArray *)object  JSONString];
        }
        return string;
    }
    if ([object isKindOfClass:[NSString  class]]) {
        if ([NetworkSerialization  adjustIsIos5]) {
            NSData  *data = [NSJSONSerialization  dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
            string = [[NSString  alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }else
        {
            string = nil;//[(NSString *)object  JSONString];
        }
        return string;
    }else
    {  //自定义的model类,先将其转为字典
        NSArray *listAr = [NetworkSerialization getPropertyList:object];
        if (listAr &&listAr.count > 0)
        {
            NSDictionary  *parseDic = [NetworkSerialization  convertObjectFromGievnPropertyList:listAr with:object];
            
            if (parseDic&&parseDic.count>0)
            {
                if ([NetworkSerialization adjustIsIos5])
                {
                    NSData  *data = [NSJSONSerialization  dataWithJSONObject:parseDic options:NSJSONWritingPrettyPrinted error:&error];
                    string = [[NSString  alloc]initWithData:data encoding:NSUTF8StringEncoding];
                }else
                {
                    string = nil;//[parseDic  JSONString];
                }
                return  string;
            }
            
        }
    }
    return nil;
}

+(NSData *)jsonDataWithObject:(id)object
{
    NSError  *error;
    NSData  *data = nil;
    if ([object isKindOfClass:[NSDictionary  class]]) {
        if ([NetworkSerialization  adjustIsIos5]) {
            data = [NSJSONSerialization  dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        }else
        {
            data = nil;//[(NSDictionary *)object  JSONData];
        }
        return   data;
    }
    if ([object isKindOfClass:[NSArray class]]) {
        if ([NetworkSerialization  adjustIsIos5]) {
            data = [NSJSONSerialization  dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        }else
        {
            data = nil;//[(NSArray *)object  JSONData];
        }
        
        return data;
    }
    if ([object isKindOfClass:[NSString class]]) {
        if ([NetworkSerialization  adjustIsIos5]) {
            data = [NSJSONSerialization  dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        }else
        {
            data = nil;//[(NSString *)object  JSONData];
        }
        return data;
    }else
    {
        //自定义的model类,先将其转为字典
        NSArray *listAr = [NetworkSerialization getPropertyList:object];
        if (listAr &&listAr.count > 0)
        {
            NSDictionary  *parseDic = [NetworkSerialization  convertObjectFromGievnPropertyList:listAr with:object];
            
            if (parseDic&&parseDic.count>0)
            {
                if ([NetworkSerialization  adjustIsIos5]) {
                    data = [NSJSONSerialization  dataWithJSONObject:parseDic options:NSJSONWritingPrettyPrinted error:&error];
                }else
                {
                    data = nil;//[parseDic  JSONData];
                }
                
                return data;
            }
            
        }
    }
    return nil;
}


+ (NSString *)removeUnescapedCharacter:(NSString *)inputStr {
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];//获取那些特殊字符
    NSRange range = [inputStr rangeOfCharacterFromSet:controlChars];//寻找字符串中有没有这些特殊字符
    if (range.location != NSNotFound)    {
        NSMutableString *mutable = [NSMutableString stringWithString:inputStr];
        while (range.location != NSNotFound)        {
            [mutable deleteCharactersInRange:range];//去掉这些特殊字符
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputStr;
}


+(BOOL) adjustIsIos5
{
    Class clazz = NSClassFromString(@"NSJSONSerialization");
    if (clazz) {
        return YES;
    }
    return NO;
}

+(id)jsonObjectWithData:(NSData *)data
{
    if (data == nil){
        return nil;
    }
    id  object = nil;
    NSError *error;
    //代表在ios5以上
    if ([self  adjustIsIos5]) {
        object = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (object == nil) {
            NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (jsonStr.length) {
                jsonStr = [NetworkSerialization removeUnescapedCharacter:jsonStr];
                NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                if (jsonData && jsonData.length) {
                    object = [NSJSONSerialization  JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                }
            }
        }
    }else
    {
        //ios5以下
        object = nil;//[data  objectFromJSONData];
    }
    
    return object;
}


+(id)jsonObjectWithString:(NSString *)string
{
    id object = nil;
    NSError  *error;
    NSData  *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if ([self  adjustIsIos5]) {
        object = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }else
    {
        object = nil;//[string  objectFromJSONString];
    }
    return object;
    
}
//拿到对象的属性列表
+ (NSMutableArray *)getPropertyList:(id)obj{
    
    NSMutableArray *propertyAr = [NSMutableArray array];
    NSString *className = NSStringFromClass([obj class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    u_int count;
    objc_property_t *properties = class_copyPropertyList(theClass, &count);
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyAr addObject:[NSString stringWithUTF8String:propertyName] ];
        
    }
    free(properties);
    return propertyAr;
}

//将对象的属性和value都存到字典里,包含嵌套的对象类
+ (NSMutableDictionary *)convertObjectFromGievnPropertyList:(NSArray*)list   with:(NSObject *)obj{
    
    NSMutableDictionary  *dic = [NSMutableDictionary  dictionary];
    if (list && list.count>0) {
        for (NSString *key in list) {
            NSDictionary  *dddic = nil;;
            id subObj = [obj valueForKey:key];
            //如果model类的属性没有赋值，则不将其加到字典里
            if (!subObj||[subObj isEqual:[NSNull  null]])
            {
                continue;
            }
            if (![subObj isKindOfClass:[NSString class]] &&![subObj  isKindOfClass:[NSDictionary  class]]&&![subObj isKindOfClass:[NSArray  class]]) {
                id subObj = [obj valueForKey:key];
                if (subObj)
                {
                    dddic = (NSDictionary *)[self  convertObjectFromGievnPropertyList:[NetworkSerialization  getPropertyList:subObj] with:subObj];
                }
            }
            [dic  setObject:subObj forKey:key];
            if (dddic) {
                [dic setValue:dddic  forKey:key];
            }
        }
    }
    
    return dic;
}

+ (NSString *)jsonStringWithData:(NSData *)data
{
    return [self jsonStringWithObject:[self jsonObjectWithData:data]];
}

@end
