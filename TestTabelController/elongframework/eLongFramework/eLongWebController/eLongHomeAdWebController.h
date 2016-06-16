//
//  eLongHomeAdWebController.h
//  eLongFramework
//
//  Created by 张馨允 on 16/2/29.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "eLongRoundCornerView.h"

@interface eLongHomeAdWebController : ElongBaseViewController<UIWebViewDelegate>

@property (nonatomic,assign) BOOL isNavBarShow;

@property (nonatomic,assign) BOOL active;

- (id)initWithTitle:(NSString *)title targetUrl:(NSString *)url style:(NavBarBtnStyle)navStyle;

- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style params:(NSDictionary *)params;

//去掉导航栏后，调整webViewFrame
- (void)resetWebViewFrame;

@end
 