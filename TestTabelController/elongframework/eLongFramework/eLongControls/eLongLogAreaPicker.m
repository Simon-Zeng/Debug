//
//  eLongLogAreaPicker.m
//  ElongClient
//
//  Created by lvyue on 15/1/4.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongLogAreaPicker.h"
#import "eLongAreaPhoneModel.h"
#import "eLongExtension.h"
#import "eLongDefine.h"
#import "eLongFileIOUtils.h"


@implementation eLongLogAreaPicker{


}

#pragma mark - InPut

-(void)setSelectIndexPath:(NSIndexPath *)selectIndexPath_{
    if (selectIndexPath_ != _selectIndexPath) {
        _selectIndexPath = selectIndexPath_;
        [areaTableView reloadData];
        [self finishActionAtIndex:_selectIndexPath.row];
    }
}

-(void)setDataArray:(NSArray *)dataArray_{
    if (_dataArray != dataArray_) {
        _dataArray = dataArray_;
        [areaTableView reloadData];
    }
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame  withDelegate:(id<eLongLogAreaPickerDelegate>)delegate   withTitle:(NSString  *)titile  withRowTitleAr:(NSArray  *)ar
{
    if (self = [super initWithFrame:frame])
    {
        self.delegate = delegate;

        allTitle = [[NSString  alloc]initWithFormat:@"%@",titile];
        self.backgroundColor = [UIColor  whiteColor];
        _dataArray = [[NSArray  alloc]initWithArray:ar];
        [self makeTopView:frame];
        areaTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, topView.size.height, frame.size.width,frame.size.height - topView.size.height )];
        areaTableView.backgroundColor = [UIColor whiteColor];
        areaTableView.delegate = self;
        areaTableView.dataSource = self;
        areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self  addSubview:areaTableView];
    }
    return self;
}

#pragma mark - LoadUI

- (void)makeTopView:(CGRect )frame
{
    topView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, HSC_CELL_HEGHT)];
    topView.backgroundColor = [UIColor clearColor];
    
    UIButton  *leftButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    [leftButton  setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton  setTitleColor:COLOR_BTN_TITLE forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, HSC_CELL_HEGHT, topView.frame.size.height);
    [leftButton  addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [topView  addSubview:leftButton];
    
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(leftButton.frame.size.width + leftButton.frame.origin.x, leftButton.frame.origin.y, self.frame.size.width - 2 * leftButton.frame.size.width, topView.frame.size.height)];
    titleLB.font = FONT_18;
    titleLB.text = allTitle;
    titleLB.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLB];
    [self  addSubview:topView];

}

-(void)loadShadowViewInView:(UIView *)inView{
    
    if (!shadowView || !shadowView.superview) {
        shadowView = [[UIView alloc]initWithFrame:inView.bounds];
        [inView insertSubview:shadowView belowSubview:self];
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shadowTap:)];
        [shadowView addGestureRecognizer:tapGesture];
        shadowView.backgroundColor = [UIColor blackColor];
        [shadowView setAlpha:0.4f];
    }
    [inView bringSubviewToFront:shadowView];
    [inView bringSubviewToFront:self];
}

#pragma mark - Action

- (void)dissmiss
{
    if (self.delegate && [self.delegate  respondsToSelector:@selector(eLongLogAreaPickerdidDismiss)]) {
        [self.delegate  eLongLogAreaPickerdidDismiss];
    }
    [UIView  animateWithDuration:0.35  animations:^{
        self.frame = CGRectMake(self.frame.origin.x,containView.frame.size.height, self.frame.size.width, self.frame.size.height);
        [shadowView setAlpha:0.0f];
    }];
}

- (void)cancelAction
{
    
    if (containView) {
        [self  dissmiss];
    }

    if (self.delegate && [self.delegate  respondsToSelector:@selector(eLongLogAreaPickerDidCancel)]) {
        [self.delegate  eLongLogAreaPickerDidCancel];
    }
    
}

- (void)finishActionAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate  respondsToSelector:@selector(eLongLogAreaPickerdidFinishChooseAtIndex:)]) {
        [self.delegate  eLongLogAreaPickerdidFinishChooseAtIndex:index];
    }
    if (containView) {
        [self  dissmiss];
    }
}

-(void)shadowTap:(id)sender{
    [self dissmiss];
}

- (void)apearInView:(UIView  *)inView
{

    [self loadShadowViewInView:inView];
    containView  = inView;
    self.frame = CGRectMake(self.frame.origin.x,containView.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView  animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, inView.frame.size.height - self.frame.size .height, self.frame.size.width, self.frame.size.height);
        [shadowView setAlpha:0.4f];

    }];
}

#pragma mark - ---tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HSC_CELL_HEGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray safeCount];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_selectIndexPath.row != indexPath.row) {
//        UITableViewCell *beforeView = [tableView cellForRowAtIndexPath:_selectIndexPath];
//        UITableViewCell *afterView = [tableView cellForRowAtIndexPath:indexPath];
//        beforeView.accessoryType = UITableViewCellAccessoryNone;
//        afterView.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectIndexPath = indexPath;
        [tableView reloadData];
    }
    [self dissmiss];
    if (_delegate && [_delegate respondsToSelector:@selector(eLongLogAreaPickerdidFinishChooseAtIndex:)]) {
        [_delegate eLongLogAreaPickerdidFinishChooseAtIndex:indexPath.row];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", (int
)[indexPath section], (int)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    UIColor *textColor = COLOR_CELL_LABEL;
//    if (IOSVersion_7) {
        cell.tintColor = COLOR_BTN_TITLE;
//    }
    if (_selectIndexPath.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

        textColor = COLOR_BTN_TITLE;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0) {
        UIImageView *lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"basevc_dashed.png"]];
        lineView.frame = CGRectMake(0, 0, tableView.frame.size.width, SCREEN_SCALE);
        [cell.contentView addSubview:lineView];
    }
    UIImageView *lineView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"basevc_dashed.png"]];
    lineView2.frame = CGRectMake(0, HSC_CELL_HEGHT - SCREEN_SCALE, tableView.frame.size.width, SCREEN_SCALE);
    [cell.contentView addSubview:lineView2];
    
    
    eLongAreaPhoneModel *model = [_dataArray safeObjectAtIndex:indexPath.row];
    NSMutableString *mStr = (NSMutableString *)model.acDsc;
//    CGFloat padding = 20;
//    UILabel *countryLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2 - padding/2, cell.contentView.frame.size.height)];
//    countryLB.textAlignment = NSTextAlignmentRight;
//    UILabel *areaLB = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 2+ padding / 2, 0, self.frame.size.width/2 - padding/2, cell.contentView.frame.size.height)];
//    areaLB.textAlignment = NSTextAlignmentLeft;
//    areaLB.textColor = textColor;
   
    UILabel *countryLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, cell.contentView.frame.size.height)];
     countryLB.textColor = textColor;
    countryLB.textAlignment = NSTextAlignmentCenter;
    countryLB.text = mStr;

    [cell.contentView addSubview:countryLB];
  //  [cell.contentView addSubview:areaLB];
    
//    NSRange range0 = [mStr rangeOfString:@"("];
//    NSRange range1 = [mStr rangeOfString:@")"];
//    
//    if (range0.location != NSNotFound && range1.location != NSNotFound)//包含
//    {
//        
//        if (range1.location > range0.location) {
//            NSString *countryStr = [mStr substringWithRange:NSMakeRange(0, range0.location)];
//            NSString *areaStr = [mStr substringWithRange:NSMakeRange(range0.location , [mStr length] - range0.location - 2)];
//            countryLB.text  = countryStr;
//          areaLB.text = areaStr;
//        }
//    }
    

    
    return cell;
}

#pragma mark - Life
- (void)dealloc{
    areaTableView.delegate = nil;
}


@end
