//
//  eLongLineCell.h
//  ElongClient
//
//  Created by nieyun on 14-2-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eLongLineCell : UITableViewCell
{
    UIImageView  *topLineView;
    UIImageView  *bottomLineView;
}
@property  (nonatomic,assign)  BOOL notop;
@property  (nonatomic,assign)  BOOL  nobottom;

@end
