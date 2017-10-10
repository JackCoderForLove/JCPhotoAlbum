//
//  JCNavViewController.m
//  JCPhotoAlbum
//
//  Created by xingjian on 2017/9/14.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCNavViewController.h"

@interface JCNavViewController ()

@end

@implementation JCNavViewController
+ (void)initialize
{
    if (self == [JCNavViewController class]) {
        
        [self customNavigationControllerSetNavAppearance];
        
    }
}
#pragma mark -- 设置全导航条
+ (void)customNavigationControllerSetNavAppearance
{
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[JCNavViewController class], nil];
    //设置导航条颜色
    [bar setBarTintColor:[ToolsHelper colorWithHexString:@"#3FD2A0"]];
    [bar setTranslucent:NO];
    
    NSDictionary *titleDic = @{
                               NSForegroundColorAttributeName : [ToolsHelper colorWithHexString:@"#ffffff"],
                               NSFontAttributeName : [UIFont boldSystemFontOfSize:36/2.0]
                               };
    
    //bar.alpha = 0.5;
    [bar setTitleTextAttributes:titleDic];
    
    
    
    [bar setBackgroundImage:[UIImage new]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
    
    
    
    
    
}
#pragma mark -- 设置全局的UIBarButton外观

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    NSLog(@"UIViewController is %@  count :%ld",viewController,self.viewControllers.count);
    
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
