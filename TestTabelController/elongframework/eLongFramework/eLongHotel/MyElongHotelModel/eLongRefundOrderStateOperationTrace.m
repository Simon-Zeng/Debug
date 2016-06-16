//
//  eLongRefundOrderStateOperationTrace.m
//  ElongClient
//
//  Created by lvyue on 15/4/2.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRefundOrderStateOperationTrace.h"

@implementation eLongRefundOrderStateOperationTrace


- (BOOL)isEqual:(id)object{
    if (object && [object isKindOfClass:[eLongRefundOrderStateOperationTrace class]]) {
        eLongRefundOrderStateOperationTrace *oneTrace = (eLongRefundOrderStateOperationTrace *)object;
        return
        _OperationType == oneTrace.OperationType
        && [_OperationResultDescCn isEqualToString:oneTrace.OperationResultDescCn]
        && [_OperationTime isEqualToString:oneTrace.OperationTime]
        && [_ResultStatusCn isEqualToString:oneTrace.ResultStatusCn];
    }
    return NO;
}
@end
