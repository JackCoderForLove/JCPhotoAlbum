//
//  JCFiterSelectView.h
//  CanCan
//  自定义选择参参滤镜参参贴纸选择器
//  Created by xingjian on 2017/8/16.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCFiterSelectView;
@protocol JCFiterSelectViewDelegate <NSObject>

//选中的第几个标签
- (void)jcFiterSelect:(JCFiterSelectView *)fiterView withIndex:(NSInteger)index;


@end

@interface JCFiterSelectView : UIView

@property (nonatomic,assign)id <JCFiterSelectViewDelegate>delegate;

- (void)jcConfigTitleViewWithData:(NSArray *)titleArr;
- (void)jcSelectIndex:(NSInteger)index;

@end
