//
//  JCImageZoomViewController.m
//  CanCan
//  图片展示器
//  Created by xingjian on 2017/8/10.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCImageZoomViewController.h"

@interface JCImageZoomViewController ()<UIScrollViewDelegate>

{
    UIButton *rightBarItem;
}
@property (nonatomic,strong)UIImageView  *jcImgView;
@property (nonatomic,strong)UIView  *imgContentView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,assign)BOOL zoomOut_In;

@end

@implementation JCImageZoomViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =NO;
    //防止来自推送导航条颜色改变
    [self.navigationController.navigationBar setBackgroundColor:[ToolsHelper colorWithHexString:@"#101413"]];
    [self.navigationController.navigationBar setBarTintColor:[ToolsHelper colorWithHexString:@"#101413"]];
   
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutNavigationBar];
    [self jcConfigZoomView];
    self.scrollview.zoomScale = 1.0;
    //self.jcImgView.image = [ToolsHelper imageCompressForSize:self.jcFinishImg targetSize:CGSizeMake(kScreenWidth, kScreenWidth)];
//    self.jcImgView.image = self.jcFinishImg;
//    [self.view addSubview:self.imgContentView];
//    [self.imgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(kScreenWidth);
//        make.top.mas_equalTo(self.view);
//        make.left.mas_equalTo(self.view);
//    }];
//    [self.imgContentView addSubview:self.jcImgView];
//    [self.jcImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self.jcFinishImg.size.width);
//        make.height.mas_equalTo(self.jcFinishImg.size.height);
//        make.center.mas_equalTo(self.imgContentView);
//    }];
//    
    
    // Do any additional setup after loading the view.
}

- (void)jcConfigZoomView
{
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0,kScreenWidth, kScreenHeight-64)];
    _scrollview.backgroundColor = [ToolsHelper colorWithHexString:@"#101413"];
    _scrollview.delegate = self;
    [self.view addSubview:_scrollview];
    
    
    float width =  self.jcFinishImg.size.width;
    float height = self.jcFinishImg.size.height;
    float x=(_scrollview.frame.size.width-width)/2;
    float y=(_scrollview.frame.size.height-height)/2;

    _imageView = [[UIImageView alloc] initWithImage:self.jcFinishImg];
    [_imageView setFrame:CGRectMake(x, y, width, height)];
    [_scrollview addSubview:_imageView];
    
    [_scrollview setContentSize:self.imageView.size];//_scrollview可以拖动的范围

    
    UITapGestureRecognizer* tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)];//给imageview添加tap手势
    tap.numberOfTapsRequired = 2;//双击图片执行tapGesAction
    _imageView.userInteractionEnabled=YES;
    [_imageView addGestureRecognizer:tap];
    
    [_scrollview setMinimumZoomScale:0.5];//设置最小的缩放大小
    _scrollview.maximumZoomScale = 2.0;//设置最大的缩放大小
    
    _zoomOut_In = YES;//控制点击图片放大或缩小
}

- (void)layoutNavigationBar
{
    rightBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarItem.frame = CGRectMake(0, 0, 20, 42);
    [rightBarItem setImage:[UIImage imageNamed:@"jc_ZoomImg_delete"] forState:UIControlStateNormal];
    [rightBarItem addTarget:self action:@selector(jcDeleteImg:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarItem];
}


-(void)tapGesAction:(UIGestureRecognizer*)gestureRecognizer//手势执行事件
{
    float newscale=0.0;
    if (_zoomOut_In) {
        newscale = 2*1.5;
        _zoomOut_In = NO;
    }else
    {
        newscale = 1.0;
        _zoomOut_In = YES;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
    [ _scrollview zoomToRect:zoomRect animated:YES];//重新定义其cgrect的x和y值
    
}
//当UIScrollView尝试进行缩放的时候调用
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

//当正在缩放的时候调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
        CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
        //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
        xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
        ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
        [self.imageView setCenter:CGPointMake(xcenter, ycenter)];

}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
    zoomRect.size.height = [_scrollview frame].size.height / scale;
    zoomRect.size.width  = [_scrollview frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
- (void)jcDeleteImg:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jcDeleteImg" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundColor:[ToolsHelper colorWithHexString:@"#3FD2A0"]];
    [self.navigationController.navigationBar setBarTintColor:[ToolsHelper colorWithHexString:@"#3FD2A0"]];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSArray<id<UIViewControllerPreviewingDelegate>> *)previewActionItems
{
   
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"点赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"评论" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    UIPreviewActionGroup *actionGroup = [UIPreviewActionGroup actionGroupWithTitle:@"包子组" style:UIPreviewActionStyleDefault actions:@[action1, action2]];

    return @[action1, action2, action3, actionGroup];
 
    
}

- (UIView *)imgContentView
{
    if (!_imgContentView) {
        
        _imgContentView = [UIView new];
        _imgContentView.backgroundColor = [UIColor whiteColor];
    }
    return _imgContentView;
}
- (UIImageView *)jcImgView
{
    if (!_jcImgView) {
        
        
        _jcImgView = [UIImageView new];
        _jcImgView.contentMode = UIViewContentModeCenter;
        
    }
    return _jcImgView;
}


@end
