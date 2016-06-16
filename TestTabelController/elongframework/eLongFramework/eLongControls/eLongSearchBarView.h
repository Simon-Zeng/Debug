//
//  SearchBarView.h
//  ElongClient
//
//  Created by Dawn on 14-3-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eLongSearchBarView : UISearchBar{

    UIActivityIndicatorView *indicator;
}

-(void)startLoadingAtRightSide;
-(void)stopLoadingAtRightSide;

@end
