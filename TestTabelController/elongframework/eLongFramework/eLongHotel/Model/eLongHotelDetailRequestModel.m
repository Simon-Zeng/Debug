//
//  eLongHotelDetailRequestModel.m
//  ElongClient
//
//  Created by Dawn on 15/1/21.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongHotelDetailRequestModel.h"
#import "eLongAccountManager.h"
#import "eLongDefine.h"

@implementation eLongHotelDetailRequestModel
- (NSDictionary *) requestParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.hotelId forKey:@"hotelId"];           // hotelId
    [params setValue:self.checkInDate forKey:@"checkInDate"];   // 入住日期
    [params setValue:self.checkOutDate forKey:@"checkOutDate"]; // 离店日期
    [params setValue:@(YES) forKey:@"currencySupport"];         // 是否支持货币种类
    // 设置cardNO
//    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[eLongAccountManager userInstance]isLogin]) {
        [params setValue:@(0) forKey:@"CardNo"];
    }
    else {
        BOOL islogin = [[eLongAccountManager userInstance] isLogin];
        if (islogin){
            [params setValue:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
        }else{
            [params removeObjectForKey:@"CardNo"];
        }
    }
    
    [params setValue:@(YES) forKey:@"includePrePay"];           // 包含预付
    [params setValue:@(YES) forKey:@"includeMultiSuppliers"];   // 包含多供应商房型
    [params setValue:@(YES) forKey:@"includeJW"];               // 包括万豪酒店
    [params setValue:@(0) forKey:@"imageType"];                 // 图片分类(所有图片=0，餐厅=1，休闲=2，会议室=3，酒店外观=5，大堂接待台=6，客房=8，背景图=9，其他=10)
    /*
     图片尺寸:宽度350高度不定jpg=1，70x70jpg=2，120x120 jpg=3，宽度160高度不定jpg=4，70x70png=5，120x120png=6，宽度640高度不定jpg=7，220×220png=8，230x173jpg=9，230x172jpg=10，286x233jpg=11，宽度698高度不定jpg=12，698x308jpg=13，306x133jpg=14，640x310 jpg=15，262x165jpg=16，160x110jpg=17
     */
    [params setValue:@(1) forKey:@"imageSize"];
    if (SCREEN_55_INCH) {
        [params setValue:@(12) forKey:@"roomTypeImageList_imageSize"];
    }else{
        [params setValue:@(1) forKey:@"roomTypeImageList_imageSize"];
    }
    [params setValue:@(2) forKey:@"roomHoldingRule"];
    [params setValue:@(self.isUnsigned) forKey:@"isUnsigned"];
    [params setValue:@(self.isAroundSale) forKey:@"isAroundSale"];
    [params setValue:@(YES) forKey:@"hasHongbao"];
    return params;
}

- (NSString *) requestBusiness{
    return @"hotel/getHotelDetailByRoomGroup";
}
@end
