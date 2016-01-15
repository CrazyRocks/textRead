//
//  ReadViewController.m
//  myBook
//
//  Created by csip on 15/7/24.
//  Copyright (c) 2015年 csip. All rights reserved.
//
#import "BookshelfController.h"
#import "ReadViewController.h"
#import "AppHelper.h"
#import "GMGridView.h"
#import "ReadViewController.h"
#import "E_ScrollViewController.h"
#import "CatalogText.h"
#import "CacheSize.h"
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
@interface BookshelfController ()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate,UIActionSheetDelegate>
{
    GMGridView *_gmGridView;
    NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
    NSString *bookPath;
    UIActionSheet *myActionSheet;
    int removeId;
}
@end

@implementation BookshelfController


- (void)viewDidLoad{
    [super viewDidLoad];
    _currentData = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    bookPath = [docDir stringByAppendingPathComponent:@"book"];
    [self copyBookToDomains];
    [self loadBooks];
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    NSInteger spacing = INTERFACE_IS_PHONE ? 10 : 15;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
}
-(void)loadBooks{
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:bookPath error:nil];
    for (NSString *bookName in fileNameList) {
        NSRange range = [bookName rangeOfString:@".txt"];
        if (range.location != NSNotFound) {
            NSArray *array = [bookName componentsSeparatedByString:@"."];
            NSDictionary *dic =@{@"bookName":array[0],@"bookPath":[NSString stringWithFormat:@"%@/%@",bookPath,bookName]};
            [_currentData addObject:dic];
        }
    }
    [_gmGridView reloadData];
}
-(void)copyBookToDomains{
    NSArray *bn = [[NSBundle mainBundle] pathsForResourcesOfType:@"txt" inDirectory:@"text"];
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:bookPath error:nil];
    
    if (fileNameList == nil) {
        [self createFolder:bookPath];
    }
    if (fileNameList.count <= 0) {
        for (NSString *path in bn) {
            [self copyMissingFile:path toPath:bookPath];
        }
    }
}
/**
 *    @brief    把sourcePath文件夹下的文件拷贝到沙盒
 *
 *    @param    sourcePath     文件路径
 *    @param    toPath         目标位置
 *    @return    BOOL
 */
- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    return retVal;
}

/**
 *    @brief    创建文件夹
 *
 *    @param    createDir     创建文件夹路径
 */
- (void)createFolder:(NSString *)createDir
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:createDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(84,115);
}
- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 79, 106)];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.shadowOffset=CGSizeMake(2,2);
        view.layer.shadowRadius=4;
        view.layer.shadowOpacity=0.7;
        view.layer.shadowColor=[[UIColor blackColor]CGColor];
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 71, 85)];
    imageView.image = [UIImage imageNamed:@"book"];
    imageView.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:imageView];
    
    NSDictionary *dic = [_currentData objectAtIndex:index];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 93, 75, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = dic[@"bookName"];
    [cell.contentView addSubview:label];
    cell.itemId = index;
    return cell;
}
/**
 *  每一项的点击事件
 *
 *  @param gridView 
 *  @param position 点击的哪一项
 */
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSDictionary *dic = _currentData[position];
    NSString *path = dic[@"bookPath"];
    [AppHelper showSimple];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *arr = [path componentsSeparatedByString:@"/"];
        NSString *str = [arr lastObject];
        arr = nil;
        if (![str isEqualToString:[[CatalogText siged] getBookName]]) {
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *bookPathv = [documentsDirectory stringByAppendingPathComponent:@"book"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:bookPathv]){
                [self createFolder:bookPathv];
            }
            NSString *bookname =[[CatalogText siged] getBookName];
            if (bookname == nil) {
                CacheSize *ca = [CacheSize defaultCalculateFileSize];
                [ca clearCache:bookPathv clearBlock:^(NSString *a){
                    [[CatalogText siged] loadText:path];
                }];
            }else{
                NSRange rang = [path rangeOfString:[[CatalogText siged] getBookName]];
                if (rang.location == NSNotFound) {
                    CacheSize *ca = [CacheSize defaultCalculateFileSize];
                    [ca clearCache:bookPathv clearBlock:^(NSString *a){
                        [[CatalogText siged] loadText:path];
                    }];
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
            [self presentViewController:loginvctrl animated:NO completion:nil];
        });
        
    });
}
- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    removeId = cell.itemId;
    myActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除图书",@"图书详情", nil];
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == myActionSheet) {
        if (buttonIndex==myActionSheet.cancelButtonIndex) {
            NSLog(@"取消");
        }
        switch (buttonIndex) {
            case 0:////打开照相机拍照
                [self removeItem];
                break;
                
            case 1:////打开本地相册
                break;
        }
    }
    
}
- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return NO;
}
- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}
-(void)removeItem{
    if (_currentData.count>0) {
        NSDictionary *dic = _currentData[removeId];
        NSString *path = dic[@"bookPath"];
        [_gmGridView removeObjectAtIndex:removeId withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_currentData removeObjectAtIndex:removeId];
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        [fileManager removeItemAtPath:path error:nil];
        [_gmGridView reloadData];
    }
}
@end