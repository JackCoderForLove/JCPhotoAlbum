//
//  JCStickerCollectionViewCell.h
//  CanCan
//  贴纸自定义网格cell
//  Created by xingjian on 2017/8/15.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCStickerModel;

@interface JCStickerCollectionViewCell : UICollectionViewCell

- (void)jcChangeNormalState;

- (void)jcChangeSelectState;

- (void)jcConfigData:(JCStickerModel *)model withIndexPath:(NSIndexPath *)indexPath withOriginImg:(UIImage *)originImg;

@end
