//
//  JCStickerView.h
//  CanCan
//
//  Created by xingjian on 2017/8/16.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCStickerView;
@protocol JCStickerViewDelegate <NSObject>

- (void)makeStickerBecomeFirstRespond:(NSInteger)stickerID ;
- (void)removeSticker:(NSInteger)stickerID ;


@end
@interface JCStickerView : UIView
@property (nonatomic,strong) UIImage *stickerImg ;
@property (nonatomic,strong) UIImageView *imgContentView ;
@property (nonatomic,assign) NSInteger stickerID ;
@property (nonatomic,assign) BOOL isOnFirst ;
@property (nonatomic,weak) id <JCStickerViewDelegate> delegate ;

- (instancetype)initWithBgView:(UIView *)bgView StickerID:(NSInteger)stickerID Img:(UIImage *)img ;

-(UIImage *)getChangedImage;

@end
