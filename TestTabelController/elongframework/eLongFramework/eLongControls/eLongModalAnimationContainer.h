//
//  ModalAnimationContainer.h
//  ElongClient
//
//  Created by Dawn on 14-1-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "eLongModalAnimation.h"

@interface eLongModalAnimationContainer : NSObject<UIViewControllerTransitioningDelegate>{
@private
    eLongModalAnimation *modalAnimationController;
}
+ (id)shared;
@end
