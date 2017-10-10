//
//  JCStickerCollectionViewCell.m
//  CanCan
//  贴纸自定义网格cell
//  Created by xingjian on 2017/8/15.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCStickerCollectionViewCell.h"
#import "JCStickerModel.h"

@interface JCStickerCollectionViewCell()
@property(nonatomic,strong)UIImageView  *jcImgContentView;
@property(nonatomic,strong)UIImageView  *jcStickerView;
@property(nonatomic,strong)JCStickerModel *model;
@property(nonatomic,strong)UIImage  *originImg;
@end
@implementation JCStickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        
        return nil;
    }
    [self jcLayoutMyUI];
    return self;
}

- (void)jcLayoutMyUI
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    [self addSubview:self.jcImgContentView];
    [self addSubview:self.jcStickerView];
    
}

- (void)jcConfigData:(JCStickerModel *)model withIndexPath:(NSIndexPath *)indexPath withOriginImg:(UIImage *)originImg
{
    self.model = model;
    self.originImg = originImg;
    UIImage *finishImg = [ToolsHelper imageCompressForSize:self.originImg targetSize:CGSizeMake(300, 300)];
    self.jcImgContentView.image = finishImg;
    [self.jcImgContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(216/2);
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
    }];
    self.jcStickerView.image = [UIImage imageNamed:model.stSmImg];
    [self.jcStickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.jcStickerView.image.size.width);
        make.height.mas_equalTo(self.jcStickerView.image.size.height);
        make.center.mas_equalTo(self);
    }];
    
}
- (void)jcChangeNormalState
{
    self.layer.borderColor = [ToolsHelper colorWithHexString:@"#ffffff"].CGColor;
    self.layer.borderWidth = 0.0f;

}
- (void)jcChangeSelectState
{
    self.layer.borderColor = [ToolsHelper colorWithHexString:@"#3FD2A0"].CGColor;
    self.layer.borderWidth = 1.0f;
}

- (UIImageView *)jcImgContentView
{
    if (!_jcImgContentView) {
        
        _jcImgContentView = [UIImageView new];
     
    }
    return _jcImgContentView;
}
- (UIImageView *)jcStickerView
{
    if (!_jcStickerView) {
        
        _jcStickerView = [UIImageView new];
    }
    return _jcStickerView;
}

@end
