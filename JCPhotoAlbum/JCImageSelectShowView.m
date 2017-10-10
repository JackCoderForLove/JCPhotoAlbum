//
//  JCImageSelectShowView.m
//  CanCan
//  图片选择页面头部视图
//  Created by xingjian on 2017/8/12.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCImageSelectShowView.h"
@interface JCImageSelectShowView()<UIScrollViewDelegate>
{
    CGSize  oldSize;
    CGSize  newSize;
    CGPoint oldContentOff;
    CGPoint newContentOff;
    CGSize  oldContentSize;
    CGSize  newContentSize;
    CGPoint  oldImgOrigin;
    CGPoint  newImgOrigin;
    CGFloat oldX;
    CGFloat oldY;
    CGFloat newX;
    CGFloat newY;
    BOOL isZoom;
    UIImage *jcoldImage;
    UIImage *jcnewImage;
    
    
    
}
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UIButton *scaleBtn;
@property(nonatomic,strong)UIScrollView *jcScrollView;
@property (nonatomic,strong)PHCachingImageManager *imageManager;
@end

@implementation JCImageSelectShowView

- (instancetype)initWithFrame:(CGRect)frame
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
    self.jcScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.jcScrollView.delegate = self;
    [self addSubview:self.jcScrollView];
    [self.jcScrollView addSubview:self.img];
    [self addSubview:self.scaleBtn];
    [self.jcScrollView setContentSize:self.img.size];
    [self.jcScrollView setMinimumZoomScale:0.5];//设置最小的缩放大小
    self.jcScrollView.maximumZoomScale = 2.5;//设置最大的缩放大小
    
    [self.scaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(32);
        make.right.mas_equalTo(self.mas_right).offset(-30/2.0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-30/2.0);
    }];
    
}
- (void)jcConfigImage:(id)data
{
    PHAsset * jcAsset = (PHAsset *)data;
    [self.imageManager requestImageForAsset:jcAsset targetSize:CGSizeMake(kScreenWidth, kScreenHeight) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        self.img.image = result;
        [self jcLayoutImgWithImage:result];
        NSLog(@"宽度:%f 高度:%f",result.size.width,result.size.height);
    }];

    
   
}
- (void)jcConfigNoData
{
    UIImage *image = [UIImage imageNamed:@"img_default"];
    self.img.image = image;
    [self jcLayoutImgWithImage:image];
}
- (void)jcLayoutImgWithImage:(UIImage*)image
{


    //重置缩放比例
    self.jcScrollView.zoomScale = 1.0;
    CGFloat jcTargetW;
    //判断原图宽高决定要不要缩放
 
    if (image.size.width<kScreenWidth&&image.size.height<kScreenWidth) {
            
            jcTargetW = kScreenWidth*0.85;
    }
    else
    {
            jcTargetW = kScreenWidth *0.85;
    }

    
    CGFloat jcScale = [[NSString stringWithFormat:@"%.1f",(image.size.width/image.size.height)]floatValue];
    CGFloat imgW = jcTargetW;
    CGFloat imgH = [[NSString stringWithFormat:@"%.1f",(imgW/jcScale)]floatValue];
 
 
    //先缩放原图
    CGSize  jcImgSize = CGSizeMake(imgW, imgH);
 
    
    //设置放大前的frame
    
    if (jcImgSize.width<kScreenWidth&&jcImgSize.height<kScreenWidth)
    {
        //CGFloat jcScale = kScreenWidth/jcImgSize.width;
        oldSize = CGSizeMake(jcImgSize.width, jcImgSize.height);
        oldContentSize = CGSizeMake(kScreenWidth, kScreenWidth);
        oldX = 0;
        oldY = 0;
        oldContentOff = CGPointMake(oldX, oldY);
        oldImgOrigin = CGPointMake((oldContentSize.width-oldSize.width)/2.0, (oldContentSize.height-oldSize.height)/2.0);
    }
    else if(jcImgSize.width>kScreenWidth&&jcImgSize.height>kScreenWidth)
    {
        
        oldSize = CGSizeMake(jcImgSize.width, jcImgSize.height);
        oldContentSize = oldSize;
        oldX = (oldContentSize.width-kScreenWidth)/2.0;
        oldY = (oldContentSize.height-kScreenWidth)/2.0;
        oldContentOff = CGPointMake(oldX, oldY);
        oldImgOrigin = CGPointMake(0, 0);
    }
    else if (jcImgSize.width>kScreenWidth&&jcImgSize.height<kScreenWidth)
    {
        oldSize = CGSizeMake(jcImgSize.width, jcImgSize.height);
        oldContentSize = CGSizeMake(oldSize.width, kScreenWidth);
        oldX = (oldContentSize.width-kScreenWidth)/2.0;
        oldY = 0;
        oldContentOff = CGPointMake(oldX, oldY);
        oldImgOrigin = CGPointMake(0, (kScreenWidth-oldSize.height)/2.0);
        
    }
    else if (jcImgSize.width<kScreenWidth&&jcImgSize.height>kScreenWidth)
    {
        oldSize = CGSizeMake(jcImgSize.width, jcImgSize.height);
        oldContentSize = CGSizeMake(kScreenWidth, oldSize.height);
        oldX = 0;
        oldY = (oldContentSize.height-kScreenWidth)/2.0;
        oldContentOff = CGPointMake(oldX, oldY);
        oldImgOrigin  = CGPointMake((kScreenWidth-oldSize.width)/2.0, 0);
    }
    else
    {
        if (jcImgSize.width<=kScreenWidth||jcImgSize.height<=kScreenWidth) {
            
            if (jcImgSize.width==kScreenWidth&&jcImgSize.height==kScreenWidth) {
                
                
                oldSize = CGSizeMake(kScreenWidth, kScreenWidth);
                oldContentSize = CGSizeMake(oldSize.width, oldSize.height);
                oldX = (oldContentSize.width-kScreenWidth)/2.0;
                oldY = (oldContentSize.height-kScreenWidth)/2.0;
                oldContentOff = CGPointMake(oldX, oldY);
                oldImgOrigin = CGPointMake((oldContentSize.width-oldSize.width)/2.0, (oldContentSize.height-oldSize.height)/2.0);
            }
            else if (jcImgSize.width==kScreenWidth)
            {
                
                oldSize = CGSizeMake(jcImgSize.width, jcImgSize.height);
                oldContentSize = CGSizeMake(oldSize.width, oldSize.height);
                oldX = (oldContentSize.width-kScreenWidth)/2.0;
                oldY = 0;
                oldContentOff = CGPointMake(oldX, oldY);
                oldImgOrigin = CGPointMake(0, (kScreenWidth-oldSize.height)/2.0);
            }
            else if (jcImgSize.height == kScreenWidth)
            {
                
                oldSize = CGSizeMake(jcImgSize.width, jcImgSize.height);
                oldContentSize = CGSizeMake(kScreenWidth, oldSize.height);
                oldX = (oldContentSize.width-kScreenWidth)/2.0;
                oldY = 0;
                oldContentOff = CGPointMake(oldX, oldY);
                oldImgOrigin = CGPointMake((kScreenWidth-oldSize.width)/2.0, 0);              }
            
        }
    }
    //设置放大后的frame
    if (oldSize.width==kScreenWidth&&oldSize.height==kScreenWidth) {
        newSize = oldSize;
        newContentSize = newSize;
        newX = (newContentSize.width-kScreenWidth)/2.0;
        newY = (newContentSize.height-kScreenWidth)/2.0;
        newContentOff = CGPointMake(newX, newY);
        newImgOrigin = CGPointMake(0, 0);
    }
    else if (oldSize.width>kScreenWidth&&oldSize.height>kScreenWidth)
    {
        newSize = oldSize;
        newContentSize = newSize;
        newX = (newContentSize.width-kScreenWidth)/2.0;
        newY = (newContentSize.height-kScreenWidth)/2.0;
        newContentOff = CGPointMake(newX, newY);
        newImgOrigin = CGPointMake(0, 0);
        
    }
    else
    {
        
        newSize = CGSizeMake(oldSize.width*2, oldSize.height*2);
        if (newSize.width<kScreenWidth||newSize.height<kScreenWidth) {
           newSize = CGSizeMake(oldSize.width*2.3, oldSize.height*2.3);
        }
        if (newSize.width>kScreenWidth&&newSize.height>kScreenWidth) {
            newContentSize = CGSizeMake(newSize.width, newSize.height);
            newX = (newContentSize.width-kScreenWidth)/2.0;
            newY = (newContentSize.height-kScreenWidth)/2.0;
            newContentOff = CGPointMake(newX, newY);
            newImgOrigin = CGPointMake(0, 0);
        }
        else if (newSize.width>kScreenWidth&&newSize.height<kScreenWidth)
        {
            newContentSize = CGSizeMake(newSize.width, kScreenWidth);
            newX = (newContentSize.width-kScreenWidth)/2.0;
            newY = 0;
            newContentOff = CGPointMake(newX, newY);
            newImgOrigin = CGPointMake(0, (kScreenWidth-newSize.height)/2.0);
            
        }
        else if (newSize.width<kScreenWidth&&newSize.height>kScreenWidth)
        {
            newContentSize = CGSizeMake(kScreenWidth, newSize.height);
            newX = 0;
            newY = (newContentSize.height-kScreenWidth)/2.0;
            newContentOff = CGPointMake(newX, newY);
            newImgOrigin = CGPointMake((kScreenWidth-newSize.width)/2.0, 0);
            
        }
    }
    jcoldImage = image;
    //jcnewImage = [self imageNewImgByScalingAndCroppingForSize:oldSize withSourceImage:jcoldImage];
    //jcnewImage = [self imageCompressWithSimple:jcoldImage scale:[UIScreen mainScreen].scale];
    jcnewImage = [self reSizeImage:jcoldImage toSize:oldSize];
    self.img.image = jcnewImage;
    CGRect jcChangeReact = CGRectMake(oldImgOrigin.x, oldImgOrigin.y, oldSize.width, oldSize.height);
    self.img.frame = CGRectIntegral(jcChangeReact);
    [self.jcScrollView setContentSize:self.img.size];
    self.jcScrollView.contentOffset = oldContentOff;


}
#pragma mark -
#pragma mark 
//告诉scrollview要缩放的是哪个子控件
 -(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{

    return self.img;
    
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView

{
    isZoom = YES;
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2.0 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2.0 : ycenter;
    
    [self.img setCenter:CGPointMake(xcenter, ycenter)];

    
}



- (void)jcScaleBtnOnClick:(UIButton *)sender
{

    //重置缩放比例
    
    if (isZoom == YES)
    {
        self.jcScrollView.zoomScale = 1.0;
        jcnewImage = [self reSizeImage:jcoldImage toSize:oldSize];
        self.img.image = jcnewImage;
        CGRect jcChangeReact = CGRectMake(oldImgOrigin.x, oldImgOrigin.y, oldSize.width, oldSize.height);
        self.img.frame = CGRectIntegral(jcChangeReact);
        [self.jcScrollView setContentSize:self.img.size];
        self.jcScrollView.contentOffset = oldContentOff;
        sender.selected = NO;
        isZoom = NO;

    }
    else
    {
        if (sender.isSelected == YES) {
            self.jcScrollView.zoomScale = 1.0;
            //如果选中状态，则返回原图
            //self.img.image = jcoldImage;
            jcnewImage = [self reSizeImage:jcoldImage toSize:oldSize];
            self.img.image = jcnewImage;
            CGRect jcChangeReact = CGRectMake(oldImgOrigin.x, oldImgOrigin.y, oldSize.width, oldSize.height);
            self.img.frame = CGRectIntegral(jcChangeReact);
            [self.jcScrollView setContentSize:self.img.size];
            self.jcScrollView.contentOffset = oldContentOff;
            
            
            
        }
        else
        {
            self.jcScrollView.zoomScale = 2.5;
            //如果非选中状态，则放大两倍
            // self.img.image = jcnewImage;
            jcnewImage = [self reSizeImage:jcoldImage toSize:newSize];
            self.img.image = jcnewImage;
            CGRect jcChangeReact = CGRectMake(newImgOrigin.x, newImgOrigin.y, newSize.width, newSize.height);
            self.img.frame = CGRectIntegral(jcChangeReact);
            [self.jcScrollView setContentSize:self.img.size];
            self.jcScrollView.contentOffset = newContentOff;
            
        }
        isZoom = NO;
        sender.selected = !sender.isSelected;

    }
    
  

}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height), NO, 0);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}
-(UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale

{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scale, image.size.height * scale), NO, 0);
                                
    [image drawInRect:CGRectMake(0, 0, image.size.width * scale, image.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
- (UIImage*)imageNewImgByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
- (UIImage *)jcGetImage
{
    UIImage * img = nil;
    CGRect  jcReact;
    CGSize  jcSize;
    if (isZoom == YES) {
        
        //如果双指缩放了
        jcSize = self.img.size;
        jcnewImage = [self reSizeImage:jcoldImage toSize:jcSize];
        self.img.image = jcnewImage;

        
    }
    else
    {
        //判断尺寸
        if (self.scaleBtn.isSelected == YES) {
            //放大状态
            jcSize = newSize;
        }
        else if (self.scaleBtn.isSelected == NO)
        {
            //普通状态
            jcSize = oldSize;
        }

    }
    //
    if (jcSize.width<kScreenWidth && jcSize.height<kScreenWidth) {
        jcReact = CGRectMake(0, 0, jcSize.width, jcSize.height);
    }
    else if (jcSize.width==kScreenWidth && jcSize.height==kScreenWidth)
    {
        jcReact = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    }
    else if (jcSize.height>kScreenWidth && jcSize.height>kScreenWidth)
    {
        CGPoint jcContent = self.jcScrollView.contentOffset;
        jcReact = CGRectMake(jcContent.x, jcContent.y, kScreenWidth, kScreenWidth);
    }
    else if (jcSize.width>kScreenWidth && jcSize.height<kScreenWidth)
    {
        CGPoint jcContent = self.jcScrollView.contentOffset;
        jcReact = CGRectMake(jcContent.x, 0, kScreenWidth, jcSize.height);
    }
    else if (jcSize.width<kScreenWidth && jcSize.height>kScreenWidth)
    {
        CGPoint jcContent = self.jcScrollView.contentOffset;
        jcReact = CGRectMake(0, jcContent.y, jcSize.width, kScreenWidth);
    }
    else
    {
        jcReact = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    }
    //处理图片
    
    img = [self imageFromView:self.img rect:CGRectIntegral(jcReact)];
    return img;
}

-(UIImage*) imageFromView:(UIView *) v rect:(CGRect) rect{
    
    
//    UIGraphicsBeginImageContextWithOptions(v.frame.size, NO, 1.0);  //NO，YES 控制是否透明
//    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    CGRect myImageRect = rect;
//    CGImageRef imageRef = image.CGImage;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef,myImageRect);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, myImageRect, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    CGImageRelease(subImageRef);
//    UIGraphicsEndImageContext();
//    
//    return smallImage;
 
    UIImageView *jcImgView = (UIImageView *)v;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [jcImgView.image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;

    

}

- (UIImageView *)img
{
    if (!_img) {
        
        _img = [UIImageView new];
    }
    return _img;
}

- (UIButton *)scaleBtn
{
    if (!_scaleBtn) {
        
        _scaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scaleBtn setImage:[UIImage imageNamed:@"full_screen.png"] forState:UIControlStateNormal];
        [_scaleBtn addTarget:self action:@selector(jcScaleBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        //别忘了扩大一下缩放按钮的点击范围
    }
    return _scaleBtn;
}

- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}

@end
