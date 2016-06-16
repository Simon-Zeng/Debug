//
//  eLongTabScrollBarView.m
//  MyElong
//
//  Created by yangfan on 15/12/29.
//  Copyright © 2015年 lvyue. All rights reserved.
//

#import "eLongTabScrollBarView.h"
#import "eLongDefine.h"
#import "UIView+LY.h"
#import "UIImageView+Extension.h"
#import "UIImage+eLongExtension.h"
#import "eLongTabScrollItemView.h"

#define kTabItemWidth 90
#define kScrollLeftMargin 10
#define kItemBetweenSpace 4

#define ADDITION_TAG		333			// 防止tag＝0时与其它控件混淆
//#define BG_IMAGE_TAG        555         // 有滑动效果的背景图

@interface eLongTabScrollBarView ()
<eLongTabScrollItemViewDelegate>

@property (nonatomic,strong) NSMutableArray *segItems;

@end

@implementation eLongTabScrollBarView
@synthesize selectedIndex;
@synthesize delegate;

- (void)dealloc
{
    segAr = nil;
}

- (id)initWithTitles:(NSArray *)titleArray
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)]) {
        if (!ARRAYHASVALUE(titleArray)) {
            return self;
        }
        
        self.segItems = [NSMutableArray new];
        segAr = [[NSMutableArray  alloc]init];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(kScrollLeftMargin, 0, SCREEN_WIDTH - 2*kScrollLeftMargin, self.height)];
        self.scroll.delegate = self;
        self.scroll.contentSize = CGSizeMake((kItemBetweenSpace * (titleArray.count + 1) + kTabItemWidth * titleArray.count), self.height);
        [self addSubview:self.scroll];
        
        int offX = 0;			// 每个item的x坐标
//        float unitWidth = (SCREEN_WIDTH )/ [titleArray count];
        for (NSString *title in titleArray) {
            NSUInteger index = [titleArray indexOfObject:title];
            
            eLongTabScrollItemView *segItem			= [[eLongTabScrollItemView alloc] initWithFrame:CGRectMake(index * kTabItemWidth + index * kItemBetweenSpace, 0, kTabItemWidth, self.size.height)];
            segItem.titleLabel.text			= title;
            segItem.tag						= index + ADDITION_TAG;
            segItem.delegate				= self;
            
            [self.scroll addSubview:segItem];
            [self.segItems addObject:segItem];
            [segAr  addObject:segItem];
            
            offX += kTabItemWidth;
        }
        
        lastSelectedIndex = -1;
        adjustTitleHeight = NO;
        UIView *topLineView = [UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        [self addSubview:topLineView];
        UIView *bottomLineView = [UIImageView graySeparatorWithFrame:CGRectMake(0, self.height - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        [self addSubview:bottomLineView];
    }
    
    return self;
}

- (void)didSelect:(NSInteger)index{
    for (eLongTabScrollItemView *item in self.segItems) {
        NSInteger tempIndex = [self.segItems indexOfObject:item];
        [item changeState:(tempIndex == index)];
    }
}

- (void)setSelectedIndex:(NSInteger)index {
    selectedIndex = index;
    eLongTabScrollItemView *nowItem = (eLongTabScrollItemView *)[self viewWithTag:index+ ADDITION_TAG];
    [nowItem changeState:YES];
    if (adjustTitleHeight) {
        nowItem.titleLabel.frame = nowItem.bounds;
        [self bringSubviewToFront:nowItem];
    }
    
    [delegate TabScrollBar:self ClickIndex:index];
    
    // 处理分隔线
    UIImageView *lastSeparator = (UIImageView *)[self viewWithTag:kSeparatorTag + lastSelectedIndex + 1];
    lastSeparator.hidden = NO;
    
    UIImageView *separator = (UIImageView *)[self viewWithTag:kSeparatorTag + index + 1];
    separator.hidden = YES;
    
    // 切换上一次选中的按钮状态
    eLongTabScrollItemView *lastItem = (eLongTabScrollItemView *)[self viewWithTag:lastSelectedIndex + ADDITION_TAG];
    if (lastItem) {
        [lastItem changeState:NO];
    }
    if (adjustTitleHeight) {
        lastItem.titleLabel.frame = CGRectMake(0, 3, lastItem.frame.size.width, lastItem.frame.size.height - 3);
        [self sendSubviewToBack:lastItem];
    }
    
    lastSelectedIndex = index;
    
//    // 如果有滑动条，让其滚动
//    UIView *sliderView = [self viewWithTag:BG_IMAGE_TAG];
//    if (sliderView) {
//        [UIView animateWithDuration:0.2 animations:^{
//            CGRect rect = sliderView.frame;
//            rect.origin.x = index * rect.size.width;
//            sliderView.frame = rect;
//        }];
//    }
}


- (void) setTitleAr:(NSArray *)titleAr
{
    if (_titleAr != titleAr)
    {
        _titleAr = nil;
        _titleAr = (NSMutableArray *)titleAr;
    }
    if (_titleAr.count  == segAr.count) {
        for (int i = 0;i < _titleAr.count;i ++)
        {
            eLongTabScrollItemView  *seg = [segAr  objectAtIndex:i];
            seg.titleLabel.text = [_titleAr objectAtIndex:i];
        }
    }
}

-(void) addItem:(NSString *)title{
    NSInteger index = [self.segItems count] - 1;
    eLongTabScrollItemView *segItem			= [[eLongTabScrollItemView alloc] initWithFrame:CGRectMake(index * kTabItemWidth, 0, kTabItemWidth, self.size.height)];
    segItem.titleLabel.text			= title;
    segItem.tag						= index + ADDITION_TAG;
    segItem.delegate				= self;
    
    [self.scroll addSubview:segItem];
    [self.segItems addObject:segItem];
    [segAr  addObject:segItem];
    [_titleAr addObject:title];
    self.scroll.contentSize = CGSizeMake((kItemBetweenSpace * (segAr.count + 1) + kTabItemWidth * segAr.count), self.height);
}

#pragma mark -
#pragma mark eLongTabScrollItemViewDelegate

- (void)setHighlightedIndex:(NSInteger)index {
    self.selectedIndex = index - ADDITION_TAG;
}

@end

