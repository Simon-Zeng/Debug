//
//  eLongAccountCAInstance.m
//  ElongClient
//
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountCAInstance.h"
#import "eLongAccountCAModel.h"
#import "eLongAccountManager.h"

@interface eLongAccountCAInstance ()
@property (nonatomic,strong) eLongAccountCAModel *cashModel;
@end

@implementation eLongAccountCAInstance

-(id)init{
    if (self = [super init]) {
        //RegisterNotification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCA) name:Notification_AccountCA_ReFresh object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshCA{
    [self requestTheCashAccountByCardNo:[eLongAccountManager userInstance].cardNo
                                BizType:ElongCABizType_Myelong
                              Successed:^(eLongHTTPRequestOperation *op,id object){
                                  
                                  NSDictionary *dic = (NSDictionary *)object;
                                  NSError *error = nil;
                                  eLongAccountCAModel *model = [[eLongAccountCAModel alloc] initWithDictionary:dic error:&error];
                                  if (error) {
                                      NSLog(@"SomeThing wrong happened --%@",error);
                                  }else{
                                      self.cashModel = model;
                                  }
                                  
                              } Failed:nil];
}

-(void)requestTheCashAccountByCardNo:(NSString *)cardNo
                             BizType:(ElongCABizType)type
                           Successed:(NetSuccessCallBack)success
                               Failed:(NetFailedCallBack)failed{
    NSDictionary *req = @{@"MemberCardNo":cardNo,@"BizType":@(type)};
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"myelong/cashAmountByBizType"
                                                                       params:req method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *op,id object){
    
        if (type == ElongCABizType_Myelong) {
            //只针对个人中心做处理
            NSDictionary *dic = (NSDictionary *)object;
            NSError *error = nil;
            eLongAccountCAModel *model = [[eLongAccountCAModel alloc] initWithDictionary:dic error:&error];
            if (error) {
                NSLog(@"SomeThing wrong happened --%@",error);
            }else{
                self.cashModel = model;
            }
        }
        success(op,object);
    } failure:failed];
}

-(void)requestTheCAIncomeAndExpensesDetailWithCardNo:(NSString *)carNo
                                         AccountType:(ElongAccountType)type
                                             InOrOut:(InAndExpType)_inOutType
                                           PageIndex:(NSInteger)index
                                            PageSize:(NSInteger)size
                                           Successed:(NetSuccessCallBack )success
                                              Failed:(NetFailedCallBack )failed{
    
    NSDictionary *req = @{@"accountType":@(type),@"incomeAndExpensesType":@(_inOutType),@"cardNumber":carNo,@"pageIndex":@(index),@"pageSize":@(size)};
    
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"myelong/getIncomeAndExpensesRecord"
                                                                       params:req
                                                                       method:eLongNetworkRequestMethodGET];
    
    [eLongHTTPRequest startRequest:request success:success  failure:failed];
}

#pragma mark ------ReadOnly IMP
-(double)totalAccount{
    if (nil != self.cashModel) {
        return floor([self.cashModel.Remainingamount doubleValue])+floor([self.cashModel.LockedAmount doubleValue]);
    }else{
        return 0;
    }
}
-(double)cashAmount{
    if (nil != self.cashModel) {
        return floor([self.cashModel.BackCashAmount doubleValue])+floor([self.cashModel.LockedAmount doubleValue]);
    }else{
        return 0;
    }
}
-(double)hongBaoAmount{

    if (nil != self.cashModel) {
        return floor([self.cashModel.GiftCardAmount doubleValue]);
    }else{
        return 0;
    }
}
-(double)prePayCardAmount{
    if (nil != self.cashModel) {
        return floor([self.cashModel.SpecifiedAmount doubleValue])+floor([self.cashModel.UniversalAmount doubleValue]);
    }else{
        return 0;
    }
}

@end
