//
//  CIFilter+JCCustomFilter.h
//  JCTTTest
//
//  Created by xingjian on 2017/7/31.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@interface CIFilter (JCCustomFilter)

+ (UIImage *)filterEvent:(NSString *)filterName originImage:(UIImage *)originImage;

@end
