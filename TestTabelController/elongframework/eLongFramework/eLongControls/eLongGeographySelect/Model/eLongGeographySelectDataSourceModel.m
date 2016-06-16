//
//  eLongGeographySelectDataSourceModel.m
//  Pods
//
//  Created by chenggong on 15/9/16.
//
//

#import "eLongGeographySelectDataSourceModel.h"
#import "eLongLocation.h"
#import "NSArray+CheckArray.h"

@interface eLongGeographySelectDataSourceModel ()

@property (nonatomic, strong) eLongGeographySelectModel *geographySelectModel;

@property (nonatomic, assign) NSInteger saveCityCount;

@end

@implementation eLongGeographySelectDataSourceModel

- (instancetype)initWithGeographySelectModel:(eLongGeographySelectModel *)model {
    if (self = [super init]) {
        if (model) {
            self.geographySelectModel = model;
            self.saveCityCount = model.historyCityCount == 0 ? 4 : model.historyCityCount;
        }
    }
    return self;
}

- (void)saveSearchHistory:(eLongGeographySelectDetailModel *)geographySelectDetailModel {
    NSMutableArray *history = [NSMutableArray arrayWithArray:[self histories]];
    
    if(history.count == 0 && _geographySelectModel.isHistoryDisplay){
        [_geographySelectSectionIndexTitles insertObject:@"历史" atIndex:1];
        
        NSMutableArray *ma=[[NSMutableArray alloc] init];
        [_geographySelectSections insertObject:ma atIndex:1];
    }
    
    NSString *pinyin = geographySelectDetailModel.cityPy;
    NSString *cityId = geographySelectDetailModel.cityNum;
    NSString *cityName = geographySelectDetailModel.cityName;
    NSString *advisedkeyword = geographySelectDetailModel.advisedkeyword;
    if (pinyin == nil) {
        // city suggestion pinyin is nil
        pinyin = geographySelectDetailModel.cityCode;
    }
    
    //城市项
    NSArray *cityItem=[NSArray arrayWithObjects:cityName,pinyin,cityId,advisedkeyword,nil];
    
    NSArray *duplicateCity = nil;
    for (NSArray *city in history) {
        if ([city count] > 2) {
            NSString *tempId = [city objectAtIndex:2];
            if ([tempId isEqualToString:cityId]) {
                duplicateCity = city;
                break;
            }
        }
    }
    
    if (duplicateCity) {
        [history removeObject:duplicateCity];
    }
    
    [history insertObject:cityItem atIndex:0];
    
    if (history.count>self.saveCityCount) {
        [history removeLastObject];
    }
    
    [_geographySelectSections removeObjectAtIndex:1];
    NSMutableArray *ma=[[NSMutableArray alloc] init];
    [ma addObject:history];
    
    [_geographySelectSections insertObject:ma atIndex:1];
    
    [[NSUserDefaults standardUserDefaults] setObject:history forKey:_geographySelectModel.persistanceHistoryName];
}

-(NSArray *)histories{
    return [[NSUserDefaults standardUserDefaults] objectForKey:_geographySelectModel.persistanceHistoryName];
}

- (NSMutableArray *)sections{
    if (_geographySelectSections == nil) {
        self.geographySelectSections = [[NSMutableArray alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:_geographySelectModel.persistanceDirectoryName];
        filePath = [filePath stringByAppendingPathComponent:_geographySelectModel.persistanceFileName];
        
        NSDictionary *geographyDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        for (int i = 0; i < [geographyDictionary allKeys].count; i++)
        {
            NSString *sectionKey = [[geographyDictionary allKeys] objectAtIndex:i];
            NSArray *geos = [geographyDictionary objectForKey:sectionKey];
            
            if (geos.count > 0) {
                NSMutableArray *ma = [NSMutableArray arrayWithCapacity:0];
                [_geographySelectSections addObject:ma];
            } else {
                if (![sectionKey isEqualToString:@"当前"]) {
                    [_geographySelectSectionIndexTitles removeObject:sectionKey];
                }
            }
        }
        
        NSInteger sectionIndex = 0;
        for (int i = 0; i < [self.sectionIndexTitles count]; i++)
        {
            NSString *sectionKey = [_geographySelectSectionIndexTitles objectAtIndex:i];
            
            NSArray *citys = [geographyDictionary objectForKey:sectionKey];
            
            if ([citys count] > 0)
            {
                // 热点展示
                if ([sectionKey isEqualToString:@"热门"]) {
                    if (_geographySelectModel.isHotDisplay) {
                        [[_geographySelectSections objectAtIndex:sectionIndex] addObject:citys];
                    }
                } else {
                    for (NSArray *city in citys)
                    {
                        [[_geographySelectSections objectAtIndex:sectionIndex] addObject:city];
                    }
                }
                sectionIndex++;
            }
        }
        
        // 选择历史展示
        NSArray *histories = [self histories];
        if(_geographySelectModel.isHistoryDisplay && histories && [histories count])       // 判断是否有历史搜索
        {
            NSMutableArray *ma = [NSMutableArray arrayWithCapacity:0];
            [ma addObject:histories];
            
            [_geographySelectSections insertObject:ma atIndex:0];
        }
        
        
        // 定位展示
        if (_geographySelectModel.isLocationDisplay) {
            NSMutableArray *arrayCurrLocation = [NSMutableArray arrayWithCapacity:0];
            NSArray *currLocation = [NSArray arrayWithObjects:@"当前位置", @"", @"", nil];
            [arrayCurrLocation addObject:currLocation];
            [_geographySelectSections insertObject:arrayCurrLocation atIndex:0];
        }
    }
    
    return _geographySelectSections;
}

- (NSMutableArray *)sectionIndexTitles {
    if (_geographySelectSectionIndexTitles == nil) {
        self.geographySelectSectionIndexTitles = [NSMutableArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N",@"P", @"Q", @"R", @"S",@"T", @"W", @"X", @"Y", @"Z", nil];
        // 搜索热点
        if (_geographySelectModel.isHotDisplay) {
            [_geographySelectSectionIndexTitles insertObject:@"热门" atIndex:0];
        }
        
        // 搜索历史
        if (_geographySelectModel.isHistoryDisplay && [self histories] && [[self histories] count]) {
            [_geographySelectSectionIndexTitles insertObject:@"历史" atIndex:0];
        }
        
        // 定位展示
        if (_geographySelectModel.isLocationDisplay) {
            [_geographySelectSectionIndexTitles insertObject:@"当前" atIndex:0];
        }
    }
    
    return _geographySelectSectionIndexTitles;
}

- (NSString *)currentPosition {
    eLongLocation *positionManager = [eLongLocation sharedInstance];
    return [positionManager simpleAddress];
}

- (NSString *)currentPositionWithFullAddress {
    eLongLocation *positionManager = [eLongLocation sharedInstance];
    return [positionManager fullAddress];
}

@end
