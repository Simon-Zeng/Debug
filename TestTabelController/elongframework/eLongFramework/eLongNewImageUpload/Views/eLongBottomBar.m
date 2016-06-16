//
//  eLongBottomToolBar.m
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/27.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import "eLongBottomBar.h"

#import "eLongAssetModel.h"
#import "eLongPhotoManager.h"

#import "UIView+Animations.h"

#import "eLongExtension.h"
#import "eLongDefine.h"
#import "eLongDefine.h"

@interface eLongBottomBar ()

@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIView *originView;
@property (weak, nonatomic) IBOutlet UIImageView *originStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *originSizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIImageView *numberImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) UIButton *cancelButton;


@property (nonatomic, assign) BOOL selectOriginEnable;


@end

@implementation eLongBottomBar
@synthesize barType = _barType;
@synthesize selectOriginEnable = _selectOriginEnable;
@synthesize totalSize = _totalSize;

#pragma mark - Life Cycle

//- (void) awakeFromNib{
//
//
//}

- (instancetype)initWithBarType:(eLongBottomBarType)barType {
    eLongBottomBar *bottomBar = [[[NSBundle mainBundle] loadNibNamed:@"eLongBottomBar" owner:nil options:nil] firstObject];
    [bottomBar.numberLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_bar_number_background"]]];
    bottomBar.numberImageView.hidden = YES;
    bottomBar ? [bottomBar _setupWithType:barType] : nil;
    return bottomBar;
}


#pragma mark - Methods

- (void)updateBottomBarWithAssets:(NSArray *)assets {
    
    _totalSize = .0f;
    
    if (!assets || assets.count == 0) {
        self.originStateImageView.highlighted = NO;
        self.originSizeLabel.textColor = [UIColor lightGrayColor];
        self.originSizeLabel.text = @"原图";
    }else {
        self.originStateImageView.highlighted = self.selectOriginEnable;
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)assets.count];
    
    self.numberImageView.hidden = self.numberLabel.hidden = assets.count <= 0;
    if (_barType == eLongPreviewBottomSend) {
        self.confirmButton.enabled = YES;
    }else{
        self.confirmButton.enabled = assets.count >= 1;
    }
    self.previewButton.enabled = assets.count >= 1;
    self.originView.userInteractionEnabled = assets.count >= 1;
    
    [UIView animationWithLayer:self.numberLabel.layer type:eLongAnimationTypeSmaller];
    //
    //    __weak typeof(*&self) wSelf = self;
    //    [assets enumerateObjectsUsingBlock:^(eLongAssetModel  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        [[eLongPhotoManager sharedManager] getAssetSizeWithAsset:obj.asset completionBlock:^(CGFloat size) {
    //            __weak typeof(*&self) self = wSelf;
    //            _totalSize += size;
    //            if (idx == assets.count - 1) {
    //                [self _updateSizeLabel];
    //                *stop = YES;
    //            }
    //        }];
    //    }];
    
    _numberImageView.hidden = YES;
    
}

- (void)_setupWithType:(eLongBottomBarType)barType {
    _barType = barType;
    _selectOriginEnable = YES;
    
    if (barType == eLongPreviewBottomSend) {
        self.lineView.hidden = YES;
        self.backgroundColor = [UIColor colorWithRed:34/255.0f green:34/255.0f blue:34/255.0f alpha:.7f];
    }else{
        self.lineView.hidden = barType == eLongPreviewBottomBar;
        self.backgroundColor = barType == eLongPreviewBottomBar ? [UIColor colorWithRed:34/255.0f green:34/255.0f blue:34/255.0f alpha:.7f] : [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0 alpha:1.0f];
    }
    
    self.lineView.backgroundColor = [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.f];
    
    //config previewButton
    self.previewButton.hidden = barType == eLongPreviewBottomBar;
    self.previewButton.hidden = YES;
    self.previewButton.enabled = NO;
    [self.previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [self.previewButton setTitle:@"预览" forState:UIControlStateDisabled];
    [self.previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    //config originView
    self.originView.hidden = YES;
    self.originView.userInteractionEnabled = NO;
    self.originView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *originViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleOriginViewTap)];
    [self.originView addGestureRecognizer:originViewTap];
    
    self.originStateImageView.highlighted = NO;
    [self.originStateImageView setImage:[UIImage imageNamed:@"bottom_bar_origin_normal"]];
    [self.originStateImageView setHighlightedImage:[UIImage imageNamed:@"bottom_bar_origin_selected"]];
    
    self.originSizeLabel.text = @"原图";
    self.originSizeLabel.textColor = [UIColor lightGrayColor];
    
    //config number
    self.numberImageView.hidden = self.numberLabel.hidden = YES;
    self.numberImageView.image = [UIImage imageNamed:@"bottom_bar_number_background"];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberImageView.contentMode = UIViewContentModeCenter;
    
    //config confirmButton
    self.confirmButton.enabled = NO;
    
    if (barType == eLongPreviewBottomSend) {
        
        self.confirmButton.translatesAutoresizingMaskIntoConstraints = YES;
        
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = YES;
        self.numberImageView.translatesAutoresizingMaskIntoConstraints = YES;
        
        
        [self.confirmButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.confirmButton setTitle:@"发送" forState:UIControlStateDisabled];
        self.confirmButton.titleLabel.font = FONT_18;
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self.confirmButton addTarget:self action:@selector(_handleSendAction) forControlEvents:UIControlEventTouchUpInside];
        [self.confirmButton setBackgroundColor:[UIColor colorWithHexStr:@"4499ff"]];
        self.confirmButton.frame =  CGRectMake(SCREEN_WIDTH - 120, 0, 120, self.frame.size.height);
        
        [self loadCancelBtn];
    }else{
        self.confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmButton setTitle:@"确定" forState:UIControlStateDisabled];
        [self.confirmButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0f] forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:.5f] forState:UIControlStateDisabled];
        [self.confirmButton addTarget:self action:@selector(_handleConfirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self removeCancelBtn];
    }
    
}

- (void) loadCancelBtn{
    if (!_cancelButton && !_cancelButton.superview) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 76, self.frame.size.height);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = FONT_18;
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_cancelButton setBackgroundColor: [UIColor clearColor]];
        [_cancelButton addTarget:self action:@selector(_handleCancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }else{
        _cancelButton.frame = CGRectMake(0, 0, 76, self.frame.size.height);
    }
}

- (void)removeAutoLayout:(NSLayoutConstraint *)constraint{
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (constraint.secondItem == self.confirmButton) {
            [self.superview removeConstraint:constraint];
        }
    }
}

- (void) removeCancelBtn{
    if (_cancelButton && _cancelButton.superview) {
        [_cancelButton removeFromSuperview];
        _cancelButton = nil;
    }
}

- (void)_handleConfirmAction {
    self.confirmBlock ? self.confirmBlock() : nil;
}

- (void)_handleSendAction {
    self.sendBlock ? self.sendBlock() : nil;
}

- (void)_handleCancelAction {
    self.cancelBlock ? self.cancelBlock() : nil;
}

- (void)_handleOriginViewTap {
    self.selectOriginEnable = !self.selectOriginEnable;
    self.originStateImageView.highlighted = self.selectOriginEnable;
    [self _updateSizeLabel];
}

- (void)_updateSizeLabel {
    if (self.selectOriginEnable) {
        self.originSizeLabel.text = [NSString stringWithFormat:@"原图 (%@)",[self _bytesStringFromDataLength:self.totalSize]];
        self.originSizeLabel.textColor = self.barType == eLongCollectionBottomBar ? [UIColor blackColor] : [UIColor whiteColor];
    }else {
        self.originSizeLabel.text = @"原图";
        self.originSizeLabel.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - Getters

- (NSString *)_bytesStringFromDataLength:(CGFloat)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else if (dataLength == .0f){
        bytes = @"";
    }else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}


@end
