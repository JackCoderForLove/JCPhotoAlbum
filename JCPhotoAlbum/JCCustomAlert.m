//
//  JCCustomAlert.m
//  CanCan
//
//  Created by xingjian on 2017/7/12.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCCustomAlert.h"

@interface JCCustomAlert ()
@property (nonatomic,strong)UIView  *contentView;
@property (nonatomic,strong)UILabel *tipLab;
@property (nonatomic,strong)UILabel *contentLab;
@property (nonatomic,strong)UILabel *line1;
@property (nonatomic,strong)UILabel *line2;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@end

@implementation JCCustomAlert
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
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;

}
//展示标题文字
- (void)showAlertWithTitle:(NSString *)title withContent:(NSString *)content withLeftBtnTitle:(NSString *)leftTitle withRightBtnTitle:(NSString *)rightTitle
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(560/2);
        make.height.mas_equalTo(300/2);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.contentView addSubview:self.tipLab];
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
    self.contentLab.numberOfLines = 0;
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(36/2);
        make.width.mas_equalTo(self.contentView.mas_width);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.height.mas_equalTo(15);
    }];
    if (title.length==0||title==nil) {
        
        CGSize jcContentSize = [ToolsHelper sizeWithText:content font:[UIFont systemFontOfSize:16] maxW:560/2-40];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset((205/2-jcContentSize.height-1)/2);
            make.left.mas_equalTo(self.contentView.mas_left).offset((560/2-jcContentSize.width)/2);
            make.width.mas_equalTo(jcContentSize.width+0.4);
            make.height.mas_equalTo(jcContentSize.height+0.4);
        }];

    }
    else
    {
        CGSize jcContentSize = [ToolsHelper sizeWithText:content font:[UIFont systemFontOfSize:16] maxW:560/2-40];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLab.mas_bottom).offset((130/2-jcContentSize.height-1)/2);
            make.left.mas_equalTo(self.contentView.mas_left).offset((560/2-jcContentSize.width)/2);
            make.width.mas_equalTo(jcContentSize.width+0.4);
            make.height.mas_equalTo(jcContentSize.height+0.4);
        }];

    }
 
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((560/2-1.0/2)/2);
        make.height.mas_equalTo(99/2.0);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1/2.0);
        make.height.mas_equalTo(99/2.0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.leftBtn.mas_right);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((560/2-1.0/2)/2);
        make.height.mas_equalTo(99/2.0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);

    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.leftBtn.mas_top);
        make.width.mas_equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(1/2.0);
    }];
    self.tipLab.text = title;
    self.contentLab.text = content;
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    if (title.length == 0||title == nil)
    {
        
        [self.rightBtn setTitleColor:[ToolsHelper colorWithHexString:@"#333333"] forState:UIControlStateNormal];

    }
    else
    {
        [_rightBtn setTitleColor:[ToolsHelper colorWithHexString:@"#00c594"] forState:UIControlStateNormal];

    }
    
    


}
//展示标题文字
- (void)showAlertWithTitle:(NSString *)title withContent:(NSString *)content withLeftBtnTitle:(NSString *)leftTitle
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(560/2);
        make.height.mas_equalTo(300/2);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.contentView addSubview:self.tipLab];
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.leftBtn];
   // [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.line1];
  //  [self.contentView addSubview:self.line2];
    self.contentLab.numberOfLines = 0;
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(36/2);
        make.width.mas_equalTo(self.contentView.mas_width);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.height.mas_equalTo(15);
    }];
    CGSize jcContentSize = [ToolsHelper sizeWithText:content font:[UIFont systemFontOfSize:16] maxW:560/2-40];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLab.mas_bottom).offset((130/2-jcContentSize.height-1)/2);
        make.left.mas_equalTo(self.contentView.mas_left).offset((560/2-jcContentSize.width)/2);
        make.width.mas_equalTo(jcContentSize.width+0.4);
        make.height.mas_equalTo(jcContentSize.height+0.4);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(560/2.0);
        make.height.mas_equalTo(99/2.0);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
//    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(1/2.0);
//        make.height.mas_equalTo(99/2.0);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom);
//        make.left.mas_equalTo(self.leftBtn.mas_right);
//    }];
//    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo((560/2-1.0/2)/2);
//        make.height.mas_equalTo(99/2.0);
//        make.right.mas_equalTo(self.contentView.mas_right);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom);
//        
//    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.leftBtn.mas_top);
        make.width.mas_equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(1/2.0);
    }];
    self.tipLab.text = title;
    self.contentLab.text = content;
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
   // [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    
    
    
    
}
//取消alert
- (void)jcDismissAlert
{
    [self.tipLab removeFromSuperview];
    [self.contentLab removeFromSuperview];
    [self.leftBtn removeFromSuperview];
    [self.rightBtn removeFromSuperview];
    [self.line1 removeFromSuperview];
    [self.line2 removeFromSuperview];
    [self removeFromSuperview];
    
}

- (void)jcClick:(UIButton *)sender
{
    NSInteger index = sender.tag-1000;
    if ([self.delegate respondsToSelector:@selector(jcCustomAlertOnClick:withClickIndex:)]) {
        [self.delegate jcCustomAlertOnClick:self withClickIndex:index];
    }
}
- (UIView *)contentView
{
    if (!_contentView) {
        
        _contentView = [UIView new];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10.0f;
        _contentView.backgroundColor = [ToolsHelper colorWithHexString:@"#ffffff"];
    }
    return _contentView;
}

- (UILabel *)tipLab
{
    if (!_tipLab) {
        
        _tipLab = [UILabel new];
        _tipLab.font = [UIFont systemFontOfSize:15];
        _tipLab.textColor = [ToolsHelper colorWithHexString:@"#333333"];
        _tipLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLab;
}
- (UILabel *)contentLab
{
    if (!_contentLab) {
        
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:16];
        _contentLab.textColor = [ToolsHelper colorWithHexString:@"#333333"];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}
- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitleColor:[ToolsHelper colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _leftBtn.tag = 1000;
        [_leftBtn addTarget:self action:@selector(jcClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:[ToolsHelper colorWithHexString:@"#00c594"] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _rightBtn.tag = 1001;
        [_rightBtn addTarget:self action:@selector(jcClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (UILabel *)line1
{
    if (!_line1) {
        
        _line1 = [UILabel new];
        _line1.backgroundColor = [ToolsHelper colorWithHexString:@"#DEDFE0"];
    }
    return _line1;
}
- (UILabel *)line2
{
    if (!_line2) {
        
        _line2 = [UILabel new];
        _line2.backgroundColor = [ToolsHelper colorWithHexString:@"#DEDFE0"];
    }
    return _line2;
}


- (void)drawRect:(CGRect)rect
{
    
    //中间镂空的圆角矩形
    CGRect myRect =CGRectMake((kScreenWidth-560/2)/2,(kScreenHeight-300/2)/2,560/2,300/2);
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:10];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.3;
    [self.layer addSublayer:fillLayer];
    
    [[UIColor colorWithWhite:0 alpha:0.3] setFill];
}

@end
