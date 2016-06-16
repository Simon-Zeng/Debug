//
//  FullImageView.m
//  ElongClient
//
//  Created by 赵 海波 on 13-3-29.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "eLongFullTypeImageView.h"
#import "UIImageView+WebCache.h"

#import "eLongDefine.h"
#import "eLongExtension.h"
#import "eLongHotelConfig.h"

#define IMAGE_TYPE                  @"ImageType"
#define IMAGE_PATH                  @"ImagePath"


@implementation eLongFullTypeImageView
@synthesize delegate;

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

}

- (void)hideStatusBarHidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];     // 取消电池烂
}


- (id)initWithFrame:(CGRect)frame Images:(NSArray *)imageURLs AtIndex:(NSInteger)indexNum {
    self = [super initWithFrame:frame];
    if (self) {
        fullScreen = NO;
        index = indexNum;
        
        [self performSelector:@selector(hideStatusBarHidden) withObject:nil afterDelay:.3f];
        
        allImgs = [[NSArray alloc] initWithArray:imageURLs];
        displayArray = allImgs;
        guestRoomImgs = [[NSMutableArray alloc] initWithCapacity:2];
        exteriorImgs = [[NSMutableArray alloc] initWithCapacity:2];
        receptionImgs = [[NSMutableArray alloc] initWithCapacity:2];
        otherImgs = [[NSMutableArray alloc] initWithCapacity:2];
        
        // 根据种类将各种图片归类
        for (NSDictionary *dic in allImgs)
        {
            if ([[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == eLongHotelImageTypeGuestRoom)
            {
                [guestRoomImgs addObject:dic];
            }
            
            if ([[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == eLongHotelImageTypeExterior ||
                [[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == eLongHotelImageTypeBackground)
            {
                [exteriorImgs addObject:dic];
            }
            
            if ([[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == eLongHotelImageTypeRecreation)
            {
                [receptionImgs addObject:dic];
            }
            
            if ([[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == eLongHotelImageTypeRestaurant ||
                [[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == eLongHotelImageTypeRecreation ||
                [[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == eLongHotelImageTypeMeeting ||
                [[dic safeObjectForKey:IMAGE_TYPE] safeIntValue] == eLongHotelImageTypeOther)
            {
                [otherImgs addObject:dic];
            }
        }
        
        if (ARRAYHASVALUE(allImgs)) {
            photoPageView =  [[eLongPhotoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) photoUrls:[self getURLsFromArray:allImgs] progress:YES];
            
            photoPageView.delegate = self;
            photoPageView.alpha = 0;
            [self addSubview:photoPageView];
            if (index > 0) {
                [photoPageView pageToIndex:index];
            }
            
            tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 40)];
            tipsLbl.textAlignment = NSTextAlignmentCenter;
            tipsLbl.font = FONT_B14;
            tipsLbl.textColor = [UIColor whiteColor];
            tipsLbl.backgroundColor = [UIColor clearColor];
            tipsLbl.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)allImgs.count];
            [self addSubview:tipsLbl];
            if (index > 0) {
                tipsLbl.text = [NSString stringWithFormat:@"%ld/%lu",(long)(index + 1),(unsigned long)allImgs.count];
            }
            
            // 下方酒店图片的分类选择器
            titles = [[NSMutableArray alloc] initWithObjects:IMG_TYPE_ALL, nil];
            if (guestRoomImgs.count > 0)
            {
                [titles addObject:IMG_TYPE_GUESTROOM];
            }
            if (exteriorImgs.count > 0)
            {
                [titles addObject:IMG_TYPE_EXTERIOR];
            }
            if (receptionImgs.count > 0)
            {
                [titles addObject:IMG_TYPE_RECEPTION];
            }
            if (otherImgs.count > 0)
            {
                [titles addObject:IMG_TYPE_OTHER];
            }
            
            eLongSegmented *segment = [[eLongSegmented alloc] initWithTitles:titles
                                                                  NormalFont:FONT_B13
                                                            HightLightedFont:FONT_B15
                                                            NormalTitleColor:[UIColor whiteColor]
                                                        HightLightTitleColor:RGBACOLOR(254, 75, 32, 1)
                                                                       Frame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
            segment.selectedIndex = 0;
            segment.delegate = self;
            //            [self addSubview:segment];
            
            titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 40)];
            titleLbl.textAlignment = NSTextAlignmentCenter;
            if (allImgs.count) {
                if ([[allImgs lastObject] isKindOfClass:[NSDictionary class]] || [[allImgs lastObject] isKindOfClass:[NSMutableDictionary class]]) {
                    if ([[[allImgs safeObjectAtIndex:index] safeObjectForKey:@"ImageNameCn"] isKindOfClass:[NSString class]]) {
                        titleLbl.text = [[allImgs safeObjectAtIndex:index] safeObjectForKey:@"ImageNameCn"];
                    }
                }
            }
            
            titleLbl.font = [UIFont boldSystemFontOfSize:18.0f];
            titleLbl.textColor = [UIColor whiteColor];
            titleLbl.backgroundColor = [UIColor clearColor];
            [self addSubview:titleLbl];
        }
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.alpha = 0;
        [cancelBtn setImage:[UIImage noCacheImageNamed:@"photo_close.png"] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 4, 60, 60);
        [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        [self setBackgroundDisAppear:YES];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame Images:(NSArray *)imageURLs AtIndex:(NSInteger)indexNum isShowPageIndex:(BOOL) isShowPageIndex{
    if (self = [self initWithFrame:frame Images:imageURLs AtIndex:indexNum]) {
        if (tipsLbl) {
            tipsLbl.hidden = !isShowPageIndex;
        }
    }
    return self;
}

- (void)setBackgroundDisAppear:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             photoPageView.alpha = 1;
                             cancelBtn.alpha = 1;
                             self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                         }
                         completion:^(BOOL finished) {
                             // todo
                         }];
    }
    else {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}


- (void)cancelButtonClick:(id)sender {
    [photoPageView setGestureDisabled];
    self.userInteractionEnabled = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setBackgroundDisAppear:NO];
    
    if ([delegate respondsToSelector:@selector(fullImageView:didClosedAtIndex:)]) {
        [delegate fullImageView:self didClosedAtIndex:index];
    }
}

- (void)reloadData {
    [photoPageView reloadPhotosWith:[self getURLsFromArray:allImgs]];
}


// 从图片对象中挑选出地址数组
- (NSArray *)getURLsFromArray:(NSArray *)array
{
    NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:0];
    for (NSObject *obj in array)
    {
        if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)obj;
            [urlArray addObject:[dict safeObjectForKey:IMAGE_PATH]];
        }else
        {
            [urlArray addObject:obj];
        }
    }
    
    return urlArray;
}

#pragma mark -
#pragma mark eLongPhotoViewDelegate

- (void)photoView:(eLongPhotoView *)photoView didPageToIndex:(NSInteger)indexNum {
    tipsLbl.text = [NSString stringWithFormat:@"%ld/%lu", (long)(indexNum + 1), (unsigned long)displayArray.count];
    index = indexNum;
    
    if (indexNum >= 0) {
        if (displayArray.count) {
            if ([[displayArray lastObject] isKindOfClass:[NSDictionary class]] ||
                [[displayArray lastObject] isKindOfClass:[NSMutableDictionary class]]) {
                if ([[[displayArray safeObjectAtIndex:indexNum] safeObjectForKey:@"ImageNameCn"] isKindOfClass:[NSString class]]) {
                    titleLbl.text = [[displayArray safeObjectAtIndex:indexNum] safeObjectForKey:@"ImageNameCn"];
                }
            }
        }
    }
}

// 取消单击取消
- (void) photoView:(eLongPhotoView *)photoView didSelectedAtIndex:(NSInteger)index {
    [self cancelButtonClick:nil];
}

#pragma mark - CustomSegmentedDelegate

- (void)segmentedView:(id)segView ClickIndex:(NSInteger)clickIndex
{
    displayArray = nil;
    
    NSString *imgTitle = [titles objectAtIndex:clickIndex];
    if ([imgTitle isEqualToString:IMG_TYPE_ALL])
    {
        // 点击全部
        displayArray = allImgs;
    }
    else if ([imgTitle isEqualToString:IMG_TYPE_GUESTROOM])
    {
        // 点击客房
        displayArray = guestRoomImgs;
    }
    else if ([imgTitle isEqualToString:IMG_TYPE_EXTERIOR])
    {
        // 点击外观
        displayArray = exteriorImgs;
    }
    else if ([imgTitle isEqualToString:IMG_TYPE_RECEPTION])
    {
        // 点击前台
        displayArray = receptionImgs;
    }
    else if ([imgTitle isEqualToString:IMG_TYPE_OTHER])
    {
        // 点击设施
        displayArray = otherImgs;
    }
    
    [photoPageView reloadPhotosWith:[self getURLsFromArray:displayArray]];
    [self photoView:photoPageView didPageToIndex:0];
    
    // 如果没有任何一张图片则显示0/0
    NSInteger pageIndex = allImgs.count > 0 ? 1 : 0;
    tipsLbl.text = [NSString stringWithFormat:@"%ld/%lu", (long)pageIndex, (unsigned long)displayArray.count];
}

@end
