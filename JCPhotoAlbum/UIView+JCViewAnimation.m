//
//  UIView+JCViewAnimation.m
//  JCPhotoAlbum
//
//  Created by xingjian on 2017/9/15.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "UIView+JCViewAnimation.h"

@implementation UIView (JCViewAnimation)

//淡入
- (void)fadeInWithTime:(NSTimeInterval)time{
    self.alpha = 0;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
//淡出
- (void)fadeOutWithTime:(NSTimeInterval)time{
    self.alpha = 1;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//缩放
- (void)scalingWithTime:(NSTimeInterval)time andscal:(CGFloat)scal{
    
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeScale(scal,scal);
    }];
}
//旋转
- (void)RevolvingWithTime:(NSTimeInterval)time andDelta:(CGFloat)delta{
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeRotation(delta);
    }];
}

@end
