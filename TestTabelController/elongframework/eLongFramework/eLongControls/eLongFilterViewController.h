//
//  eLongFilterViewController.h
//  ElongClient
//  过滤条件选择页面(全屏幕)
//
//  Created by yangfan on 2016.1.28.
//  Copyright 2016 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElongBaseViewController.h"

@protocol eLongFilterViewControllerDelegate;

@interface eLongFilterViewController : ElongBaseViewController <UITableViewDataSource, UITableViewDelegate> {
	NSInteger currentRow;
	NSInteger lastRow;
    NSArray *listDatas;
    
    BOOL isShowing;
	BOOL clickBlock;			// 防止重复点击
	
	UITableView *keyTable;
    UIButton *cancelBtn;
    UIButton *doneBtn;
}

@property (nonatomic, assign) id <eLongFilterViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isShowing;			// 是否正在展示
@property (nonatomic, strong) NSArray *listDatas;
@property (nonatomic) NSInteger currentRow;
@property (nonatomic, readonly) UITableView *keyTable;
@property (nonatomic,assign) NSInteger tag;

- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas;		// 用标题和显示数据初始化

- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas  style:(NavBarBtnStyle)style;
- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas extraImages:(NSArray *)images;		// 加入额外的图片初始化

- (void)setCancelBtnHidden:(BOOL)cancelBtnIsHidden
             doneBtnHidden:(BOOL)doneBtnIsHidden;

- (void)showInView;							// 展示
- (void)dismissInView;						// 撤销
- (void)selectRow:(NSInteger)rowNum;		// 选中指定行
- (void)selectByString:(NSString *)string;	// 选中指定的选项
- (void)confirmInView;
- (void)cancelBtnClick;                     //取消按钮
@end


@protocol eLongFilterViewControllerDelegate <NSObject>

@optional
- (void)getFilterString:(NSString *)filterStr inFilterView:(eLongFilterViewController *)filterView;
- (void)selectedIndex:(NSInteger)index inFilterView:(eLongFilterViewController *)filterView;
- (void)willDismissFilterView:(eLongFilterViewController *)filterView;
@end
