//
//  ElongBaseViewControllerWithEmptyView.h
//
//
//  Created by yangfan on 16/1/7.
//
//

#import "ElongBaseViewController.h"
@interface ElongBaseViewControllerWithEmptyView : ElongBaseViewController

@property (nonatomic, strong) UIView * emptyView;
@property (nonatomic, strong) UILabel * tipLabel;
@property (nonatomic, strong) UIImageView * emptyImage;

/**
 *  在未请求到数据时显示在页面上的提示信息，如果tips=nil则隐藏
 *  带小龙图片
 *  @param tips 提示信息
 */
- (void) loadEmptyViewWithTip:(NSString *)tips;

@end
