//
//  UIImageView+JCHotArea.h
//  CanCan
//
//  Created by xingjian on 2017/8/17.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JCHotArea)
//根据size扩大热区
- (void)setEnlargeEdge:(CGFloat) size;
//根据上下左右扩大热区
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
