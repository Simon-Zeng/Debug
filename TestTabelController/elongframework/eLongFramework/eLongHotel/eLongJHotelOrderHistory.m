//
//  eLongJHotelOrderHistory.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "eLongJHotelOrderHistory.h"
#import "eLongNetworkSerialization.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"
#import "eLongTimeUtil.h"

@implementation eLongJHotelOrderHistory

-(void)buildPostData:(BOOL)clearhotelsearch
{
	if (clearhotelsearch) {
		[contents safeSetObject:[[eLongAccountManager userInstance]cardNo] forKey:@"CardNo"];
		[contents safeSetObject:[NSNumber numberWithInt:10] forKey:@"PageSize"];
		[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"PageIndex"];
		[contents removeObjectForKey:@"StartTime"];
		[contents removeObjectForKey:@"EndTime"];
	}
}

-(id)init
{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
        pageIndex = 0;
		[self clearBuildData];
	}
	return self;
}

-(void)clearBuildData
{
	[self buildPostData:YES];
}

-(void)setPageSize:(int)aPageSize{
    [contents safeSetObject:[NSNumber numberWithInt:aPageSize] forKey:@"PageSize"];
}

-(void)setHalfYear
{
    NSDate *date = [eLongTimeUtil getPreviousDateWithMonth:-6];
    NSString *str = [eLongTimeUtil displayDateWithNSDate:date formatter:@"yyyy-MM-dd"];
    [contents safeSetObject:str forKey:@"StartTime"];
    [contents removeObjectForKey:@"EndTime"];
	
}

-(void)setOneYear
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [NSDate date];
	NSString *str = [df stringFromDate:date];
	NSArray *array = [str componentsSeparatedByString:@"-"];
	NSString *year,*month,*day;
	day = [array safeObjectAtIndex:2];
	
	if([[array safeObjectAtIndex:1] intValue]<7){
		month =[NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:1] intValue]+12-6];
		year = [NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:0] intValue]-1];
	}else {
		year = [NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:0] intValue]];
		month = [NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:1] intValue]-6];
	}
	
	NSString *endStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
	
	NSString *year1,*month1,*day1;
	year1 = [NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:0] intValue]-1];
	month1 = [array safeObjectAtIndex:1];
	day1 = [array safeObjectAtIndex:2];
	
	NSString *startStr = [NSString stringWithFormat:@"%@-%@-%@",year1,month1,day1];
	[contents safeSetObject:startStr forKey:@"StartTime"];
	[contents safeSetObject:endStr forKey:@"EndTime"];
}

-(void)nextPage
{
    pageIndex ++;
	[contents safeSetObject:[NSNumber numberWithInteger:pageIndex] forKey:@"PageIndex"];
}

//上一页
-(void)prePage{
    pageIndex --;
	[contents safeSetObject:[NSNumber numberWithInteger:pageIndex] forKey:@"PageIndex"];
}

- (void)setPageZero
{
    pageIndex = 0;
}

- (NSString *)javaRequestString{
    [contents safeSetObject:[[eLongAccountManager userInstance]cardNo] forKey:@"CardNo"];
    return [eLongNetworkSerialization jsonStringWithObject:contents];
}

- (NSDictionary *)requestDic{
    [contents safeSetObject:[[eLongAccountManager userInstance]cardNo] forKey:@"CardNo"];
    return [NSDictionary dictionaryWithDictionary:contents];
}


@end
