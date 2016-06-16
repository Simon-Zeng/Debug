//
//  eLongHotelUploadImageCell.h
//  ElongClient
//
//  Created by chenggong on 14-3-31.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol eLongHotelUploadImageCellDelegate <NSObject>

- (void)imageNameTextFieldBeginEdit:(NSUInteger)cellTag;
- (void)imageNameTextFieldReturn:(NSString *)name tag:(NSUInteger)cellTag;
- (void)imageTypeButtonClicked:(NSUInteger)cellTag;

@end

@interface eLongHotelUploadImageCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, assign) id<eLongHotelUploadImageCellDelegate> delegate;
@property (nonatomic, strong) UIButton *imageTypeButton;
@property (nonatomic, strong) UITextField *imageName;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end
