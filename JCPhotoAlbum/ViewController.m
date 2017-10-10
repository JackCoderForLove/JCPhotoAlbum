//
//  ViewController.m
//  JCPhotoAlbum
//
//  Created by xingjian on 2017/9/6.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "ViewController.h"
#import "JCImageFiterViewController.h"
#import "JCCustomPhotoView.h"
#import "JCPhotoTitleView.h"
#import <Photos/Photos.h>
#import "JCPhotoModel.h"
#import "JCImageSelectShowView.h"
#import "JCPhotoShowCollectionViewCell.h"
#import "JCTakePhotoCollectionViewCell.h"
#import "JCCustomAlert.h"
#import "JCPhotoSelcetCollectionHeader.h"
#import "TrainingShareView.h"
#import "JCImageZoomViewController.h"
#import "JCZoomViewController.h"

@interface ViewController ()<JCCustomPhotoViewDelegate,JCPhotoTitleViewDelegate,PHPhotoLibraryChangeObserver,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIAlertViewDelegate,JCCustomAlertDelegate,TrainingShareViewDelegate>

{
    UIButton *leftBtnBar;
    int _lastPosition;
    BOOL  isChangeCollectionFrame;
    CGRect oldFrame;
    CGRect newFrame;
    BOOL isCanChange;
    NSInteger selectRow;
}

@property (nonatomic,strong)JCCustomPhotoView  *jcPhotoView;
@property (nonatomic,strong)JCPhotoTitleView *photoTitleView;
@property (nonatomic,strong)NSMutableArray  *jcPhotoArr;//相册数组
@property (nonatomic,strong)PHFetchResult  *jcPhotoImgArr;//相册下所有图片的数组
@property (nonatomic,strong)JCPhotoModel    *currentSelectModel;
@property (nonatomic,strong)JCImageSelectShowView  *imgSelectShowView;
@property (nonatomic,strong)UICollectionView   *jcPhotoCollectionView;
@property (nonatomic,strong)JCPhotoShowCollectionViewCell *lastCollectionCell;
@property (strong, nonatomic) PHFetchOptions *options;
@property (nonatomic , strong) JCCustomAlert     *jcAlert;
@property (nonatomic,strong)JCPhotoSelcetCollectionHeader *jcPhotoSelctionHeader;
@property (nonatomic,strong)PHCachingImageManager *imageManager;
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundColor:[ToolsHelper colorWithHexString:@"#3FD2A0"]];
    [self.navigationController.navigationBar setBarTintColor:[ToolsHelper colorWithHexString:@"#3FD2A0"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //获取系统相册
    [self jcGetAllPhotos];
    [self layoutJCNav];
    [self layoutMyUI];
    [self jcGetPhotoRequest];
    [self jcGetNewFrame];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jcReloadData:) name:@"jcPhotoReload" object:nil];
    // Do any additional setup after loading the view.
}
- (void)jcReloadData:(NSNotification *)noti
{
    //获取系统相册
    // [self jcGetPhotoRequest];
    [self.jcPhotoCollectionView reloadData];
}
- (void)layoutJCNav
{
    leftBtnBar =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtnBar setFrame:CGRectMake(0, (44-44/2.0)/2.0, 44/2.0, 44/2.0)];
    [leftBtnBar setImage:[UIImage imageNamed:@"release_close.png"] forState:UIControlStateNormal];
    [leftBtnBar addTarget:self action:@selector(jcLeftOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtnBar];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"继续" style:UIBarButtonItemStyleDone target:self action:@selector(jcRightBtnOnClick:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.photoTitleView;
    
}
- (void)layoutMyUI
{
    //[self.view addSubview:self.imgSelectShowView];
    //创建网格
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.jcPhotoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:flowLayout];
    oldFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    newFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    isChangeCollectionFrame = NO;
    //实现代理
    self.jcPhotoCollectionView.delegate = self;
    self.jcPhotoCollectionView.dataSource = self;
    //注册cell
    [self.jcPhotoCollectionView registerClass:[JCPhotoShowCollectionViewCell class] forCellWithReuseIdentifier:@"jcphotoshowCellID"];
    [self.jcPhotoCollectionView registerClass:[JCTakePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"jcTakePhotoID"];
    [self.jcPhotoCollectionView registerClass:[JCPhotoSelcetCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"jcPhotoSelctionHeader"];
    //设置背景
    self.jcPhotoCollectionView.backgroundColor = [ToolsHelper colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:self.jcPhotoCollectionView];
    [self.view addSubview:self.jcPhotoView];
    self.jcPhotoView.hidden = YES;
    //    [self.jcPhotoView jcConfigData:@[@"大唐保健",@"大保健",@"没啥玩意",@"爱咋咋的",@"就这个吧",@"爱你一万年",@"瓦力没有时间哈",@"搜嘎丽娃"]];
    
    
}
- (void)jcGetPhotoRequest
{
    JCPhotoModel *model = [self.jcPhotoArr firstObject];
    selectRow = 1;
    self.jcPhotoImgArr = model.photoAlbumResult;
    [self.jcPhotoCollectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //默认选中第一个图片
        NSIndexPath *defaultSelectRow = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.jcPhotoCollectionView selectItemAtIndexPath:defaultSelectRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.jcPhotoCollectionView didSelectItemAtIndexPath:defaultSelectRow];
        
    });
}
- (void)jcGetNewFrame
{
    //获取每个item的行高
    CGFloat itemH = itemSizeW;
    //获取每个item行间距
    CGFloat itemSpace = 1;
    //计算总个数据可以显示多少行
    int lastRowCount = 10%4;
    long rowCount = (self.jcPhotoImgArr.count+1)/4+(lastRowCount==0?0:1);
    //计算总高度
    CGFloat jcH = itemH*rowCount+itemSpace*(rowCount+1);
    //获取整个屏幕高度
    CGFloat jcMaxH = kScreenHeight-64;
    
    if (jcH<jcMaxH) {
        isCanChange = NO;
    }
    else
    {
        isCanChange = YES;
    }
    
}
#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.jcPhotoImgArr.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCPhotoShowCollectionViewCell *jcPhotoShowTypeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"jcphotoshowCellID" forIndexPath:indexPath];
    JCTakePhotoCollectionViewCell *jcTakePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"jcTakePhotoID" forIndexPath:indexPath];
    if (indexPath.row == selectRow) {
        [jcPhotoShowTypeCell jcChangeSelectState];
    }
    else
    {
        [jcPhotoShowTypeCell jcChangeNormalState];
    }
    
    if (indexPath.row == 0)
    {
        if (self.jcPhotoImgArr.count == 0)
        {
            [self.jcPhotoSelctionHeader.imgSelectShowView jcConfigNoData];
        }
        
        return jcTakePhotoCell;
    }
    else
    {
        if (self.jcPhotoImgArr.count>1) {
            PHAsset *jcAsset = [self.jcPhotoImgArr objectAtIndex:indexPath.row-1];
            [jcPhotoShowTypeCell jcCofigData:jcAsset withIndexPath:indexPath];
        }
        else if (self.jcPhotoImgArr.count == 0)
        {
            [self.jcPhotoSelctionHeader.imgSelectShowView jcConfigNoData];
        }
        [self registerForPreviewingWithDelegate:self sourceView:jcPhotoShowTypeCell.jcItemImg];
        return jcPhotoShowTypeCell;
    }
    
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        //如果点击拍照，进入拍照界面
//        JCTakePhotoViewController *takePhotoVC =JCImageFiterViewControllerer new];
//        [self.navigationController pushViewController:takePhotoVC animated:YES];
    }
    else
    {
        
        //如果点击相册中的图片，将图片资源替换显示
        //获取当前点击的cell
        JCPhotoShowCollectionViewCell *currentCell = (JCPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (currentCell!=nil) {
            
            selectRow = indexPath.row;
            PHAsset *asset = [self.jcPhotoImgArr objectAtIndex:indexPath.row-1];
            [self.jcPhotoSelctionHeader.imgSelectShowView jcConfigImage:asset];
            [currentCell jcChangeSelectState];
            [collectionView reloadData];
            [UIView animateWithDuration:0.01 animations:^{
                //                self.jcPhotoCollectionView.frame = oldFrame;
                //                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                //                [self.jcPhotoCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                [self.jcPhotoCollectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                
            } completion:^(BOOL finished) {
                
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                isChangeCollectionFrame = NO;
                _lastPosition = 0;
            });
            
            
        }
        
    }
    
    NSLog(@"点击了哪一个视图:---%ld",indexPath.row);
}

#pragma mark -
#pragma mark UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
//     previewingContext.sourceView: 触发Peek & Pop操作的视图
//     previewingContext.sourceRect: 设置触发操作的视图的不被虚化的区域
//    获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
  

    //防止重复加入
    if ([self.presentedViewController isKindOfClass:[JCZoomViewController class]])
    {
        return nil;
    }
    else
    {
        JCZoomViewController *jcZoomVC = [JCZoomViewController new];
        UIImageView *jcImgView  = (UIImageView *)(previewingContext.sourceView);
        NSInteger jcTag = jcImgView.tag-9000;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:jcTag inSection:0];
        JCPhotoShowCollectionViewCell *currentCell = (JCPhotoShowCollectionViewCell *)[self.jcPhotoCollectionView cellForItemAtIndexPath:indexPath];
        jcZoomVC.jcFinishImg = currentCell.bigImg;
        //jcZoomVC.preferredContentSize = CGSizeMake(0.0f,300.f);
        // CGRect rect = CGRectMake(10, location.y - 10, self.view.frame.size.width - 20,20);
        //    previewingContext.sourceRect = rect;
        return jcZoomVC;

    }

}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    UIImageView *jcImgView  = (UIImageView *)(previewingContext.sourceView);
    NSInteger jcTag = jcImgView.tag-9000;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:jcTag inSection:0];
    JCPhotoShowCollectionViewCell *currentCell = (JCPhotoShowCollectionViewCell *)[self.jcPhotoCollectionView cellForItemAtIndexPath:indexPath];
    JCImageZoomViewController *jcZoomVC = [JCImageZoomViewController new];
    jcZoomVC.jcFinishImg = currentCell.bigImg;
    [self.navigationController pushViewController:jcZoomVC animated:YES];
   // [self.navigationController pushViewController:viewControllerToCommit animated:YES];
    //NSLog(@"pop了，哈哈哈，搜楼");
}

- (NSArray<id<UIViewControllerPreviewingDelegate>> *)previewActionItems
{
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"点赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"评论" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
//    UIPreviewActionGroup *actionGroup = [UIPreviewActionGroup actionGroupWithTitle:@"选项组" style:UIPreviewActionStyleDefault actions:@[action1, action2]];
    
//    return @[action1, action2, action3, actionGroup];
    return @[action1, action2, action3];

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        self.jcPhotoSelctionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"jcPhotoSelctionHeader" forIndexPath:indexPath];
        // [self.jcPhotoSelctionHeader.imgSelectShowView jcConfigNoData];
        
    }
    return self.jcPhotoSelctionHeader;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, kScreenWidth);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"调用了瓦力");
    //获取当前点击的cell
//    JCPhotoShowCollectionViewCell *currentCell = (JCPhotoShowCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if (currentCell!=nil) {
//        
//        [currentCell jcChangeNormalState];
//    }
    
    
    
}
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if (scrollView == self.jcPhotoCollectionView) {
    //
    //        NSLog(@"滚动距离%f",scrollView.contentOffset.y);
    //        int currentPostion = scrollView.contentOffset.y;
    //        if (currentPostion - _lastPosition > 25&&isChangeCollectionFrame == NO&&isCanChange==YES&&currentPostion>0) {
    //            _lastPosition = currentPostion;
    //
    //            [UIView animateWithDuration:0.5 animations:^{
    //                self.jcPhotoCollectionView.frame = newFrame;
    //
    //            } completion:^(BOOL finished) {
    //                isChangeCollectionFrame = YES;
    //                _lastPosition = 0;
    //            }];
    //        }
    //        else if (_lastPosition - currentPostion > 25&&currentPostion<0)
    //        {
    //            _lastPosition = currentPostion;
    //
    //            if (currentPostion<-25&&isChangeCollectionFrame == YES&&isCanChange==YES) {
    //
    //                [UIView animateWithDuration:0.5 animations:^{
    //                    self.jcPhotoCollectionView.frame = oldFrame;
    //                } completion:^(BOOL finished) {
    //
    //                }];
    //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                    isChangeCollectionFrame = NO;
    //                    _lastPosition = 0;
    //                });
    //
    //            }
    //        }
    //
    //    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(itemSizeW, itemSizeW);
}
//获取系统所有相册
- (void)jcGetAllPhotos
{
    
    //判断是否有访问权限，如果没有访问权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 这里便是无访问权限
        //无权限 做一个友好的提示
        //        UIAlertView * alart = [[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置－隐私－照片”选项中，允许参参访问你的照片。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        alart.tag = 9009;
        //        [alart show];
        self.jcAlert.tag = 1002;
        [self.jcAlert showAlertWithTitle:@"提示" withContent:@"请在iPhone的“设置－隐私－照片”选项中，允许参参访问你的照片" withLeftBtnTitle:@"我知道了"];
        
        return;
    }
    else
    {
        //如果有权限，则获取相册
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        NSMutableArray *jcArr = [NSMutableArray array];
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
            if (([collection.localizedTitle isEqualToString:@"所有照片"]||([collection.localizedTitle isEqualToString:@"相机胶卷"])||([collection.localizedTitle isEqualToString:@"Live Photo"]) ||([collection.localizedTitle isEqualToString:@"屏幕快照"]))) {
                //如果是这种相册，添加
                if ([collection.localizedTitle isEqualToString:@"所有照片"]||[collection.localizedTitle isEqualToString:@"相机胶卷"]) {
                    [jcArr insertObject:collection atIndex:0];
                }
                else
                {
                    [jcArr addObject:collection];
                    
                }
            }
        }];
        
        
        [topLevelUserCollections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
            [jcArr addObject:collection];
            
        }];
        
        self.jcPhotoArr = [NSMutableArray array];
        [jcArr enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:self.options];
            
            NSMutableArray *assetsArray = [[NSMutableArray alloc] init];
            for (PHAsset *asset in assetsFetchResult) {
                if (asset.mediaType == PHAssetMediaTypeImage) {
                    [assetsArray addObject:asset];
                }
            }
            JCPhotoModel * jcPhoto = [JCPhotoModel new];
            jcPhoto.title = collection.localizedTitle;
            jcPhoto.photoAlbumResult = (PHFetchResult*)assetsArray;
            [self.jcPhotoArr addObject:jcPhoto];
            
        }];
        [self.jcPhotoView jcConfigData:self.jcPhotoArr];
        if (self.jcPhotoArr.count>0)
        {
            JCPhotoModel * model = [self.jcPhotoArr objectAtIndex:0];
            self.currentSelectModel = model;
            [self.photoTitleView updateTitleFrameWithTitle:model.title];
            
        }
        
        
        
        
    }
}
#pragma mark -
#pragma mark 如果没有权限，点击确定，走这里
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

//相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        // your codes
        NSLog(@"相册变化了");
        [self jcGetAllPhotos];
        [self jcGetPhotoRequest];
    });
}

#pragma mark -
#pragma mark JCCustomPhotoViewDelegate
- (void)jcCustomPhotoView:(JCCustomPhotoView *)photoView withIndexPath:(NSIndexPath *)indexPath withData:(id)data
{
    JCPhotoModel * model = (JCPhotoModel *)data;
    self.currentSelectModel = model;
    NSLog(@"点击了第%ld个相册   名称是%@",indexPath.row+1,model.title);
    
    [self.photoTitleView updateTitleFrameWithTitle:model.title];
    //如果再次点击，则改变view Frame,让其消失
    [UIView animateWithDuration:0.12 animations:^{
    
        self.jcPhotoView.hidden = YES;
        [self.jcPhotoView jcChangeOldFrame];
    }];
    selectRow = 1;
    self.jcPhotoImgArr = model.photoAlbumResult;
    [self.jcPhotoCollectionView reloadData];
    if (model.photoAlbumResult.count>0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //默认选中第一个图片
            NSIndexPath *defaultSelectRow = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.jcPhotoCollectionView selectItemAtIndexPath:defaultSelectRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self collectionView:self.jcPhotoCollectionView didSelectItemAtIndexPath:defaultSelectRow];
            
        });
        
    }
    
    
    
}

- (void)jcHiddenView
{
    NSString *jcTitle = self.currentSelectModel.title;
    if (jcTitle.length == 0) {
        jcTitle = @"相机胶卷";
    }
    [self.photoTitleView updateTitleFrameWithTitle:jcTitle];
    //如果再次点击，则改变view Frame,让其消失
    [UIView animateWithDuration:0.12 animations:^{
       // self.jcPhotoView.frame = CGRectMake(0, -kScreenHeight-64, kScreenWidth, kScreenHeight-64);
        self.jcPhotoView.hidden = YES;
        [self.jcPhotoView jcChangeOldFrame];
    }];
    
}
#pragma makr -
#pragma mark JCPhotoTitleViewDelegate
- (void)jcPhotoViewOnClick:(JCPhotoTitleView *)jcPhotoView withIsClick:(BOOL)isClick
{
    if (isClick == YES) {
        
        //如果点击，则改变view Frame,让其出现
            self.jcPhotoView.hidden = NO;
            [self.jcPhotoView jcChangeFrame];
        
    }
    else if (isClick == NO)
    {
        //如果再次点击，则改变view Frame,让其消失
        [UIView animateWithDuration:0.12 animations:^{
            //self.jcPhotoView.frame = CGRectMake(0, -kScreenHeight-64, kScreenWidth, kScreenHeight-64);
            self.jcPhotoView.hidden = YES;
            [self.jcPhotoView jcChangeOldFrame];
        }];
    }
}
- (void)jcRightBtnOnClick:(UIBarButtonItem *)sender
{
    NSLog(@"继续");
//    TrainingShareView *jcShareView =[TrainingShareView new];
//    [jcShareView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [jcShareView setContentIcon:@[@"xlwc_share_wechat",@"xlwc_share_wechatmoments",@"xlwc_share_qq",@"xlwc_share_weibo",@"xlwc_share_qzone"] iconName:@[@"微信",@"朋友圈",@"QQ",@"微博",@"QQ空间"]];
//    jcShareView.delegate =self;
//    [[UIApplication sharedApplication].keyWindow addSubview:jcShareView];
//    return;
    if (self.jcPhotoImgArr.count==0) {
        //如果图片数据为空，则不进行跳转
        return;
    }
    JCImageFiterViewController *jcFiterVC = [JCImageFiterViewController new];
    UIImage *jcImg = [self.jcPhotoSelctionHeader.imgSelectShowView jcGetImage];
    jcFiterVC.fromViewController = @"100";
    jcFiterVC.jcImg = jcImg;
    [self.navigationController pushViewController:jcFiterVC animated:YES];
}


#pragma mark -
#pragma mark TrainingShareViewDelegate
-(void)shareIndex:(NSInteger)shareIndex{
    
    
    switch (shareIndex) {
        case 1000:{//微信
          /*
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [JCShareObject jcGetSocialWebObjectWithDynModel:self.currentModel];
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    
                    NSString *userInfoMess =error.userInfo[@"message"];
                    if ([userInfoMess isEqualToString:@"APP Not Install"]) {//表示手机上没有安装app
                        
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%8F%82%E5%8F%82-%E5%AD%A9%E5%AD%90%E4%BD%93%E6%80%81%E5%81%A5%E5%BA%B7%E5%8A%A9%E6%89%8B/id1196645318?mt=8"]];
                    }
                    else
                    {
                        [ToolsHelper jcShowCustomTipViewWithImgName:@"send_failure.png" withTitle:@"分享失败" withAfterDelay:1.5];
                        
                        
                    }
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        
                        
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                    [ToolsHelper jcShowCustomTipViewWithImgName:@"send_succeed.png" withTitle:@"分享成功" withAfterDelay:1.5];
                }
                
            }];
            
            */
            
            break;
            
            
        }
            
            
        case 1001:{//朋友圈
            
            /*
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [JCShareObject jcGetSocialWebObjectWithDynModel:self.currentModel];
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    
                    NSString *userInfoMess =error.userInfo[@"message"];
                    if ([userInfoMess isEqualToString:@"APP Not Install"]) {//表示手机上没有安装app
                        
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%8F%82%E5%8F%82-%E5%AD%A9%E5%AD%90%E4%BD%93%E6%80%81%E5%81%A5%E5%BA%B7%E5%8A%A9%E6%89%8B/id1196645318?mt=8"]];
                    }
                    else
                    {
                        [ToolsHelper jcShowCustomTipViewWithImgName:@"send_failure.png" withTitle:@"分享失败" withAfterDelay:1.5];
                        
                        
                    }
                    
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                    [ToolsHelper jcShowCustomTipViewWithImgName:@"send_succeed.png" withTitle:@"分享成功" withAfterDelay:1.5];
                }
                
            }];
            */
            
            break;
        }
            
            
        case 1002:{//QQ
            
            /*
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [JCShareObject jcGetSocialWebObjectWithDynModel:self.currentModel];
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    
                    NSString *userInfoMess =error.userInfo[@"message"];
                    if ([userInfoMess isEqualToString:@"APP Not Install"]) {//表示手机上没有安装app
                        
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%8F%82%E5%8F%82-%E5%AD%A9%E5%AD%90%E4%BD%93%E6%80%81%E5%81%A5%E5%BA%B7%E5%8A%A9%E6%89%8B/id1196645318?mt=8"]];
                    }
                    else
                    {
                        [ToolsHelper jcShowCustomTipViewWithImgName:@"send_failure.png" withTitle:@"分享失败" withAfterDelay:1.5];
                        
                        
                    }
                    
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                    [ToolsHelper jcShowCustomTipViewWithImgName:@"send_succeed.png" withTitle:@"分享成功" withAfterDelay:1.5];
                }
                
            }];
            */
            
            
            break;
            
        }
            
        case 1003:{//微博
            
            
            /*
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [JCShareObject jcGetSocialWebObjectWithDynModel:self.currentModel];
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    
                    NSString *userInfoMess =error.userInfo[@"message"];
                    if ([userInfoMess isEqualToString:@"APP Not Install"]) {//表示手机上没有安装app
                        
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%8F%82%E5%8F%82-%E5%AD%A9%E5%AD%90%E4%BD%93%E6%80%81%E5%81%A5%E5%BA%B7%E5%8A%A9%E6%89%8B/id1196645318?mt=8"]];
                    }
                    else
                    {
                        [ToolsHelper jcShowCustomTipViewWithImgName:@"send_failure.png" withTitle:@"分享失败" withAfterDelay:1.5];
                        
                        
                    }
                    
                    
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                    [ToolsHelper jcShowCustomTipViewWithImgName:@"send_succeed.png" withTitle:@"分享成功" withAfterDelay:1.5];
                }
                
            }];
            
            */
            
            
            
            break;
            
            
        }
            
            
        case 1004:{//取消
            
            
            break;
        }
            
            
            
            
    }
    
    
    
}

- (JCCustomPhotoView *)jcPhotoView
{
    if (!_jcPhotoView) {
        
//        _jcPhotoView = [[JCCustomPhotoView alloc]initWithFrame:CGRectMake(0, -kScreenHeight-64, kScreenWidth, kScreenHeight-64)];
        _jcPhotoView = [[JCCustomPhotoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];

        _jcPhotoView.delegate = self;
        
    }
    return _jcPhotoView;
    
}
- (JCImageSelectShowView *)imgSelectShowView
{
    if (!_imgSelectShowView) {
        
        _imgSelectShowView = [[JCImageSelectShowView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        _imgSelectShowView.backgroundColor = [UIColor whiteColor];
    }
    return _imgSelectShowView;
}
- (JCPhotoTitleView *)photoTitleView
{
    if (!_photoTitleView) {
        
        _photoTitleView = [[JCPhotoTitleView alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
        _photoTitleView.delegate = self;
        
    }
    return _photoTitleView;
}
- (void)jcLeftOnClick:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (PHFetchOptions *)options {
    if (!_options) {
        _options = [[PHFetchOptions alloc] init];
        _options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    }
    return _options;
}
- (JCCustomAlert *)jcAlert
{
    if (!_jcAlert) {
        
        _jcAlert = [[JCCustomAlert alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _jcAlert.delegate = self;
    }
    return _jcAlert;
}
- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}
#pragma mark -
#pragma mark JCCustomAlertDelegate
- (void)jcCustomAlertOnClick:(JCCustomAlert*)alertView withClickIndex:(NSInteger)index
{
    [self.jcAlert jcDismissAlert];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

@end
