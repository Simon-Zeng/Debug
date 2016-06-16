//
//  eLongHotelUploadImageCell.m
//  ElongClient
//
//  Created by chenggong on 14-3-31.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongHotelUploadImageCell.h"
#import <QuartzCore/QuartzCore.h>
#import "eLongDefine.h"
#import "eLongExtension.h"

@interface eLongHotelUploadImageCell()

@property (nonatomic, copy) NSString *uploadImageName;

@end

@implementation eLongHotelUploadImageCell

- (void)dealloc
{
    self.imageTypeButton = nil;
    self.imageName = nil;
    self.statusLabel = nil;
    self.loadingView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage noCacheImageNamed:@"ico_uploaddownarrow.png"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 170.0f, 0.0f, 10.0f);
//        button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, -30.0f, 0.0f, 0.0f);
        CALayer *buttonLayer = [button layer];
        buttonLayer.borderColor = RGBACOLOR(102, 102, 102, 1).CGColor;
        buttonLayer.borderWidth = 0.51f;
        
        CGFloat buttonW = 175.0f;
        CGFloat buttonH = 28.0f;
        CGFloat buttonX = SCREEN_WIDTH - buttonW - 45;
        CGFloat buttonY = 25.0f;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        button.titleLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        [button setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        button.titleEdgeInsets = UIEdgeInsetsMake(5.0f, 0.0f, 5.0f, 40.0f);
        [self.contentView addSubview:button];
        self.imageTypeButton = button;
        
        CGFloat imageNameTextFieldW = 175.0f;
        CGFloat imageNameTextFieldH = 28.0f;
        CGFloat imageNameTextFieldX = SCREEN_WIDTH - buttonW - 70;
        CGFloat imageNameTextFieldY = 36.0f;
        UITextField *imageNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(imageNameTextFieldX, imageNameTextFieldY, imageNameTextFieldW, imageNameTextFieldH)];
        self.imageName = imageNameTextField;
        CALayer *imageNameTextFieldLayer = [imageNameTextField layer];
        imageNameTextFieldLayer.borderColor = RGBACOLOR(52, 52, 52, 1).CGColor;
        imageNameTextFieldLayer.borderWidth = 1.0f;
        imageNameTextField.delegate = self;
        imageNameTextField.font = [UIFont systemFontOfSize:14.0f];
        [imageNameTextField setBorderStyle:UITextBorderStyleLine];
        imageNameTextField.placeholder = @"图片名称";
        [self.contentView addSubview:imageNameTextField];
        
        CGFloat labelW = 150.f;
        CGFloat labelH = 18.0f;
        CGFloat labelX = SCREEN_WIDTH - labelW - 58;
        CGFloat labelY = 65.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        self.statusLabel = label;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = RGBACOLOR(52, 52, 52, 1);
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
        [self.contentView addSubview:label];
        
        CGFloat tempLoadingViewW = 18.0f;
        CGFloat tempLoadingViewH = 18.0f;
        CGFloat tempLoadingViewX = labelX + 10;
        CGFloat tempLoadingViewY = 65.0f;
        UIActivityIndicatorView *tempLoadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(tempLoadingViewX, tempLoadingViewY, tempLoadingViewW, tempLoadingViewH)];
        tempLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.loadingView = tempLoadingView;
        [self.contentView addSubview:tempLoadingView];
        tempLoadingView.backgroundColor = [UIColor clearColor];
        tempLoadingView.hidden = YES;
    }
    return self;
}

#pragma mark - buttonClicked
- (void)buttonClicked:(id)sender
{
    [self.imageName resignFirstResponder];
    [self.imageTypeButton becomeFirstResponder];
    
    if (_delegate && [_delegate respondsToSelector:@selector(imageTypeButtonClicked:)]) {
        [_delegate imageTypeButtonClicked:self.tag];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    // Makes imageView get placed in the corner
    self.imageView.frame = CGRectMake( 0, 0, 88, 88 );
}

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger textLength = [textField.text length];
    if (range.location == textLength) {
        self.uploadImageName = [NSString stringWithFormat:@"%@%@", textField.text, string];
    }
    else if (STRINGHASVALUE(string)){
        self.uploadImageName = string;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(imageNameTextFieldReturn:tag:)]) {
        [_delegate imageNameTextFieldReturn:_uploadImageName tag:self.tag];
    }
    
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
    
    if (_delegate && [_delegate respondsToSelector:@selector(imageNameTextFieldReturn:tag:)]) {
        [_delegate imageNameTextFieldReturn:_uploadImageName tag:self.tag];
    }
    
	return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(imageNameTextFieldBeginEdit:)]) {
        [_delegate imageNameTextFieldBeginEdit:self.tag];
    }
    return YES;
}

@end
