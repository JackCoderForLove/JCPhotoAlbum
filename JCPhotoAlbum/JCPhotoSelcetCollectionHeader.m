//
//  JCPhotoSelcetCollectionHeader.m
//  CanCan
//  相机胶卷图片选择自定义headerView
//  Created by xingjian on 2017/9/4.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCPhotoSelcetCollectionHeader.h"
@interface JCPhotoSelcetCollectionHeader()


@end

@implementation JCPhotoSelcetCollectionHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        
        return nil;
    }
    [self jcLayoutMyUI];
    return self;
}
-(void)jcLayoutMyUI
{
    [self addSubview:self.imgSelectShowView];
}
- (JCImageSelectShowView *)imgSelectShowView
{
    if (!_imgSelectShowView) {
        
        _imgSelectShowView = [[JCImageSelectShowView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        _imgSelectShowView.backgroundColor = [UIColor whiteColor];
    }
    return _imgSelectShowView;
}

@end
