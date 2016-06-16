//
//  eLongLogAreaPicker.h
//  ElongClient
//
//  Created by lvyue on 15/1/4.
//  Copyright (c) 2015年 elong. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol eLongLogAreaPickerDelegate <NSObject>

- (void )eLongLogAreaPickerdidFinishChooseAtIndex:(NSInteger  )index;
- (void)eLongLogAreaPickerDidCancel;
@optional
- (void)eLongLogAreaPickerdidDismiss;
@end

@interface eLongLogAreaPicker : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView  *areaTableView;
    NSInteger  nComponen;
    NSString  *allTitle;
    UIView  *containView;
    UIView  *topView ;
    UIView *shadowView;
}
- (id)initWithFrame:(CGRect)frame  withDelegate:(id<eLongLogAreaPickerDelegate>)delegate   withTitle:(NSString  *)titile  withRowTitleAr:(NSArray  *)ar;
- (void)apearInView:(UIView  *)inView;
- (void)dissmiss;
@property  (nonatomic,weak)  id<eLongLogAreaPickerDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *selectIndexPath;
@property (nonatomic,strong) NSArray *dataArray;

@end