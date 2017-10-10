//
//  JCTakePhotoCollectionViewCell.m
//  CanCan
//
//  Created by xingjian on 2017/8/14.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCTakePhotoCollectionViewCell.h"

@interface JCTakePhotoCollectionViewCell()
@property (nonatomic,strong)UIImageView  *jcItemImg;

@end

@implementation JCTakePhotoCollectionViewCell

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
        make.width.height.mas_equalTo(JCTakePhotoItemSizeW);
        make.left.top.mas_equalTo(self);
    }];
}

- (UIImageView *)jcItemImg
{
    if (!_jcItemImg) {
        
        _jcItemImg = [UIImageView new];
        _jcItemImg.image = [UIImage imageNamed:@"photo_album_taking_pictures"];
    }
    return _jcItemImg;
}

@end
