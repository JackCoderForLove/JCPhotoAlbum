//
//  JCCustomAlert.h
//  CanCan
//
//  Created by xingjian on 2017/7/12.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCCustomAlert;
@protocol JCCustomAlertDelegate <NSObject>
- (void)jcCustomAlertOnClick:(JCCustomAlert*)alertView withClickIndex:(NSInteger)index;
@end
@interface JCCustomAlert : UIView
@property (nonatomic,assign) id <JCCustomAlertDelegate> delegate;
//展示标题文字
- (void)showAlertWithTitle:(NSString *)title withContent:(NSString *)content withLeftBtnTitle:(NSString *)leftTitle withRightBtnTitle:(NSString *)rightTitle;
//展示标题文字
- (void)showAlertWithTitle:(NSString *)title withContent:(NSString *)content withLeftBtnTitle:(NSString *)leftTitle;

//取消alert
- (void)jcDismissAlert;
@end
