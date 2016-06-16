//
//  AddAddress.h
//  ElongClient
//  新增邮寄地址页面
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Delivery.h"
#import "ElongBaseViewController.h"


@class eLongEmbedTextField;
@interface AddAddress : ElongBaseViewController <UITextFieldDelegate> {
	eLongEmbedTextField *addressTextField;
	eLongEmbedTextField *nameTextField;
	
}

- (IBAction)textFieldDoneEditing:(id)sender;
@end
