//
//  JCImageFiterViewController.m
//  CanCan
//  滤镜贴纸
//  Created by xingjian on 2017/8/11.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCImageFiterViewController.h"
#import "JCFiterSelectView.h"
#import "JCFiterCollectionViewCell.h"
#import "JCStickerCollectionViewCell.h"
#import "JCFiterModel.h"
#import "JCStickerModel.h"
#import "CIFilter+JCCustomFilter.h"
#import "JCStickerView.h"
#import "JCImageZoomViewController.h"

@interface JCImageFiterViewController ()<JCFiterSelectViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JCStickerViewDelegate>

{
    BOOL isSticker;
    NSInteger fiterSelectRow;
    NSInteger stickerSelectRow;
}
@property (nonatomic,strong)UIImageView  *jcImgView;
@property (nonatomic,strong)UIView  *imgContentView;
@property (nonatomic,strong)JCFiterSelectView  *jcFiterSelect;
@property (nonatomic,strong)UICollectionView  *jcCollectionView;
@property (nonatomic,strong)NSMutableArray    *jcStickerArr;
@property (nonatomic,strong)NSMutableArray    *jcFiterArr;
@property (nonatomic,strong)NSMutableArray *stickerArray;

@end

@implementation JCImageFiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutJCNav];
    [self layoutMyUI];
    [self jcInitData];
    // Do any additional setup after loading the view.
}
- (void)layoutJCNav
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(jcRightBtnOnClick:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}

- (void)layoutMyUI
{
    [self.view addSubview:self.imgContentView];
    [self.imgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
    }];
    [self.imgContentView addSubview:self.jcImgView];
    [self.jcImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.jcImg.size.width);
        make.height.mas_equalTo(self.jcImg.size.height);
        make.center.mas_equalTo(self.imgContentView);
    }];
//    [self.jcImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kScreenWidth);
//        make.height.mas_equalTo(kScreenWidth);
//        make.center.mas_equalTo(self.imgContentView);
//    }];
    CGFloat baseY = kScreenWidth;
    CGFloat spaceY = (kScreenHeight-64-44-216/2-kScreenWidth)/2;
    
    if (spaceY>25) {
        spaceY = 25;
    }
    baseY = baseY+spaceY;
    //创建网格
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.jcCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, baseY, kScreenWidth, 216/2) collectionViewLayout:flowLayout];
    [self.view addSubview:self.jcCollectionView];
    //实现代理
    self.jcCollectionView.delegate = self;
    self.jcCollectionView.dataSource = self;
    self.jcCollectionView.showsVerticalScrollIndicator = NO;
    self.jcCollectionView.showsHorizontalScrollIndicator = NO;
    //注册cell
    [self.jcCollectionView registerClass:[JCFiterCollectionViewCell class] forCellWithReuseIdentifier:@"jcFiterCellID"];
    [self.jcCollectionView registerClass:[JCStickerCollectionViewCell class] forCellWithReuseIdentifier:@"jcStickerCellID"];
    //设置背景
    self.jcCollectionView.backgroundColor = [UIColor whiteColor];
    self.jcImgView.image = self.jcImg;
    [self.view addSubview:self.jcFiterSelect];
    [self.jcFiterSelect jcConfigTitleViewWithData:@[@"参参贴纸",@"参参滤镜"]];
}
//配置滤镜，贴纸数据
- (void)jcInitData
{
    //配置滤镜
    NSArray *fiterName = @[@"原图",@"胶片",@"黑白",@"复古",@"格调",@"铬黄"];
    NSArray *fiterGpuName = @[@"OriginImage",@"CIPhotoEffectTransfer",@"CIPhotoEffectTonal",@"CIPhotoEffectInstant",@"CIPhotoEffectFade",@"CIPhotoEffectChrome"];
    self.jcFiterArr = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        JCFiterModel *model = [JCFiterModel new];
        model.fiterName = fiterName[i];
        model.fiterGpuName = fiterGpuName[i];
        [self.jcFiterArr addObject:model];
    }
    //配置贴纸
    NSArray *stSmImg = @[@"stickers_tree.png",@"stickers_icon.png",@"stickers_cancan.png"];
    NSArray *stBigImg = @[@"stickers_tree_big.png",@"stickers_icon_big.png",@"stickers_cancan_big.png"];
    self.jcStickerArr = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        JCStickerModel *model = [JCStickerModel new];
        model.stSmImg = stSmImg[i];
        model.stBigImg = stBigImg[i];
        [self.jcStickerArr addObject:model];
    }
    self.stickerArray = [@[]mutableCopy];
}
#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (isSticker == YES) {
        return self.jcStickerArr.count;
    }
    else
    {
        return self.jcFiterArr.count;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSticker == YES)
    {
        
        JCStickerCollectionViewCell * jcStickerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"jcStickerCellID" forIndexPath:indexPath];
        if (stickerSelectRow == indexPath.row+1) {
            
            [jcStickerCell jcChangeSelectState];
        }
        else
        {
            [jcStickerCell jcChangeNormalState];
        }
        if (indexPath.row<self.jcStickerArr.count) {
            JCStickerModel * model = [self.jcStickerArr objectAtIndex:indexPath.row];
            [jcStickerCell jcConfigData:model withIndexPath:indexPath withOriginImg:self.jcImg];
        }
       
        return jcStickerCell;
        
    }
    else
    {
        JCFiterCollectionViewCell * jcFiterCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"jcFiterCellID" forIndexPath:indexPath];
        if (fiterSelectRow == indexPath.row+1) {
            
            [jcFiterCell jcChangeSelectState];
        }
        else
        {
            [jcFiterCell jcChangeNormalState];
        }

        if (indexPath.row<self.jcFiterArr.count) {
            JCFiterModel * model = [self.jcFiterArr objectAtIndex:indexPath.row];
            [jcFiterCell jcConfigData:model withIndexPath:indexPath withOriginImg:self.jcImg];
        }
        
        return jcFiterCell;
    }
   
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isSticker == YES) {
        
        JCStickerCollectionViewCell * stickerCell = (JCStickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [stickerCell jcChangeSelectState];
        stickerSelectRow = indexPath.row+1;
        JCStickerModel *model = [self.jcStickerArr objectAtIndex:indexPath.row];
        if (self.stickerArray.count>0) {
            JCStickerView *jcSView = [self.stickerArray firstObject];
            [self removeSticker:jcSView.stickerID];
            [jcSView removeFromSuperview];
        }
        JCStickerView *stickerView = [[JCStickerView alloc] initWithBgView:self.imgContentView StickerID:indexPath.row+1000 Img:[UIImage imageNamed:model.stBigImg]];
        stickerView.delegate = self ;
        [_stickerArray addObject:stickerView];
        [self makeStickerBecomeFirstRespond:stickerView.stickerID];

    }
    else
    {
        JCFiterCollectionViewCell  *fiterCell = (JCFiterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [fiterCell jcChangeSelectState];
        fiterSelectRow = indexPath.row+1;
        JCFiterModel * model = [self.jcFiterArr objectAtIndex:indexPath.row];
        UIImage *jcImg = [CIFilter filterEvent:model.fiterGpuName originImage:self.jcImg];
        if (indexPath.row == 0) {
            
            self.jcImgView.image = jcImg;

        }
        else
        {
            UIImage *jcFinishImg = [self reSizeImage:jcImg toSize:self.jcImg.size];
            self.jcImgView.image = jcFinishImg;
        }

        [collectionView reloadData];
    }

}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height), NO, 0);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}
#pragma mark - ZTStickerViewDelegate
- (void)makeStickerBecomeFirstRespond:(NSInteger)stickerID ;
{
    JCStickerView *firstSticker;
    
    for (int i=0; i<_stickerArray.count; i++) {
        JCStickerView *stickerView = _stickerArray[i];
        stickerView.isOnFirst = NO;
        if (stickerView.stickerID == stickerID)
        {
            stickerView.isOnFirst = YES ;
            [self.imgContentView bringSubviewToFront:stickerView];
            firstSticker = stickerView;
        }
    }
    [_stickerArray removeObject:firstSticker];
    [_stickerArray addObject:firstSticker];
}

- (void)removeSticker:(NSInteger)stickerID
{
    for (JCStickerView *stickerView in _stickerArray) {
        
        if (stickerView.stickerID == stickerID) {
            [_stickerArray removeObject:stickerView];
            break;
        }
    }
}

#pragma mark - 合成图片
- (UIImage *)pasteStickers:(UIImage*)originImage
{
    
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, [[UIScreen mainScreen]scale]);
    [originImage drawInRect:CGRectMake(0, 0, originImage.size.width, originImage.size.height)];
    NSLog(@"图片宽:%f,图片高:%f",originImage.size.width,originImage.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (JCStickerView *stickerView in _stickerArray) {
        
        CGRect rect=[stickerView convertRect:stickerView.imgContentView.frame toView:self.jcImgView];
        
        CGSize originalSize = originImage.size;
//        CGSize newSize = self.imgContentView.frame.size;
        CGSize newSize = originImage.size;
        CGFloat ratio =originalSize.width/newSize.width;//图片的显示尺寸和绘制到图形上下文中的实际尺寸的比例
        
        rect.origin.x =rect.origin.x*ratio;
        rect.origin.y =rect.origin.y*ratio;
        rect.size.width = rect.size.width*ratio;
        rect.size.height = rect.size.height*ratio;
        
        CGContextSaveGState(context);
        [[stickerView getChangedImage] drawInRect:rect];
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext() ;
    
    return image ;
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSticker == YES) {
       
        JCStickerCollectionViewCell * stickerCell = (JCStickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [stickerCell jcChangeNormalState];

    }
    else
    {    JCFiterCollectionViewCell  *fiterCell = (JCFiterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [fiterCell jcChangeNormalState];
        
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize jcSize = CGSizeMake(216/2, 216/2);
    return jcSize;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20/2;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)jcRightBtnOnClick:(UIBarButtonItem *)sender
{
    NSLog(@"下一步");
//    JCTestImgViewController * jcTestImg = [[JCTestImgViewController alloc]init];
//    jcTestImg.jcFinishImg = [self pasteStickers:self.jcImgView.image];
//    [self.navigationController pushViewController:jcTestImg animated:YES];
//    return;
    UIImage *jcFinishImg = [self pasteStickers:self.jcImgView.image];
//    //跳转回指定控制器
//    NSArray *temArray = self.navigationController.viewControllers;
//    
////    for(UIViewController *temVC in temArray)
////        
////    {
////        
////        if ([temVC isKindOfClass:[SendDynamicViewController class]])
////            
////        {
////            [[NSNotificationCenter defaultCenter]postNotificationName:@"jcReceiveFiterAndStickerFinishImg" object:jcFinishImg];
////            [self.navigationController popToViewController:temVC animated:YES];
////            
////        }
////        
////    }
//    [self.navigationController popViewControllerAnimated:YES];
    JCImageZoomViewController *jcZoomVC = [JCImageZoomViewController new];
    jcZoomVC.jcFinishImg = jcFinishImg;
    [self.navigationController pushViewController:jcZoomVC animated:YES];


}

- (void)leftBarButtonEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark JCFiterSelectViewDelegate
- (void)jcFiterSelect:(JCFiterSelectView *)fiterView withIndex:(NSInteger)index
{
   // NSLog(@"点击了这个:%ld",index);
    if (index == 0) {
        
        isSticker = YES;
        [self.jcCollectionView reloadData];
    }
    else
    {
        isSticker = NO;
        [self.jcCollectionView reloadData];
    }
}

- (JCFiterSelectView *)jcFiterSelect
{
    if (!_jcFiterSelect) {
        
        _jcFiterSelect = [[JCFiterSelectView alloc]initWithFrame:CGRectMake(0, kScreenHeight-64-88/2, kScreenWidth, 88/2)];
        _jcFiterSelect.delegate = self;
    }
    return _jcFiterSelect;
}
- (UIView *)imgContentView
{
    if (!_imgContentView) {
        
        _imgContentView = [UIView new];
        _imgContentView.backgroundColor = [UIColor blackColor];
    }
    return _imgContentView;
}
- (UIImageView *)jcImgView
{
    if (!_jcImgView) {
        
        
        _jcImgView = [UIImageView new];
        //_jcImgView.contentMode = UIViewContentModeCenter;
        
    }
    return _jcImgView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
