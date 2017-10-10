//
//  JCPhotoTitleView.h
//  CanCan
//  自定义相册选择titleView
//  Created by xingjian on 2017/8/11.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCPhotoTitleView;
@protocol JCPhotoTitleViewDelegate <NSObject>
- (void)jcPhotoViewOnClick:(JCPhotoTitleView *)jcPhotoView withIsClick:(BOOL)isClick;
@end
@interface JCPhotoTitleView : UIView
@property (nonatomic,assign) id <JCPhotoTitleViewDelegate> delegate;
- (void)jcConfigTitle:(NSString *)title;
- (void)updateTitleFrameWithTitle:(NSString*)title;
@end
