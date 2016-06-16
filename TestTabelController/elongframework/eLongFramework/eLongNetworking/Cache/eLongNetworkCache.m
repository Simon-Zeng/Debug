//
//  eLongNetworkCache.m
//  eLongNetworking
//
//  Created by Dawn on 14-12-4.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongNetworkCache.h"
#import <UIKit/UIKit.h>

#define TIME  @"timedate"
#define CACHEDATA  @"cachedate"
//by 宋斌
#define CacheTimeInterval @"CacheTimeInterval"
static const NSInteger eLongNetworkCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week

@interface eLongNetworkCache()
@property (nonatomic,strong) NSCache *cache;

@end

@implementation eLongNetworkCache

+ (instancetype) shareInstance{
    static  eLongNetworkCache  *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[eLongNetworkCache  alloc]init];
    });
    return instance;
}


- (id) init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

- (void) clearMemory{
    [self.cache removeAllObjects];
}

- (void) cleanDisk{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSMutableString  *path = [[NSMutableString  alloc]initWithFormat:@"%@",[paths  objectAtIndex:0]];
        [path appendFormat:@"/eLongNetCache"];
        
        NSURL *diskCacheURL = [NSURL fileURLWithPath:path isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        NSFileManager  *fileManager = [NSFileManager defaultManager];
        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [fileManager    enumeratorAtURL:diskCacheURL
                                                     includingPropertiesForKeys:resourceKeys
                                                                        options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                   errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-eLongNetworkCacheMaxCacheAge];
        
        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [fileManager removeItemAtURL:fileURL error:nil];
        }
    });
}

- (void)cacheData:(NSData *)data forRequest:(NSURLRequest *)request {
    NSString  *key = [request  valueForHTTPHeaderField:@"_eLongNetworkCacheKey"];
    float  interval = [[request  valueForHTTPHeaderField:@"_eLongNetworkCacheTimeInterval"] floatValue];
    //获取缓存文件夹
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString  *path = [[NSMutableString  alloc]initWithFormat:@"%@",[paths  objectAtIndex:0]];
    [path appendFormat:@"/eLongNetCache"];
    NSFileManager  *fileManager = [NSFileManager  defaultManager];
    
    //判断文件是否存在,如果不存在，创建文件
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager  createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [path appendFormat:@"/%@",key];
    
    // 写入缓存
    [self.cache setObject:@{TIME:[NSDate date],CACHEDATA:data,CacheTimeInterval:[NSNumber numberWithFloat:interval]} forKey:key];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [data  writeToFile:path atomically:YES];
    });
}

- (NSData *)cacheForRequest:(NSURLRequest *)request {
    //取唯一标示
    NSString  *key = [request  valueForHTTPHeaderField:@"_eLongNetworkCacheKey"];
    //间隔时间
    float  interval = [[request  valueForHTTPHeaderField:@"_eLongNetworkCacheTimeInterval"] floatValue];
    //获取缓存文件夹
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString  *path = [[NSMutableString  alloc]initWithFormat:@"%@",[paths  objectAtIndex:0]];
    [path appendFormat:@"/eLongNetCache/%@",key];
    return [self  readDataFromCacheForKey:key forPath:path forInterval:interval];
}

- (NSData *)readDataFromCacheForKey:(NSString *)key forPath:(NSString *) path forInterval:(NSTimeInterval)interval {
    if (key == nil){
        return nil;
    }
    //取文件系统里的
    NSFileManager  *manager = [NSFileManager defaultManager];
    //先从内存里面取
    NSDictionary  *cacheDic = [self.cache objectForKey:key];
    if (cacheDic) {
        //如果内存里有的，判断有没有过期
        if ([cacheDic objectForKey:TIME]) {
            //从字典里取时间
            NSDate *dateBefore = [cacheDic objectForKey:TIME];
            NSDate  *dateNow = [NSDate date];
            //已经过期
            
            if ([cacheDic objectForKey:CacheTimeInterval]) {
                float cacheTimeInterval = [[cacheDic objectForKey:CacheTimeInterval] floatValue];
                if ([dateNow  timeIntervalSinceDate:dateBefore]>= cacheTimeInterval) {
                    //删除文件
                    return nil;
                }
                NSData *data = [cacheDic  objectForKey:CACHEDATA];
                return data;
            }else{
                return nil;
            }
        }
        return nil;
        
    }else {
        //文件里没有
        if (![manager  fileExistsAtPath:path]) {
            return nil;
        }
        //文件夹里取到了
        NSData  *data = [manager  contentsAtPath:path];
        //没有数据
        if (!data||data.length<= 0) {
            return nil;
        }
        NSError  *error;
        //有数据,先看有没有过期,针对内存中之前存过此数据，后来被系统释放掉了，再从文件中取可能过期的情况
        NSDictionary  *atributDic = [manager  attributesOfItemAtPath:path error:&error];
        //取上次文件修改的时间
        NSDate  *dateBefore = [atributDic  objectForKey:NSFileModificationDate];
        if (dateBefore ) {
            NSDate  *dateNow = [NSDate date];
            //已经过期
            if ([dateNow  timeIntervalSinceDate:dateBefore]>= interval) {
                //删除文件
                return nil;
            }
            //没有过期
            cacheDic = [NSDictionary  dictionaryWithObjectsAndKeys:dateBefore,TIME,data,CACHEDATA, nil];
            [self.cache setObject:cacheDic forKey:key];
            return data;
        }
        return nil;
    }
    return nil;
}


@end
