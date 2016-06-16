//
//  eLongCalendarView.m
//  eLongCalendar
//
//  Created by top on 14/12/17.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import "eLongCalendarView.h"
#import "eLongCalendarDefine.h"
#import "eLongCalendarHandler.h"
#import "eLongCalendarCell.h"
#import "eLongCalendarMonthModel.h"
#import "eLongCalendarHeaderReusableView.h"
#import "eLongCalendarWeekFlagView.h"
#import "eLongCalendarDefine.h"
#import "eLongCalendarDataSourceModel.h"
#import "eLongCalendarDateModel.h"
#import "eLongNetUtil.h"
#import "NSArray+CheckArray.h"
#import "eLongCalendar.h"
#import "eLongDefine.h"

@interface eLongCalendarView ()<UICollectionViewDataSource, UICollectionViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *contentCV;

@property (nonatomic, strong) eLongCalendarHandler *calendarHandler;

@property (nonatomic, copy, readwrite) NSString *currentYear;  //当前年份

@property (nonatomic, copy, readwrite) NSString *currentMonth; //当前月份

@property (nonatomic, strong) UIAlertView *periodLimitAlertView; //超过限制天数弹框

@property (nonatomic, assign) BOOL shouldResetCheckoutDate;

@property (nonatomic, strong) eLongCalendarDateModel *resetCheckoutDateModel;

@end

@implementation eLongCalendarView

- (id)initWithFrame:(CGRect)frame style:(eLongCalendarViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _calendarHandler = [[eLongCalendarHandler alloc] init];
        _calendarHandler.calendarViewStyle = style;
        _maximumLimitNumberOfDays = -1;
        [self configureContentView];
    }
    return self;
}

- (void)configureContentView {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    eLongCalendarWeekFlagView *weekFlagView = [[eLongCalendarWeekFlagView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 32)];
    [self addSubview:weekFlagView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (CGRectGetWidth(self.bounds)-16.0)/7.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, 56);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.bounds), 40);
    
    _contentCV = [[UICollectionView alloc] initWithFrame:CGRectMake(8,
                                                                    32,
                                                                    itemWidth*7,
                                                                    CGRectGetHeight(self.bounds)-32)
                                    collectionViewLayout:flowLayout];
    _contentCV.delegate = self;
    _contentCV.dataSource = self;
    _contentCV.backgroundColor = [UIColor whiteColor];
    _contentCV.showsHorizontalScrollIndicator = NO;
    _contentCV.showsVerticalScrollIndicator = NO;
    _contentCV.clipsToBounds = YES;
    _contentCV.scrollsToTop = NO;
    [self addSubview:_contentCV];
    
    [_contentCV registerClass:[eLongCalendarCell class] forCellWithReuseIdentifier:@"eLongCalendarCell"];
    [_contentCV registerClass:[eLongCalendarHeaderReusableView class]
   forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
          withReuseIdentifier:@"HeaderView"];
}

- (void)configureDataSource {
    self.maximumLimitNumberOfDays = -1;
    self.tipOfLimitOfDays = nil;
    eLongCalendarDataSourceModel *dataSourceModel = [[eLongCalendarDataSourceModel alloc] init];
    self.calendarHandler.dataSourceModel = dataSourceModel;
    self.calendarHandler.showLunarDate = self.showLunarCalendar;
    
    switch (self.calendarHandler.calendarViewStyle) {
        case eLongCalendarViewStyleNone:
            break;
        case eLongCalendarViewStyleOneDate: {
            if ([self.dataSource respondsToSelector:@selector(checkinDateInCalendarView:)]) {
                self.calendarHandler.dataSourceModel.periodStartDate = [self.dataSource checkinDateInCalendarView:self];
            }
            if ([self.dataSource respondsToSelector:@selector(checkinDateTitleCalendarView:)]) {
                self.calendarHandler.dataSourceModel.titleOfStartDate = [self.dataSource checkinDateTitleCalendarView:self];
            }
        }
            break;
        case eLongCalendarViewStylePeriod: {
            if ([self.dataSource respondsToSelector:@selector(checkinDateInCalendarView:)]) {
                self.calendarHandler.dataSourceModel.periodStartDate = [self.dataSource checkinDateInCalendarView:self];
            }
            if ([self.dataSource respondsToSelector:@selector(checkoutDateInCalendarView:)]) {
                self.calendarHandler.dataSourceModel.periodEndDate = [self.dataSource checkoutDateInCalendarView:self];
            }
            if ([self.dataSource respondsToSelector:@selector(checkinDateTitleCalendarView:)]) {
                self.calendarHandler.dataSourceModel.titleOfStartDate = [self.dataSource checkinDateTitleCalendarView:self];
            }
            if ([self.dataSource respondsToSelector:@selector(checkoutDateTitleCalendarView:)]) {
                self.calendarHandler.dataSourceModel.titleOfEndDate = [self.dataSource checkoutDateTitleCalendarView:self];
            }
            if ([self.dataSource respondsToSelector:@selector(daysOfPeriodLimit)]) {
                self.maximumLimitNumberOfDays = [self.dataSource daysOfPeriodLimit];
            }
            if ([self.dataSource respondsToSelector:@selector(messageOfPeriodLimit)]) {
                self.tipOfLimitOfDays = [self.dataSource messageOfPeriodLimit];
            }
        }
            break;
        default:
            break;
    }
    if ([self.dataSource respondsToSelector:@selector(numberOfMonthsInCalendarView:)]) {
        self.calendarHandler.dataSourceModel.numberOfMonths = [self.dataSource numberOfMonthsInCalendarView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(disabledToSelectBeforeDateInCalendarView:)]) {
        self.calendarHandler.dataSourceModel.disabledToSelectBeforeDate = [self.dataSource disabledToSelectBeforeDateInCalendarView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(disabledToSelectAfterDateInCalendarView:)]) {
        self.calendarHandler.dataSourceModel.disabledToSelectAfterDate = [self.dataSource disabledToSelectAfterDateInCalendarView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(changeSomeDateTitleInCalendarView:)]) {
        self.calendarHandler.dataSourceModel.changeSomeDateTitleArray = [self.dataSource changeSomeDateTitleInCalendarView:self];
    }
    [self.calendarHandler configureCellModelsData];
}

- (void)reloadDataWithCompletionBlock:(ReloadDataCompletionBlock)block {
    [self.calendarHandler reset];
    self.contentCV.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self configureDataSource];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentCV reloadData];
            self.contentCV.userInteractionEnabled = YES;
            [self updateCurrentYearAndMonth];
            if (self.calendarHandler.startDateModel) {
                [self scrollToTopOfSection:self.calendarHandler.startDateModel.cellIndexPath
                                  animated:NO];
            }
            if (block) {
                block();
            }
        });
    });
}

- (void)refreshSpecialTitle {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([self.dataSource respondsToSelector:@selector(changeSomeDateTitleInCalendarView:)]) {
            self.calendarHandler.dataSourceModel.changeSomeDateTitleArray = [self.dataSource changeSomeDateTitleInCalendarView:self];
        }
        [self.calendarHandler refreshSpecialTitle];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentCV reloadData];
        });
    });
}

- (void)setDataSource:(id<eLongCalendarViewDataSource>)dataSource{
    if (!dataSource || dataSource == _dataSource) {
        return;
    }
    _dataSource = dataSource;
}

- (void)resetCheckoutDate {
    self.shouldResetCheckoutDate = YES;
    self.resetCheckoutDateModel = self.calendarHandler.endDateModel;
    self.calendarHandler.endDateModel = nil;
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.calendarHandler.cellModelsData ? self.calendarHandler.cellModelsData.count : 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    eLongCalendarMonthModel *monthModel = [self.calendarHandler.cellModelsData safeObjectAtIndex:section];
    return monthModel.days ? monthModel.days.count : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"eLongCalendarCell";
    eLongCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    eLongCalendarMonthModel *monthModel = [self.calendarHandler.cellModelsData safeObjectAtIndex:indexPath.section];
    eLongCalendarDateModel *dateModel = [monthModel.days safeObjectAtIndex:indexPath.row];
    dateModel.shouldShowLunarDate = self.showLunarCalendar;
    [cell refreshContentViewWithDateModel:dateModel];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        eLongCalendarHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.splitView.hidden = YES;
        } else {
            headerView.splitView.hidden = NO;
        }
        reusableview = headerView;
        eLongCalendarMonthModel *monthModel = [self.calendarHandler.cellModelsData safeObjectAtIndex:indexPath.section];
        headerView.titleLabel.text = monthModel.title;
    }
    return reusableview;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    eLongCalendarMonthModel *monthModel = [self.calendarHandler.cellModelsData safeObjectAtIndex:indexPath.section];
    eLongCalendarDateModel *dateModel = [monthModel.days safeObjectAtIndex:indexPath.row];
    if (dateModel.disabled || !dateModel.shouldShow) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:shouldSelectOneDate:)]) {
        BOOL shouldSelect = [self.delegate calendarView:self shouldSelectOneDate:dateModel.date];
        if (!shouldSelect) {
            return;
        }
    }
    
    switch (self.calendarHandler.calendarViewStyle) {
        case eLongCalendarViewStyleOneDate: {
            if ([self.calendarHandler.startDateModel isEqual:dateModel]) {
                dateModel.selected = NO;
                dateModel.selectType = eLongCalendarDateModelSelectTypeNone;
                dateModel.specialTitle = nil;
                self.calendarHandler.startDateModel = nil;
            } else {
                self.calendarHandler.startDateModel.selected = NO;
                self.calendarHandler.startDateModel.specialTitle = nil;
                self.calendarHandler.startDateModel.selectType = eLongCalendarDateModelSelectTypeNone;
                eLongCalendarCell *cell = (eLongCalendarCell *)[collectionView cellForItemAtIndexPath:self.calendarHandler.startDateModel.cellIndexPath];
                [cell refreshContentViewWithDateModel:self.calendarHandler.startDateModel];
                dateModel.selected = YES;
                dateModel.specialTitle = self.calendarHandler.dataSourceModel.titleOfStartDate;
                dateModel.selectType = eLongCalendarDateModelSelectTypeOnlyOneDate;
                self.calendarHandler.startDateModel = dateModel;
            }
            [self.contentCV reloadData];
            if (self.calendarHandler.startDateModel) {
                if ([self.delegate respondsToSelector:@selector(calendarView:didSelectOneDate:)]) {
                    [self.delegate calendarView:self didSelectOneDate:dateModel.date];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(calendarView:didDeselectOneDate:)]) {
                    [self.delegate calendarView:self didDeselectOneDate:dateModel.date];
                }
            }
        }
            break;
        case eLongCalendarViewStylePeriod: {
            eLongCalendar *calendar = [[eLongCalendar alloc] init];
            if (self.shouldResetCheckoutDate) {
                eLongCalendarDateComparison comparingResult = [calendar compareTwoDateWithFirstDate:self.calendarHandler.startDateModel.date
                                                                                         secondDate:dateModel.date];
                if (comparingResult == eLongCalendarDateComparisonBefore) {
                    if (self.maximumLimitNumberOfDays != -1) {
                        self.calendarHandler.endDateModel = dateModel;
                        if (![self.calendarHandler checkMaximumLimitNumberOfDaysWithDays:self.maximumLimitNumberOfDays]) {
                            NSString *message = self.tipOfLimitOfDays ? self.tipOfLimitOfDays : @"不可选";
                            UIAlertView *alret = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                            self.periodLimitAlertView = alret;
                            [alret show];
                            self.calendarHandler.endDateModel = nil;
                            return;
                        }
                        self.calendarHandler.endDateModel = nil;
                    }
                }
                self.resetCheckoutDateModel.selected = NO;
                self.resetCheckoutDateModel.specialTitle = nil;
                self.resetCheckoutDateModel.selectType = eLongCalendarDateModelSelectTypeNone;
                [self.calendarHandler resetMarkCellModels];
                if ([dateModel isEqual:self.calendarHandler.startDateModel]) {
                    self.calendarHandler.startDateModel.selected = NO;
                    self.calendarHandler.startDateModel.selectType = eLongCalendarDateModelSelectTypeNone;
                    self.calendarHandler.startDateModel.specialTitle = nil;
                    self.calendarHandler.startDateModel = nil;
                }
                self.shouldResetCheckoutDate = NO;
            }
            
            if (self.calendarHandler.startDateModel) {
                
                eLongCalendarDateComparison comparingResult = [calendar compareTwoDateWithFirstDate:self.calendarHandler.startDateModel.date
                                                                                         secondDate:dateModel.date];
                if (self.calendarHandler.endDateModel) {
                    [self.calendarHandler resetPeriodCellModels];
                    dateModel.selected = YES;
                    dateModel.selectType = eLongCalendarDateModelSelectTypeStartDate;
                    self.calendarHandler.startDateModel = dateModel;
                    self.calendarHandler.startDateModel.specialTitle = self.calendarHandler.dataSourceModel.titleOfStartDate;
                    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectCheckinDateInPeriod:)]) {
                        [self.delegate calendarView:self didSelectCheckinDateInPeriod:self.calendarHandler.startDateModel.date];
                    }
                    [self scrollToStartDatePosition:indexPath animated:YES];
                } else {
                    switch (comparingResult) {
                        case eLongCalendarDateComparisonBefore: {
                            self.calendarHandler.endDateModel = dateModel;
                            if (self.maximumLimitNumberOfDays != -1) {
                                if (![self.calendarHandler checkMaximumLimitNumberOfDaysWithDays:self.maximumLimitNumberOfDays]) {
                                    self.calendarHandler.endDateModel = nil;
                                    NSString *message = self.tipOfLimitOfDays ? self.tipOfLimitOfDays : @"不可选";
                                    UIAlertView *alret = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                                    self.periodLimitAlertView = alret;
                                    [alret show];
                                    return;
                                }
                            }
                            self.calendarHandler.endDateModel.selectType = eLongCalendarDateModelSelectTypeEndDate;
                            [self.calendarHandler refreshPeriodCellModels];
                            if (self.calendarHandler.periodDict && self.calendarHandler.periodDict.count > 0) {
                                if ([self.delegate respondsToSelector:@selector(calendarView:didSelectCheckoutDateInPeriod:)]) {
                                    [self.delegate calendarView:self didSelectCheckoutDateInPeriod:self.calendarHandler.endDateModel.date];
                                }
                            } else {
                                if ([self.delegate respondsToSelector:@selector(calendarView:didSelectCheckinDateInPeriod:)]) {
                                    [self.delegate calendarView:self didSelectCheckinDateInPeriod:self.calendarHandler.startDateModel.date];
                                }
                            }
                            if ([self.delegate respondsToSelector:@selector(calendarView:didSelectPeriod:)]) {
                                if (self.calendarHandler.periodDict && self.calendarHandler.periodDict.count > 0) {
                                    [self.delegate calendarView:self didSelectPeriod:self.calendarHandler.periodDict];
                                }
                            }
                            break;
                        }
                        case eLongCalendarDateComparisonEqual: {
                            [self.calendarHandler resetPeriodCellModels];
                            if ([self.delegate respondsToSelector:@selector(calendarView:didDeselectCheckinDateInPeriod:)]) {
                                [self.delegate calendarView:self didDeselectCheckinDateInPeriod:dateModel.date];
                            }
                            break;
                        }
                        case eLongCalendarDateComparisonAfter: {
                            [self.calendarHandler resetPeriodCellModels];
                            dateModel.selected = YES;
                            dateModel.selectType = eLongCalendarDateModelSelectTypeStartDate;
                            self.calendarHandler.startDateModel = dateModel;
                            self.calendarHandler.startDateModel.specialTitle = self.calendarHandler.dataSourceModel.titleOfStartDate;
                            if ([self.delegate respondsToSelector:@selector(calendarView:didSelectCheckinDateInPeriod:)]) {
                                [self.delegate calendarView:self didSelectCheckinDateInPeriod:self.calendarHandler.startDateModel.date];
                            }
                            [self scrollToStartDatePosition:indexPath animated:YES];
                            break;
                        }
                        default: {
                            break;
                        }
                    }
                }
            } else {
                [self.calendarHandler resetPeriodCellModels];
                dateModel.selected = YES;
                dateModel.selectType = eLongCalendarDateModelSelectTypeStartDate;
                self.calendarHandler.startDateModel = dateModel;
                self.calendarHandler.startDateModel.specialTitle = self.calendarHandler.dataSourceModel.titleOfStartDate;
                if ([self.delegate respondsToSelector:@selector(calendarView:didSelectCheckinDateInPeriod:)]) {
                    [self.delegate calendarView:self didSelectCheckinDateInPeriod:self.calendarHandler.startDateModel.date];
                }
                [self scrollToStartDatePosition:indexPath animated:YES];
            }
            [self.contentCV reloadData];
        }
            break;
        case eLongCalendarViewStyleNone:
            break;
        default:
            break;
    }
}

- (void)scrollToStartDatePosition:(NSIndexPath *)indexPath animated:(BOOL)animated {
    UICollectionViewCell *cell = [self.contentCV cellForItemAtIndexPath:indexPath];
    CGPoint point = [self.contentCV convertPoint:cell.frame.origin toView:self];
    if (point.y >= self.frame.size.height-56*2) {
        [self scrollToTopOfSection:indexPath animated:YES];
    }
}

- (void)scrollToTopOfSection:(NSIndexPath *)indexPath animated:(BOOL)animated {
    UICollectionViewLayoutAttributes *attributes = [self.contentCV layoutAttributesForItemAtIndexPath:indexPath];
    CGRect rect = attributes.frame;
    [self.contentCV setContentOffset:CGPointMake(0, rect.origin.y - 56) animated:animated];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCurrentYearAndMonth];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self updateCurrentYearAndMonth];
    }
}

-(void)updateCurrentYearAndMonth {
    NSArray *cells = [self.contentCV visibleCells];
    if (cells && cells.count > 0) {
        eLongCalendarCell *cell= [cells safeObjectAtIndex:0];
        if (cell) {
            self.currentYear = [NSString stringWithFormat:@"%ld",(long)[self.calendarHandler yearWithDate:cell.dateModel.date]];
            self.currentMonth = [NSString stringWithFormat:@"%ld",(long)[self.calendarHandler monthWithDate:cell.dateModel.date]];
        }
    } else {
        if (self.calendarHandler.startDateModel.date
            && [self.calendarHandler.startDateModel.date isKindOfClass:[NSDate class]]) {
            self.currentYear = [NSString stringWithFormat:@"%ld",(long)[self.calendarHandler yearWithDate:self.calendarHandler.startDateModel.date]];
            self.currentMonth = [NSString stringWithFormat:@"%ld",(long)[self.calendarHandler monthWithDate:self.calendarHandler.startDateModel.date]];
        } else {
            self.currentYear = [NSString stringWithFormat:@"%ld",(long)[self.calendarHandler yearWithDate:[NSDate date]]];
            self.currentMonth = [NSString stringWithFormat:@"%ld",(long)[self.calendarHandler monthWithDate:[NSDate date]]];
        }
    }
}
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.periodLimitAlertView) {
        if (buttonIndex == 0) {
            if ([self.delegate respondsToSelector:@selector(calendarViewConfirmPeriodLimit:)]) {
                [self.delegate calendarViewConfirmPeriodLimit:self];
            }
        }
    }
}
@end
