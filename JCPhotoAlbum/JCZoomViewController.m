//
//  JCZoomViewController.m
//  JCPhotoAlbum
//
//  Created by xingjian on 2017/9/19.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCZoomViewController.h"

@interface JCZoomViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation JCZoomViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =YES;
    //防止来自推送导航条颜色改变
    [self.navigationController.navigationBar setBackgroundColor:[ToolsHelper colorWithHexString:@"#3FD2A0"]];
    [self.navigationController.navigationBar setBarTintColor:[ToolsHelper colorWithHexString:@"#3FD2A0"]];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image = self.jcFinishImg;
    [self.view addSubview:_imageView];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *jcTT = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jcTap:)];
    [_imageView addGestureRecognizer:jcTT];

    // Do any additional setup after loading the view.
}
- (void)jcTap:(UITapGestureRecognizer *)jcTap
{
    self.navigationController.navigationBarHidden =NO;
    [self.navigationController popViewControllerAnimated:NO];
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden =NO;
    [self.navigationController.navigationBar setBackgroundColor:[ToolsHelper colorWithHexString:@"#3FD2A0"]];
    [self.navigationController.navigationBar setBarTintColor:[ToolsHelper colorWithHexString:@"#3FD2A0"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
