//
//  JCPhotoShowCollectionViewCell.m
//  CanCan
//
//  Created by xingjian on 2017/8/14.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCPhotoShowCollectionViewCell.h"
#import <Photos/Photos.h>

@interface JCPhotoShowCollectionViewCell()


@property (nonatomic,strong)PHCachingImageManager *imageManager;
@end

@implementation JCPhotoShowCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        
        return nil;
    }
    [self layoutMyUI];
    return self;
}

- (void)layoutMyUI
{
    [self addSubview:self.jcItemImg];
    [self.jcItemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(itemSizeW);
        make.left.top.mas_equalTo(self);
    }];
}
//置为选中状态
- (void)jcChangeSelectState
{
    self.layer.borderColor = [ToolsHelper colorWithHexString:@"#3FD2A0"].CGColor;
    self.layer.borderWidth = 1.0f;
}
//置为普通状态
- (void)jcChangeNormalState
{
    self.layer.borderColor = [ToolsHelper colorWithHexString:@"#ffffff"].CGColor;
    self.layer.borderWidth = 0.0f;
}
- (void)jcCofigData:(id)data withIndexPath:(NSIndexPath *)index
{
    if (index.row==0) {
        self.jcItemImg.image = [UIImage imageNamed:@"photo_album_taking_pictures"];
    }
    else
        
    {
        self.jcItemImg.tag = 9000+index.row;
        self.jcItemImg.image = [UIImage imageNamed:@"img_default"];
        PHAsset * jcAsset = (PHAsset *)data;
        [self.imageManager requestImageForAsset:jcAsset targetSize:CGSizeMake(itemSizeW, itemSizeW) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.jcItemImg.image = result;
        }];
        [self.imageManager requestImageForAsset:jcAsset targetSize:CGSizeMake(kScreenWidth*0.8, kScreenWidth*0.8) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.bigImg = result;
        }];

        

    }
}
- (void)jcConfigNoData
{
     self.jcItemImg.image = [UIImage imageNamed:@"img_default"];
}
- (UIImageView *)jcItemImg
{
    if (!_jcItemImg) {
        
        _jcItemImg = [UIImageView new];
        _jcItemImg.image = [UIImage imageNamed:@"img_default"];
        _jcItemImg.userInteractionEnabled = YES;
  
    }
    return _jcItemImg;
}
- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}
@end
