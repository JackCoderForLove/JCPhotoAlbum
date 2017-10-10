//
//  TodayViewController.m
//  JCPhotoAlbumWidget
//
//  Created by xingjian on 2017/9/19.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <Masonry/Masonry.h>


//获取物理屏幕的尺寸
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface TodayViewController () <NCWidgetProviding>
@property(nonatomic,strong)UIImageView *jcImgView;
@end

@implementation TodayViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}


- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
        [self.jcImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(100);
            make.center.mas_equalTo(self.view);
        }];

    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.jcImgView.image.size.height+20);
        [self.jcImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(self.jcImgView.image.size.height);
            make.center.mas_equalTo(self.view);
        }];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.jcImgView];
    [self.jcImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(100);
        make.center.mas_equalTo(self.view);
    }];
    // Do any additional setup after loading the view from its nib.
}
- (void)jcTap:(UITapGestureRecognizer *)jctap
{
    NSLog(@"点击手势，瓦力，瓦力，哇");
    NSURL *pjURL = [NSURL URLWithString:@"JCWidget://"];
    [self.extensionContext openURL:pjURL completionHandler:nil];
}
- (UIImageView *)jcImgView
{
    if (!_jcImgView) {
        
        _jcImgView = [UIImageView new];
        _jcImgView.contentMode = UIViewContentModeScaleAspectFill;
        _jcImgView.image = [UIImage imageNamed:@"1.jpg"];
        _jcImgView.layer.masksToBounds = YES;
        _jcImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *jcTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jcTap:)];
        [_jcImgView addGestureRecognizer:jcTap];
    }
    return _jcImgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
