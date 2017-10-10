//
//  UIView+JCViewAnimation.h
//  JCPhotoAlbum
//
//  Created by xingjian on 2017/9/15.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JCViewAnimation)
//淡入
- (void)fadeInWithTime:(NSTimeInterval)time;
//淡出
- (void)fadeOutWithTime:(NSTimeInterval)time;
//缩放
- (void)scalingWithTime:(NSTimeInterval)time andscal:(CGFloat)scal;
//旋转
- (void)RevolvingWithTime:(NSTimeInterval)time andDelta:(CGFloat)delta;
@end
