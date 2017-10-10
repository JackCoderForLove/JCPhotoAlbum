//
//  JCPhotoModel.h
//  CanCan
//
//  Created by xingjian on 2017/8/12.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface JCPhotoModel : NSObject
@property (nonatomic,strong) PHFetchResult *photoAlbumResult;
@property (nonatomic,strong) NSString *title;
@end
