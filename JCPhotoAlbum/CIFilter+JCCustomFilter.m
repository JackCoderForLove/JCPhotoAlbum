//
//  CIFilter+JCCustomFilter.m
//  JCTTTest
//
//  Created by xingjian on 2017/7/31.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "CIFilter+JCCustomFilter.h"

@implementation CIFilter (JCCustomFilter)
+ (UIImage *)filterEvent:(NSString *)filterName originImage:(UIImage *)originImage

{
    
    if ([filterName isEqualToString:@"OriginImage"]) {
        
        return  originImage;
        
    }else{
        
        //将UIImage转换成CIImage
        
        CIImage *ciImage = [[CIImage alloc] initWithImage:originImage];
        
        //创建滤镜
        
        CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
        
        //已有的值不改变，其他的设为默认值
        
        [filter setDefaults];
        
        //获取绘制上下文
        
        CIContext *context = [CIContext contextWithOptions:nil];
        
        //渲染并输出CIImage
        
        CIImage *outputImage = [filter outputImage];
        
        //创建CGImage句柄

       CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
        //获取图片
        
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        
        //释放CGImage句柄
        
        CGImageRelease(cgImage);
        
        return image;
        
    }
    
}

@end
