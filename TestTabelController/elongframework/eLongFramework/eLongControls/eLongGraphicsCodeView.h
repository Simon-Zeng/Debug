//
//  eLongGraphicsCodeView.h
//  ElongClient
//
//  Created by Janven Zhao on 14/11/8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class eLongEmbedTextField,eLongRoundCornerView;
@interface eLongGraphicsCodeView : UIView<UITextFieldDelegate>
{
    eLongEmbedTextField *_checkCodeField;
    eLongRoundCornerView *checkCodeImageView;
    UIActivityIndicatorView  *checkCodeIndicatorView;
}
@property (nonatomic,copy) NSString *checkURL;
@property (nonatomic,copy) NSString *checkNums;
/*!
 *  初始化方法
 *
 *  @param frame        frame
 *  @param checkCodeUrl 有就传 没有可传nil或@""
 *
 *  @return 实例
 */
-(id)initWithFrame:(CGRect)frame andImageURL:(NSString *)checkCodeUrl;

/*!
 *  刷新图形验证码
 */
-(void)refreshTheGrapicsCode;

/*!
 *  回收键盘
 */
-(void)resignTheKeyBorad;

@end
