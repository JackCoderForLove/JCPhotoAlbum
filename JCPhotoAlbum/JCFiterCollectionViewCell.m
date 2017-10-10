//
//  JCFiterCollectionViewCell.m
//  CanCan
//  滤纸自定义网格cell
//  Created by xingjian on 2017/8/15.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCFiterCollectionViewCell.h"
#import "JCFiterModel.h"
#import "CIFilter+JCCustomFilter.h"

@interface JCFiterCollectionViewCell()

@property(nonatomic,strong)UIImageView  *jcFiterImg;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImage  *originImg;
@property(nonatomic,strong)UIView *blurView;
@property(nonatomic,strong)JCFiterModel *stModel;

@end
@implementation JCFiterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        
        return nil;
    }
    [self layoutMyUI];
    return self;
}


- (void)layoutMyUI
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    [self addSubview:self.jcFiterImg];
    [self addSubview:self.blurView];
    [self addSubview:self.titleLab];
    [self.jcFiterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(216/2);
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
    }];
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(216/2);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);

    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(216/2);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
}
- (void)jcConfigData:(JCFiterModel *)model withIndexPath:(NSIndexPath *)indexPath withOriginImg:(UIImage *)originImg
{
    self.stModel = model;
    self.titleLab.text = model.fiterName;
    UIImage *jcImg = [CIFilter filterEvent:model.fiterGpuName originImage:originImg];
    UIImage *finishImg = [ToolsHelper imageCompressForSize:jcImg targetSize:CGSizeMake(300, 300)];
    self.jcFiterImg.image = finishImg;
}
- (void)jcChangeNormalState
{
   
    self.layer.borderColor = [ToolsHelper colorWithHexString:@"#ffffff"].CGColor;
    self.layer.borderWidth = 0.0f;
    self.titleLab.textColor = [ToolsHelper colorWithHexString:@"#ffffff"];
}
- (void)jcChangeSelectState
{
    self.layer.borderColor = [ToolsHelper colorWithHexString:@"#3FD2A0"].CGColor;
    self.layer.borderWidth = 1.0f;
    self.titleLab.textColor = [ToolsHelper colorWithHexString:@"#00C594"];

}
- (UIView *)blurView
{
    if (!_blurView) {
        
        _blurView = [UIView new];
        _blurView.backgroundColor = [ToolsHelper colorWithHexString:@"000000" alpha:0.1];
    }
    return _blurView;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:11];
        _titleLab.textColor = [ToolsHelper colorWithHexString:@"#ffffff"];
        _titleLab.text = @"原图";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIImageView *)jcFiterImg
{
    if (!_jcFiterImg) {
        
        _jcFiterImg = [UIImageView new];
        _jcFiterImg.image = [UIImage imageNamed:@"jc.jpg"];
        //_jcFiterImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _jcFiterImg;
}
@end
