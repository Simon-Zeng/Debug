//
//  eLongAlbumTablePicker.m
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongAlbumTablePicker.h"
#import "eLongAlbumAssetCell.h"
#import "eLongHotelUploadPhotosController.h"
#import "eLongAssetsPickerController.h"
#import "eLongAttributedLabel.h"
#import "eLongAlertView.h"
#import "UIButton+eLongExtension.h"

@interface eLongAlbumTablePicker()

@property (nonatomic, assign) int columns;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) eLongAssetsPickerType pickerType;
@property (nonatomic, strong) eLongAttributedLabel *selectedLbl;
@property (nonatomic, assign) NSInteger selectedNum;
@end


@implementation eLongAlbumTablePicker

- (id) initWithAssetGroup:(ALAssetsGroup *)asGroup{
    return [self initWithAssetGroup:asGroup title:@"上传酒店图片" pickerType:RoomPhotoPicker];
}

- (id)initWithAssetGroup:(ALAssetsGroup *)asGroup title:(NSString *)title pickerType:(eLongAssetsPickerType)pickerType{
    //    self = [super init];
    //    if (self) {
    
    if (self = [super initWithTitle:title style:NavBarBtnStyleOnlyBackBtn]){
        //Sets a reasonable default bigger then 0 for columns
        //So that we don't have a divide by 0 scenario
        self.columns = 4;
        self.titleString = title;
        self.pickerType = pickerType;

        
        self.assetGroup = asGroup;
        self.maxUploadImageNumber = 30;
        
        
        
    }
    return self;
}

- (void) refreshSelectedTips{
    NSString *var0 = [NSString stringWithFormat:@"%ld",(long)self.selectedNum];
    NSString *var1 = [NSString stringWithFormat:@"%lu",(unsigned long)self.maxUploadImageNumber];
    
    [self.selectedLbl setText:[NSString stringWithFormat:@"%@/%@",var0,var1]];
    [self.selectedLbl setFont:FONT_B18 fromIndex:0 length:self.selectedLbl.text.length];
    
    [self.selectedLbl setColor:RGBACOLOR(255, 166, 0, 1) fromIndex:0 length:var0.length];
    [self.selectedLbl setColor:[UIColor whiteColor] fromIndex:var0.length length:var1.length + 1];
}
- (void)setClickedImageAssets:(NSArray *)clickedImageAssets
{
    if (_clickedImageAssets != clickedImageAssets) {
        _clickedImageAssets = clickedImageAssets;
    }
}
- (void) setMaxUploadImageNumber:(NSUInteger)maxUploadImageNumber{
    _maxUploadImageNumber = maxUploadImageNumber;
    [self refreshSelectedTips];
}

- (void)dealloc
{
    self.assetGroup = nil;
    self.albumAssets = nil;
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    self.tableView = nil;
    
    self.uploader = nil;
    
    self.selectedLbl = nil;
    
    self.hotelDetailModel = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    self.tableView = tempTableView;
    [self.view addSubview:_tableView];
    tempTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setAllowsSelection:NO];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.albumAssets = tempArray;
    [_assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    
    
    UIView *bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 48, SCREEN_WIDTH, 48)];
    bottomBarView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
    [self.view addSubview:bottomBarView];
    
    UIButton *confirmBtn = [UIButton uniformButtonWithTitle:@"确认"
                                                  ImagePath:Nil
                                                     Target:self
                                                     Action:@selector(doneAction:)
                                                      Frame:CGRectMake(SCREEN_WIDTH - 120 , 7, 110, 34)];
    [bottomBarView addSubview:confirmBtn];
    
    self.selectedLbl = [[eLongAttributedLabel alloc] initWithFrame:CGRectMake(20, 14, 100, 20)];
    self.selectedLbl.backgroundColor = [UIColor clearColor];
    [bottomBarView addSubview:self.selectedLbl];
    
    [self refreshSelectedTips];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.columns = self.view.bounds.size.width / 80;
}

- (void)preparePhotos
{
    @autoreleasepool {
        
        if (self.albumAssets.count !=0) {
            [self.albumAssets removeAllObjects];
        }

        
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil) {
                return;
            }
            
            eLongAlbumAsset *elAsset = [[eLongAlbumAsset alloc] initWithAsset:result];
            [elAsset setDelegate:self];
            
            BOOL isAssetFiltered = NO;
            
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            NSString *assetUrl = [[[result defaultRepresentation] url] absoluteString];
            NSUInteger typeLocation = [assetUrl rangeOfString:@"ext="].location;
            NSString *imageType = nil;
            if (typeLocation != NSNotFound) {
                imageType = [assetUrl substringFromIndex:typeLocation + 4];
            }
            imageType = [imageType lowercaseString];
            //            // 根据图片名字，判断类型
            //            NSString *imageName = [[result defaultRepresentation] filename];
            //            imageName = [imageName lowercaseString];
            //            NSArray *imageTypeSeperate = [imageName componentsSeparatedByString:@"."];
            //            NSString *imageType = [imageTypeSeperate safeObjectAtIndex:[imageTypeSeperate count] - 1];
            //            imageType = [imageType lowercaseString];
            
            // 过滤, 只需要媒体类型是图片
            if (!isAssetFiltered && [type isEqualToString:ALAssetTypePhoto] && STRINGHASVALUE(imageType) && ([imageType isEqualToString:@"jpg"] || [imageType isEqualToString:@"jpeg"] || [imageType isEqualToString:@"png"])) {
//                [self.albumAssets addObject:elAsset];
                [self.albumAssets insertObject:elAsset atIndex:0];
                for (NSString *s in self.clickedImageAssets) {
                    if ([s isEqualToString:assetUrl]) {
                        elAsset.selected = YES;
                        self.selectedNum = self.selectedNum + 1;
                        break;
                    }
                }

            }
            
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self refreshSelectedTips];

            [self.tableView reloadData];
            // scroll to bottom
            //            long section = [self numberOfSectionsInTableView:self.tableView] - 1;
            //            long row = [self tableView:self.tableView numberOfRowsInSection:section] - 1;
            //            if (section >= 0 && row >= 0) {
            //                NSIndexPath *ip = [NSIndexPath indexPathForRow:row
            //                                                     inSection:section];
            //                [self.tableView scrollToRowAtIndexPath:ip
            //                                      atScrollPosition:UITableViewScrollPositionBottom
            //                                              animated:NO];
            //            }
            
            //            [self.navigationItem setTitle:@"上传酒店图片"];
        });
    }
}

- (void)doneAction:(id)sender
{
    NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
    
    for (eLongAlbumAsset *elAsset in self.albumAssets) {
        for (NSString *s in self.clickedImageAssets) {
            NSString *assetUrl = [[[elAsset.asset defaultRepresentation] url] absoluteString];
            if ([s isEqualToString:assetUrl]) {
                elAsset.selected = NO;
                break;
            }
        }

        if ([elAsset selected]) {
            [selectedAssetsImages addObject:[elAsset asset]];
        }
    }
    
    if ([selectedAssetsImages count] == 0) {
        [eLongAlertView showAlertQuiet:_string(@"tips_uploadAfterSelectPicture")];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(elongAlbumTablePicker:didPickedImages:)]) {
        if ([selectedAssetsImages count] > _maxUploadImageNumber) {
            [eLongAlertView showAlertTitle:@"" Message:[NSString stringWithFormat:_string(@"tips_limitNumberOfPictures"),_maxUploadImageNumber]];
            return;
        }
        [self.delegate elongAlbumTablePicker:self didPickedImages:selectedAssetsImages];
    }
    
    if (self.pickerType == RoomPhotoPicker) {
        if (_uploader != nil) {
            NSString *uploaderMessage = [_uploader addWithAssets:selectedAssetsImages];
            if (uploaderMessage == nil) {
                [self.navigationController popToViewController:_uploader animated:NO];
            }
            else {
                [eLongAlertView showAlertTitle:@"" Message:uploaderMessage];
            }
        }
        else {
            if ([selectedAssetsImages count] > _maxUploadImageNumber) {
                [eLongAlertView showAlertTitle:@"" Message:[NSString stringWithFormat:_string(@"tips_limitNumberOfPictures"),_maxUploadImageNumber]];
                return;
            }
            
            eLongHotelUploadPhotosController *uploader = [[eLongHotelUploadPhotosController alloc] initWithAssets:selectedAssetsImages WithTitleString:self.titleString hotelDetailModel:self.hotelDetailModel];
            [self.navigationController pushViewController:uploader animated:YES];
            NSMutableArray *savedViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            if ([savedViewControllers count]>2) {
                [savedViewControllers removeObjectsInRange:NSMakeRange([savedViewControllers count] - 3, 2)];
            }

            [self.navigationController setViewControllers:savedViewControllers animated:NO];
        }
    }
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.columns <= 0) { //Sometimes called before we know how many columns we have
        self.columns = 4;
    }
    NSInteger numRows = ceil([self.albumAssets count] / (float)self.columns);
    return numRows;
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    long index = path.row * self.columns;
    long length = MIN(self.columns, [self.albumAssets count] - index);
    return [self.albumAssets subarrayWithRange:NSMakeRange(index, length)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    eLongAlbumAssetCell *cell = (eLongAlbumAssetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[eLongAlbumAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    if (self.selectedNum >= self.maxUploadImageNumber) {
        cell.selectable = NO;
    }else{
        cell.selectable = YES;
    }
    [cell setAssets:[self assetsForIndexPath:indexPath]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat margin = 4.0f;
    CGFloat imageW = (SCREEN_WIDTH - 5 * margin) / 4;
    CGFloat imageH = imageW;
    return imageH + margin;
}

- (void) elongAlbumAssetCell:(eLongAlbumAssetCell *)cell selected:(BOOL)selected{
    NSInteger count = 0;
    for (eLongAlbumAsset *elAsset in self.albumAssets) {
        if ([elAsset selected]) {
            count = count + 1;
        }
    }
    if (self.selectedNum != count) {
        self.selectedNum = count;
        [self.tableView reloadData];
    }
    
    [self refreshSelectedTips];
}

@end
