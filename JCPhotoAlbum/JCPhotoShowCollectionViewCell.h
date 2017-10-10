//
//  JCPhotoShowCollectionViewCell.h
//  CanCan
//
//  Created by xingjian on 2017/8/14.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#define itemSizeW  (kScreenWidth-5)/4.0
@interface JCPhotoShowCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView  *jcItemImg;
@property (nonatomic,strong)UIImage *bigImg;
- (void)jcCofigData:(id)data withIndexPath:(NSIndexPath *)index;
- (void)jcConfigNoData;
//置为选中状态
- (void)jcChangeSelectState;
//置为普通状态
- (void)jcChangeNormalState;
@end
