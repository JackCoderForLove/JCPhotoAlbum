//
//  JCCustomPhotoView.h
//  CanCan
//  自定义相册列表
//  Created by xingjian on 2017/8/11.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCCustomPhotoView;
@protocol JCCustomPhotoViewDelegate <NSObject>

- (void)jcCustomPhotoView:(JCCustomPhotoView *)photoView withIndexPath:(NSIndexPath *)indexPath withData:(id)data;
- (void)jcHiddenView;

@end
@interface JCCustomPhotoView : UIView
@property (nonatomic,assign) id <JCCustomPhotoViewDelegate> delegate;
//修改frame
- (void)jcChangeFrame;
- (void)jcChangeOldFrame;

- (void)jcConfigData:(NSArray *)jcData;
@end
