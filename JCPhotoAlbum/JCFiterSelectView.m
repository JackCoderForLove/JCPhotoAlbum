//
//  JCFiterSelectView.m
//  CanCan
//  自定义选择参参滤镜参参贴纸选择器
//  Created by xingjian on 2017/8/16.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCFiterSelectView.h"

@interface JCFiterSelectView()
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIView   *bottomLine;
@property (nonatomic,strong)UIButton  *lastBtn;
@end

@implementation JCFiterSelectView

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
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self addSubview:self.bottomLine];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(87/2.0);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(87/2.0);
        make.left.mas_equalTo(self.leftBtn.mas_right);
        make.top.mas_equalTo(self.mas_top);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(0.5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top);
        
    }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)jcConfigTitleViewWithData:(NSArray *)titleArr
{
    
    if (titleArr.count == 2) {
        
        NSString *leftTitle = titleArr[0];
        NSString *rightTitle = titleArr[1];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        //配置完之后，默认调用选中第一个按钮，默认为选中状态
        
        [self jcBtnOnClick:self.leftBtn];
        self.lastBtn = self.leftBtn;
        
    }
}
- (void)jcSelectIndex:(NSInteger)index
{
    if (index == 0) {
        self.lastBtn = self.leftBtn;
        [UIView animateWithDuration:0.05 animations:^{
            [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(80/2);
                make.height.mas_equalTo(6/2);
                make.centerX.mas_equalTo(self.leftBtn.mas_centerX);
                make.bottom.mas_equalTo(self.mas_bottom);
                
            }];
    
            
        }];
        
    }
    else if (index == 1)
    {
        self.lastBtn = self.rightBtn;
        [UIView animateWithDuration:0.05 animations:^{
            [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(80/2);
                make.height.mas_equalTo(6/2);
                make.centerX.mas_equalTo(self.rightBtn.mas_centerX);
                make.bottom.mas_equalTo(self.mas_bottom);
            }];
      
            
        }];
    }
}


- (void)jcBtnOnClick:(UIButton *)sender
{
    if (self.lastBtn.tag == sender.tag) {
        return;
    }
    if (sender.tag == 1000) {
       
        [self changeSelectState:self.leftBtn];
        [self changeNormalState:self.rightBtn];
        
    }
    else if (sender.tag == 1001)
    {
        
        [self changeSelectState:self.rightBtn];
        [self changeNormalState:self.leftBtn];
    }
    self.lastBtn = sender;
    if ([self.delegate respondsToSelector:@selector(jcFiterSelect:withIndex:)]) {
        [self.delegate jcFiterSelect:self withIndex:sender.tag-1000];
    }
    
}
//将按钮置为普通状态
- (void)changeNormalState:(UIButton *)sender
{
 
    [sender setTitleColor:[ToolsHelper colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    sender.backgroundColor = [ToolsHelper colorWithHexString:@"#F7F7F7"];
}
//将按钮置为选中状态
- (void)changeSelectState:(UIButton *)sender
{
    [sender setTitleColor:[ToolsHelper colorWithHexString:@"#00C594"] forState:UIControlStateNormal];
    sender.backgroundColor = [ToolsHelper colorWithHexString:@"#FFFFFF"];
}
- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftBtn addTarget:self action:@selector(jcBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setTitleColor:[ToolsHelper colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _leftBtn.backgroundColor = [ToolsHelper colorWithHexString:@"#F7F7F7"];
        _leftBtn.tag = 1000;
    }
    return _leftBtn;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn addTarget:self action:@selector(jcBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitleColor:[ToolsHelper colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _rightBtn.backgroundColor = [ToolsHelper colorWithHexString:@"#F7F7F7"];
        _rightBtn.tag = 1001;
    }
    return _rightBtn;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [ToolsHelper colorWithHexString:@"#DEDFE0"];
    }
    return _bottomLine;
}
@end
