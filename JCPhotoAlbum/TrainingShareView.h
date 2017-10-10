//
//  TrainingShareView.h
//  CanCan
//
//  Created by xiaolong li on 16/12/21.
//  Copyright © 2016年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrainingShareViewDelegate  <NSObject>

//1000 -1004
-(void)shareIndex:(NSInteger)shareIndex;

@end

@interface TrainingShareView : UIView

@property (nonatomic,assign) id <TrainingShareViewDelegate>delegate;

//需要分享图标  分享名称
- (void)setContentIcon:(NSArray *)_iconArr iconName:(NSArray *)_nameArr;

@end
