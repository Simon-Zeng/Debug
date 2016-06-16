//
//  eLongFilterViewController.m
//  ElongClient
//
//  Created by yangfan on 2016.1.28.
//  Copyright 2016 elong. All rights reserved.
//

#import "eLongFilterViewController.h"
#import "eLongDefine.h"
#import "eLongCommonCell.h"
#import "eLongFileIOUtils.h"

#define kImageViewTag		9010

@interface eLongFilterViewController ()

@property (nonatomic, strong) NSArray *exImageDatas;
@property (nonatomic, strong) UIView *markView;
@end


static int cell_Height	= 44;
static int max_Number	= 7;

@implementation eLongFilterViewController

@synthesize listDatas;
@synthesize exImageDatas;
@synthesize delegate;
@synthesize isShowing;
@synthesize currentRow;
@synthesize keyTable;


- (void)dealloc {
    self.delegate = nil;
    self.listDatas = nil;
    self.exImageDatas = nil;
    self.markView = nil;
    
    keyTable.delegate=nil;
}


- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas {
    if (self = [super init]) {
        self.listDatas	= datas;
        currentRow		= 0;
        lastRow			= currentRow;
        isShowing		= NO;
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        
        // top bar
        UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        topBar.backgroundColor =  RGBACOLOR(248, 248, 248, 1);
        [self.view addSubview:topBar];
        
        UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        topSplitView.image = [UIImage imageNamed:@"basevc_dashed.png"];
        [topBar addSubview:topSplitView];
        
        // title label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:FONT_15];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:RGBACOLOR(52, 52, 52, 1)];
        [titleLabel setText:title];
        [topBar addSubview:titleLabel];
        
        //clean button
        cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-70, 0, 70, NAVIGATION_BAR_HEIGHT)];
        [cancelBtn.titleLabel setFont:FONT_14];
        [cancelBtn setTitle:@"清除选项" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexStr:@"#ff5555"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:COLOR_BTN_TITLE_H forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:cancelBtn];
        
        doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        doneBtn.backgroundColor = [UIColor whiteColor];
        [doneBtn.titleLabel setFont:FONT_B18];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithHexStr:@"#ff5555"] forState:UIControlStateNormal];
        [doneBtn setTitleColor:COLOR_BTN_TITLE_H forState:UIControlStateHighlighted];
        [doneBtn addTarget:self action:@selector(confirmInView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doneBtn];
        
        [self setBtnHidden];
        
        if ([self isInitTableView])
        {
            // data table
            NSInteger height = 0;
            if ([datas count] > max_Number) {
                height = 300 * COEFFICIENT_Y;
            }
            else {
                if ([datas count] <= 2) {
                    height = cell_Height * 3;
                }else{
                    height = cell_Height * [datas count];
                }
            }
            
            keyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, height + 30) style:UITableViewStylePlain];
            keyTable.delegate = self;
            keyTable.dataSource = self;
            keyTable.backgroundColor = RGBACOLOR(248, 248, 248, 1);
            keyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:keyTable];
        }
    }
    
    return self;
}


- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas  style:(NavBarBtnStyle)style{
    if (self = [super initWithTitle:title style:style]) {
        self.listDatas	= datas;
        currentRow		= 0;
        lastRow			= currentRow;
        isShowing		= NO;
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        
        //        // top bar
        //        UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        //        topBar.backgroundColor =  RGBACOLOR(248, 248, 248, 1);
        //        [self.view addSubview:topBar];
        //
        //        UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        //        topSplitView.image = [UIImage imageNamed:@"basevc_dashed.png"];
        //        [topBar addSubview:topSplitView];
        //
        //        // title label
        //        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        //        [titleLabel setBackgroundColor:[UIColor clearColor]];
        //        [titleLabel setFont:FONT_15];
        //        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        //        [titleLabel setTextColor:RGBACOLOR(52, 52, 52, 1)];
        //        [titleLabel setText:title];
        //        [topBar addSubview:titleLabel];
        //
        //        //clean button
        //        cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-70, 0, 70, NAVIGATION_BAR_HEIGHT)];
        //        [cancelBtn.titleLabel setFont:FONT_14];
        //        [cancelBtn setTitle:@"清除选项" forState:UIControlStateNormal];
        //        [cancelBtn setTitleColor:[UIColor colorWithHexStr:@"#ff5555"] forState:UIControlStateNormal];
        //        [cancelBtn setTitleColor:COLOR_BTN_TITLE_H forState:UIControlStateHighlighted];
        //        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //        [topBar addSubview:cancelBtn];
        
        doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        doneBtn.backgroundColor = [UIColor whiteColor];
        [doneBtn.titleLabel setFont:FONT_B18];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithHexStr:@"#ff5555"] forState:UIControlStateNormal];
        [doneBtn setTitleColor:COLOR_BTN_TITLE_H forState:UIControlStateHighlighted];
        [doneBtn addTarget:self action:@selector(confirmInView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doneBtn];
        
        [self setBtnHidden];
        
        if ([self isInitTableView])
        {
            // data table
            NSInteger height = 0;
            if ([datas count] > max_Number) {
                height = 300 * COEFFICIENT_Y;
            }
            else {
                if ([datas count] <= 2) {
                    height = cell_Height * 3;
                }else{
                    height = cell_Height * [datas count];
                }
            }
            
            keyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, height + 30) style:UITableViewStylePlain];
            keyTable.delegate = self;
            keyTable.dataSource = self;
            keyTable.backgroundColor = RGBACOLOR(248, 248, 248, 1);
            keyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:keyTable];
        }
    }
    return self;
}

- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas extraImages:(NSArray *)images {
    if (self = [self initWithTitle:title Datas:datas]) {
        self.exImageDatas = images;
    }
    
    return self;
}

//是否初始化tableview，子类可以重写
-(BOOL) isInitTableView
{
    return YES;
}

//设置btn显示，子类实现
-(void) setBtnHidden
{
    cancelBtn.hidden=NO;
    doneBtn.hidden=NO;
}

- (void)setCancelBtnHidden:(BOOL)cancelBtnIsHidden
             doneBtnHidden:(BOOL)doneBtnIsHidden
{
    cancelBtn.hidden = cancelBtnIsHidden;
    doneBtn.hidden = doneBtnIsHidden;
}


#pragma mark -
#pragma mark Public Methods
- (void) singleTapGesture:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willDismissFilterView:)]) {
        [self.delegate willDismissFilterView:self];
    }
    [self dismissInView];
    
    [self singleTapGestureDoOtherSth];
}

//手势取消时的其他事
-(void) singleTapGestureDoOtherSth
{
    
}

- (void)showInView {
    if (!isShowing) {
        clickBlock = NO;
        isShowing = YES;
        
        //		if ([listDatas count] < max_Number) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.markView.backgroundColor = RGBACOLOR(0, 0, 0, 1.0f);
        [window addSubview:self.markView];
        self.markView.alpha = 0.0f;
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.numberOfTouchesRequired = 1;
        [self.markView addGestureRecognizer:singleTapGesture];
        
        if (self.view.superview) {
            [self.view removeFromSuperview];
            [window addSubview:self.view];
        }else{
            [window addSubview:self.view];
        }
        
        CGRect rect		 = self.view.frame;
        rect.size.height = (NAVIGATION_BAR_HEIGHT * (doneBtn.hidden ? 1 : 2)) + keyTable.frame.size.height+[self getAddHeight];
        self.view.frame  = rect;
        
        [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
        
        [doneBtn setFrame:CGRectMake(0, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        
        UIImageView *imageViewLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,  doneBtn.frame.origin.y, SCREEN_WIDTH, SCREEN_SCALE)];
        imageViewLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        imageViewLine.backgroundColor = RGBACOLOR(255, 0, 0, 0.6);
        [self.view addSubview:imageViewLine];
        imageViewLine.hidden = doneBtn.hidden;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		//UIViewAnimationCurveEaseOut:  slow at end
        [UIView setAnimationDuration:SHOW_WINDOWS_DEFAULT_DURATION];
        [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        self.markView.alpha = 0.8f;
        [UIView commitAnimations];
    }
    
    [keyTable reloadData];
}

//增加的高度，子类可以实现
-(float) getAddHeight
{
    return 0;
}

//取消按钮
-(void)cancelBtnClick
{
    //[self dismissInView];
}


- (void)dismissInView {
    if (isShowing) {
        isShowing = NO;
        [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        
        [UIView animateWithDuration:SHOW_WINDOWS_DEFAULT_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
            self.markView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.markView removeFromSuperview];
            self.markView = nil;
            [self.view removeFromSuperview];
        }];
    }
}

- (void) confirmInView
{
    [self dismissInView];
}


- (void)selectRow:(NSInteger)rowNum {
    lastRow = currentRow = rowNum;
    [keyTable reloadData];
}


- (void)selectByString:(NSString *)string {
    NSInteger selectRow = [listDatas indexOfObject:string];
    if (selectRow != NSNotFound) {
        lastRow = currentRow = selectRow;
        [keyTable reloadData];
    }
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listDatas count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cell_Height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
    eLongCommonCell *cell = (eLongCommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (cell == nil) {
        cell = [[eLongCommonCell alloc] initWithIdentifier:SelectTableCellKey height:cell_Height style:CommonCellStyleChoose];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        cell.contentView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        
        UIImageView *exImageView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 13, 18, 18)];
        exImageView.tag = kImageViewTag;
        exImageView.contentMode = UIViewContentModeScaleAspectFit;
        exImageView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:exImageView];
    }
    
    UIImageView *exImageView = (UIImageView *)[cell.contentView viewWithTag:kImageViewTag];
    UIImage *cellImage = [exImageDatas safeObjectAtIndex:indexPath.row];
    if (![cellImage isEqual:[NSNull null]]) {
        exImageView.image = cellImage;
        if (cellImage != nil) {
            CGRect textLabelRect = cell.textLabel.frame;
            textLabelRect.origin.x = 65;
            cell.textLabel.frame = textLabelRect;
        }
    }
    
    NSString *cellTitle = [listDatas safeObjectAtIndex:indexPath.row];
    if (![cellTitle isEqual:[NSNull null]]) {
        cell.textLabel.text = cellTitle;
    }
    
    if (indexPath.row == currentRow) {
        cell.cellImage.highlighted = YES;
    }
    else {
        cell.cellImage.highlighted = NO;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 勾选选中项
    if (clickBlock == NO) {
        if (currentRow != indexPath.row) {
            currentRow = indexPath.row;
            
            eLongCommonCell *lastCell = (eLongCommonCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]];
            lastCell.cellImage.highlighted = NO;
            
            eLongCommonCell *cell = (eLongCommonCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.cellImage.highlighted = YES;
            
            lastRow = currentRow;
        }
        
        // 退出当前页
        clickBlock = YES;
        [self performSelector:@selector(chooseString:) withObject:[listDatas safeObjectAtIndex:currentRow] afterDelay:0.18];
    }
}

- (void) setCurrentRow:(NSInteger)cRow{
    // 勾选选中项
    if (clickBlock == NO) {
        if (currentRow != cRow) {
            currentRow = cRow;
            
            eLongCommonCell *lastCell = (eLongCommonCell *)[keyTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]];
            lastCell.cellImage.highlighted = NO;
            
            eLongCommonCell *cell = (eLongCommonCell *)[keyTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cRow inSection:0]];
            cell.cellImage.highlighted = YES;
            
            lastRow = currentRow;
        }
        
        // 退出当前页
        clickBlock = YES;
    }
}


- (void)chooseString:(NSString *)string {
    if ([delegate respondsToSelector:@selector(getFilterString: inFilterView:)]) {
        [delegate getFilterString:string inFilterView:self];
    }
    
    if ([delegate respondsToSelector:@selector(selectedIndex: inFilterView:)]) {
        [delegate selectedIndex:currentRow inFilterView:self];
    }
    
    [self dismissInView];
}

@end
