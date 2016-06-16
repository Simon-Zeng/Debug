//
//  eLongHtml5WebController.h
//  InterHotel
//
//  Created by 张馨允 on 16/3/1.
//  Copyright © 2016年 eLong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "eLongRoundCornerView.h"

typedef enum {
    CASH_BACK,           //银行卡提现
    HOTEL_MODIFYORDER,      //修改订单
    HOTEL_FEEDBACK,      //酒店入住反馈
    HOTEL_ORDER_REBATE    //个人中心申请返现
}H5Type;

@interface eLongHtml5WebController : ElongBaseViewController

- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url;
- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url style:(NavBarBtnStyle)navStyle;
- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url FromType:(H5Type)type;
- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style params:(NSDictionary *)params;
@end
