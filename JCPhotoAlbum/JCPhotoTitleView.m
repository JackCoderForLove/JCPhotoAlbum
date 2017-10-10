//
//  JCPhotoTitleView.m
//  CanCan
//  自定义相册选择titleView
//  Created by xingjian on 2017/8/11.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCPhotoTitleView.h"
#define jcKW 180
#define jcKH 44
#define jcKImgW 14
#define jcKImgH 8.5
#define jcKSpace 4
#define jcKDefault 80

@interface JCPhotoTitleView()
{
    BOOL  isClick;
}
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel  *titleLab;
@property (nonatomic,strong)UIButton *titleBtn;
@end
@implementation JCPhotoTitleView
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
    [self addSubview:self.titleLab];
    [self addSubview:self.imgView];
    [self addSubview:self.titleBtn];
    CGFloat jcX = (jcKW-jcKImgW-jcKSpace-jcKDefault)/2;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(jcKDefault);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.mas_left).offset(jcX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(jcKImgW);
        make.height.mas_equalTo(jcKImgH);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.titleLab.mas_right).offset(jcKSpace);
    }];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(jcKW);
        make.height.mas_equalTo(jcKH);
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
}
- (void)jcConfigTitle:(NSString *)title
{
 
    self.titleLab.text = title;
    //更新位置
    [self updateTitleFrameWithTitle:title];
}
- (void)updateTitleFrameWithTitle:(NSString*)title
{
    
    isClick = NO;
    //如果是点击状态
    self.imgView.image = [UIImage imageNamed:@"drop_down-down"];
    self.titleLab.text = title;
    //更新frame
    CGFloat titleW = [ToolsHelper sizeWithText:title font:[UIFont systemFontOfSize:17] maxW:jcKW-jcKSpace-jcKImgW].width+1;
    CGFloat jcX = (jcKW-jcKImgW-jcKSpace-titleW)/2;
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleW);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.mas_left).offset(jcX);
        make.centerY.mas_equalTo(self.mas_centerY);

    }];

    
}


- (void)jcTitleBtnOnClick:(UIButton *)sender
{
    if (isClick == NO) {
     //如果是未点击状态，则三角形180度旋转
        self.imgView.image = [UIImage imageNamed:@"drop_down_up"];
        
    }
    else if (isClick == YES)
    {
        //如果是点击状态
        self.imgView.image = [UIImage imageNamed:@"drop_down-down"];
    }
    isClick = !isClick;
    if ([self.delegate respondsToSelector:@selector(jcPhotoViewOnClick:withIsClick:)]) {
        [self.delegate jcPhotoViewOnClick:self withIsClick:isClick];
    }
}
- (UIImageView *)imgView{
    if (!_imgView) {
        
        
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"drop_down-down"];
    }
    return _imgView;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.text = @"相机胶卷";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
- (UIButton *)titleBtn
{
    if (!_titleBtn) {
        
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.backgroundColor = [UIColor clearColor];
        [_titleBtn addTarget:self action:@selector(jcTitleBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}
@end
