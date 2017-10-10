//
//  JCFiterCollectionViewCell.h
//  CanCan
//  滤纸自定义网格cell
//  Created by xingjian on 2017/8/15.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCFiterModel;
@interface JCFiterCollectionViewCell : UICollectionViewCell
- (void)jcConfigData:(JCFiterModel *)model withIndexPath:(NSIndexPath *)indexPath withOriginImg:(UIImage *)originImg;

- (void)jcChangeNormalState;

- (void)jcChangeSelectState;

@end
