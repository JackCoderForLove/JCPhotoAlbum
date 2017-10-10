//
//  JCPhotoTableViewCell.m
//  CanCan
//  自定义相册cell
//  Created by xingjian on 2017/8/11.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCPhotoTableViewCell.h"
#import "JCPhotoModel.h"

#define kAlbumRowHeight 140/2
@interface JCPhotoTableViewCell()
@property (strong, nonatomic) PHCachingImageManager *imageManager;
@property (nonatomic,strong)UIImageView  *jcImg;
@property (nonatomic,strong)UILabel      *titleLab;

@end
@implementation JCPhotoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        
        return nil;
    }
    [self jcLayoutMyUI];
    return self;
}

- (void)jcLayoutMyUI
{
    [self addSubview:self.jcImg];
    [self addSubview:self.titleLab];
    [self.jcImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(140/2);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(30/2);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth-140/2-30-60/2);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.jcImg.mas_right).offset(30/2);
    }];
    
}

- (void)jcConfigPhotoData:(id)data
{
    JCPhotoModel * model = (JCPhotoModel *)data;
    
    //获取image
    if (model.photoAlbumResult.count>0)
    {
        
        PHAsset *asset = model.photoAlbumResult[0];
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(kAlbumRowHeight, kAlbumRowHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            self.jcImg.image = result;
            
        }];
    }
    else
    {
        self.jcImg.image = [UIImage imageNamed:@"img_default.png"];
    }
    
    //设置title
    
    self.titleLab.text = [NSString stringWithFormat:@"%@  (%lu)",model.title,(unsigned long)model.photoAlbumResult.count];
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [ToolsHelper colorWithHexString:@"#444444"];
        
    }
    return _titleLab;
}
- (UIImageView *)jcImg
{
    if (!_jcImg) {
        
        _jcImg = [UIImageView new];
        _jcImg.image = [UIImage imageNamed:@"jc.jpg"];
    }
    return _jcImg;
}
- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
