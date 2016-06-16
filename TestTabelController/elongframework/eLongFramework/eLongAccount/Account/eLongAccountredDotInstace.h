//
//  eLongAccountredDotInstace.h
//  ElongClient
//
//  Created by lvyue on 15/4/8.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountInstanceBase.h"
#import "elongAccountDefine.h"

@interface eLongAccountredDotInstace : eLongAccountInstanceBase
/**
 *  请求未读红点接口
 */
-(void)requestRedDotWithPCardNo:(NSString *)cardNo Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;
@end
