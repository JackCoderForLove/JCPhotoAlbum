//
//  JCImageSelectShowView.h
//  CanCan
//  图片选择页面头部视图
//  Created by xingjian on 2017/8/12.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface JCImageSelectShowView : UIView
//配置数据
- (void)jcConfigImage:(id)data;

- (void)jcConfigNoData;
//获取图片
- (UIImage *)jcGetImage;
@end
