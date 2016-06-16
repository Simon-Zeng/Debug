//
//  eLongOrderRefundOperationTraceListModel.h
//  ElongClient
//
//  Created by lvyue on 15/4/7.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongRefundOrderStateOperationTrace.h"

@protocol eLongOrderRefundOperationTraceListModel@end

@interface eLongOrderRefundOperationTraceListModel : eLongResponseBaseModel

@property (nonatomic ,strong)NSArray <eLongRefundOrderStateOperationTrace> * refundOperationTraceList;
@end
