//
//  eLongNavigationAction.h
//  Pods
//
//  Created by yangfan on 15/6/30.
//
//

#import <Foundation/Foundation.h>
#import "eLongSingletonDefine.h"
#import <UIKit/UIKit.h>

@interface eLongNavigationAction : NSObject<UIActionSheetDelegate>
AS_SINGLETON(eLongNavigationAction)

@property (nonatomic,retain) NSArray *navActions;

@end
