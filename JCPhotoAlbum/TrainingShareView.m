//
//  TrainingShareView.m
//  CanCan
//
//  Created by xiaolong li on 16/12/21.
//  Copyright © 2016年 xingjian. All rights reserved.
//

#import "TrainingShareView.h"

@implementation TrainingShareView

{
    
    UIView *bgView;
    UIView *contentView;
    UIView *lineView;
    UIButton *cancelBtn;
    
    NSArray *iconArr;
    NSArray *nameArr;
    NSMutableArray *jcBtnArr;
    NSMutableArray *jcLabelArr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        iconArr =[NSArray new];
        nameArr =[NSArray new];
        jcBtnArr = [NSMutableArray array];
        jcLabelArr = [NSMutableArray array];
        
    }
    return self;
}

//需要分享图标  分享名称
- (void)setContentIcon:(NSArray *)_iconArr iconName:(NSArray *)_nameArr{
    
    iconArr =_iconArr;
    nameArr =_nameArr;
    
    [self setUserInteractionEnabled:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    
    bgView =[UIView new];
    [bgView setFrame:[[UIScreen mainScreen] bounds]];
    [bgView setBackgroundColor:[[ToolsHelper colorWithHexString:@"#000000"] colorWithAlphaComponent:0.5]];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundEvent:)];
    [bgView addGestureRecognizer:tap];
    
    [self addSubview:bgView];
    
    contentView =[UIView new];
    [contentView setFrame:CGRectMake(0, self.frame.size.height-(62+61+18+22+62+1+100+61+18+22+62)/2.0, kScreenWidth,(62+61+18+22+62+1+100+61+18+22+62)/2.0)];
    [contentView setBackgroundColor:[ToolsHelper colorWithHexString:@"#ffffff"]];
    [bgView addSubview:contentView];
    
    
    // ------View出现动画
    contentView.transform = CGAffineTransformMakeTranslation(0.01, (62+61+18+22+62+1+100+61+18+22+62)/2.0);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);

    }];
    
    
    
    NSLog(@"iconArr.count :%lf",ceil(iconArr.count/2.0));
    
    
    
   
        
       //左右间距 (kScreenWidth-62-4*61)/3.0
       //上下间距 62
        
        
    //左右间距 (kScreenWidth-62-4*61)/3.0
    //上下间距 62
    
   
    
    CGFloat jcFirstRowY = 62/2.0;
    CGFloat jcSecondRowY = (62+61+18+22+62)/2.0;
    CGFloat jcY = 0.0;
    NSInteger jcRow;
    CGFloat jcSpaceX1 = 60/2.0;
    CGFloat jcSpaceX2 = (kScreenWidth-60-40*4)/3.0;
    for (NSInteger j=0;j<iconArr.count; j++) {
        
        // x 60+j*(w+w1)
        
        // y 59+i*(w+w1)  68 61
        jcRow = j/4;
        if (jcRow == 0) {
            //如果是第一行
            jcY = jcFirstRowY;
        }
        else if (jcRow == 1)
        {
            jcY = jcSecondRowY;
        }
        UIButton *iconBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setFrame:CGRectMake(jcSpaceX1+j%4*(80/2.0+jcSpaceX2),jcY,80/2.0, (61+40)/2.0)];
        
        iconBtn.tag =1000+j;
        [iconBtn addTarget:self action:@selector(shareActionEvent:) forControlEvents:UIControlEventTouchUpInside];
        [iconBtn setImage:[UIImage imageNamed:iconArr[j]] forState:UIControlStateNormal];
        iconBtn.imageView.contentMode = UIViewContentModeCenter;
        [iconBtn setTitle:[nameArr objectAtIndex:j] forState:UIControlStateNormal];
        [iconBtn setTitleColor:[ToolsHelper colorWithHexString:@"#444444"] forState:UIControlStateNormal];
        UIImage *jcImg = [UIImage imageNamed:iconArr[j]];
        CGFloat  jcW = jcImg.size.width;
        iconBtn.titleLabel.font = [UIFont systemFontOfSize:22/2.0];
        iconBtn.titleEdgeInsets = UIEdgeInsetsMake((61+18)/2, -iconBtn.imageView.bounds.size.width, 0, 0);
        iconBtn.imageEdgeInsets = UIEdgeInsetsMake(0, (40-jcW)/2.0, 40/2.0, 0);
        [contentView addSubview:iconBtn];
        [jcBtnArr addObject:iconBtn];
        
                if (j==iconArr.count-1) {
                    
                    lineView =[UIView new];
                    [lineView setFrame:CGRectMake(0,iconBtn.frame.origin.y+iconBtn.frame.size.height+62/2.0, kScreenWidth, 1/2.0)];
                    [lineView setBackgroundColor:[ToolsHelper colorWithHexString:@"#dedfe0"]];
                    
                }
                
                [contentView addSubview:lineView];
        
        }
    
            
            
    
    cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, lineView.frame.origin.y+lineView.frame.size.height, kScreenWidth, contentView.frame.size.height-(lineView.frame.origin.y+lineView.frame.size.height))];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[ToolsHelper colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:30/2.0]];
    [cancelBtn setTag:1004];
    [cancelBtn addTarget:self action:@selector(cancelActionEvent:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    [self moveInAnimation];
    
    
    
}

- (void)jcHide{
    [TrainingShareView hideWithView:self];
}

+ (void)hideWithView:(UIView *)view{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view fadeOutWithTime:0.35];
    });
}
- (void)removeAnimation{
    
    self.superview.superview.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [lineView fadeOutWithTime:0.15];
        [cancelBtn fadeOutWithTime:0.15];
      
        
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
          [self jcCancelUI];
    });
   
    [jcBtnArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * btn = obj;
        CGRect jcFrame = [btn.superview convertRect:btn.frame fromView:self];
        CGFloat x = jcFrame.origin.x;
        CGFloat y = jcFrame.origin.y;
        
        CGFloat width = btn.frame.size.width;
        CGFloat height = btn.frame.size.height;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((jcBtnArr.count - idx) * 0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.5 delay:0.03 usingSpringWithDamping:0.9 initialSpringVelocity:5 options:0 animations:^{
                btn.alpha = 0;
                btn.frame = CGRectMake(x, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y + y, width, height);
            } completion:^(BOOL finished) {
                if ([btn isEqual:[jcBtnArr objectAtIndex:0]]) {
                    self.superview.superview.userInteractionEnabled = YES;
                    
                    
                }
            }];
        });
        
    }];

    
    
}

- (void)moveInAnimation{
    
    [jcBtnArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * btn = obj;
        CGFloat x = btn.frame.origin.x;
        CGFloat y = btn.frame.origin.y;
        CGFloat width = btn.frame.size.width;
        CGFloat height = btn.frame.size.height;
        btn.frame = CGRectMake(x, [UIScreen mainScreen].bounds.size.height + y - self.frame.origin.y, width, height);
        btn.alpha = 0.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(idx * 0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 delay:0.05 usingSpringWithDamping:0.9 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
                btn.alpha = 1;
                btn.frame = CGRectMake(x, y, width, height);
            } completion:^(BOOL finished) {
                if ([btn isEqual:[jcBtnArr lastObject]]) {
                    self.superview.superview.userInteractionEnabled = YES;
                }
            }];
        });
        
    }];
}
-(void)tapBackgroundEvent:(UITapGestureRecognizer *)tap{

    [self cancelUI];
    
}

- (void)shareActionEvent:(UIButton *)btn{
    
    [btn scalingWithTime:.25 andscal:1.7];
    [btn fadeOutWithTime:.25];
    [jcBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *jcBtn = obj;
        if (jcBtn!=btn) {
            [jcBtn scalingWithTime:.25 andscal:0.3];
            [jcBtn fadeOutWithTime:.25];
        }
    }];
    [self jcScaleCancelUI];

    if (_delegate && [_delegate respondsToSelector:@selector(shareIndex:)]) {
            
            [_delegate shareIndex:btn.tag];
            
            
    }
 
}

- (void)cancelActionEvent:(UIButton *)btn{
    
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(shareIndex:)]) {
        
        [self removeAnimation];
        [_delegate shareIndex:btn.tag];
        
    }

}


- (void)jcCancelUI
{
 
    [UIView animateWithDuration:0.25 animations:^{
        
        contentView.transform = CGAffineTransformMakeTranslation(0.01, (62+61+18+22+62+1+100+61+18+22+62)/2.0);
      
       
    } completion:^(BOOL finished) {
        
        [contentView removeFromSuperview];
        [bgView removeFromSuperview];
        [self removeFromSuperview];

    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.35 animations:^{
            bgView.alpha = 0.0;
            contentView.alpha = 0.0;
            
        }];
    });



}
- (void)jcScaleCancelUI
{
    [UIView animateWithDuration:0.6 animations:^{
        
        contentView.transform = CGAffineTransformMakeTranslation(0.01, (62+61+18+22+62+1+100+61+18+22+62)/2.0);
        
        
    } completion:^(BOOL finished) {
        
        [contentView removeFromSuperview];
        [bgView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.35 animations:^{
            bgView.alpha = 0.0;
            contentView.alpha = 0.0;
            
        }];
    });
    //[self jcHide];

}
-(void)cancelUI{

    
    [UIView animateWithDuration:0.3 animations:^{
        
        contentView.transform = CGAffineTransformMakeTranslation(0.01, (62+61+18+22+62+1+100+61+18+22+62)/2.0);
      
        
    } completion:^(BOOL finished) {
        
            [contentView removeFromSuperview];
            [bgView removeFromSuperview];
            [self removeFromSuperview];
      
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.35 animations:^{
            bgView.alpha = 0.0;
            contentView.alpha = 0.0;
   
        }];
    });
    
    

}


@end
