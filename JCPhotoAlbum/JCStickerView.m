//
//  JCStickerView.m
//  CanCan
//
//  Created by xingjian on 2017/6/16.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCStickerView.h"
#import "UIImageView+JCHotArea.h"

//#define STICKER_SLIDE        150.0
#define FLEX_SLIDE          30.0
#define BT_SLIDE            18.0
#define BORDER_LINE_WIDTH   0.5

@interface JCStickerView ()<UIGestureRecognizerDelegate>
{
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat maxWidth;
    CGFloat maxHeight;
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint touchStart;
    CGRect  bgRect ;
    CGFloat imageRatio;
    CGSize preSize;
    CAShapeLayer *borderLayer;
    
}
@property (nonatomic,strong) UIImageView    *btDelete ;
@property (nonatomic,strong) UIImageView    *btSizeCtrl ;
@property (nonatomic,strong) UIImageView    *btMirror ;
@property (nonatomic,strong) UIView         *blurView;

@end

@implementation JCStickerView

- (instancetype)initWithBgView:(UIView *)bgView StickerID:(NSInteger)stickerID Img:(UIImage *)img
{
    self = [super init];
    if (self)
    {
        self.stickerID = stickerID ;
        self.stickerImg = img ;
        imageRatio = img.size.width/img.size.height;
        
        bgRect = bgView.frame ;
        [self setupWithBGFrame:bgRect] ;
        [self blurView];
        [self jcAddDashLine];
        [self imgContentView] ;
        [self btDelete] ;
        [self btSizeCtrl] ;
        
        // [self btMirror];
        [bgView addSubview:self] ;
    }
    return self;
}
- (void)jcAddDashLine
{
    borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, self.blurView.frame.size.width, self.blurView.frame.size.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.blurView.bounds), CGRectGetMidY(self.blurView.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:5.0].CGPath;
    borderLayer.borderColor = [UIColor whiteColor].CGColor;
    borderLayer.lineWidth = 0.5;
    //虚线边框
    borderLayer.lineDashPattern = @[@3, @2];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    [_blurView.layer addSublayer:borderLayer];
    
}
- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    
    CGRect rect = CGRectZero ;
    CGRect blurRect = CGRectZero;
    
    CGFloat contentWidth = self.frame.size.width - FLEX_SLIDE *2 ;
    CGFloat contentHeight = self.frame.size.height - FLEX_SLIDE *2 ;
    CGFloat blurContentWidth = self.frame.size.width-FLEX_SLIDE;
    CGFloat blurContentHeight = self.frame.size.height-FLEX_SLIDE;
    blurRect.origin = CGPointMake(FLEX_SLIDE/2.0, FLEX_SLIDE/2.0);
    blurRect.size = CGSizeMake(blurContentWidth, blurContentHeight);
    
    rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
    rect.size = CGSizeMake(contentWidth, contentHeight) ;
    
    self.imgContentView.frame = rect;
    self.blurView.frame = blurRect;
    
    self.imgContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
}

- (void)setStickerImg:(UIImage *)stickerImg
{
    _stickerImg = stickerImg ;
    
    self.imgContentView.image = stickerImg ;
}

- (void)setIsOnFirst:(BOOL)isOnFirst
{
    _isOnFirst = isOnFirst ;
    
    self.btDelete.hidden = !isOnFirst ;
    self.btSizeCtrl.hidden = !isOnFirst ;
    //self.btMirror.hidden = !isOnFirst ;
    borderLayer.hidden = isOnFirst ? NO : YES;
    
    
}

- (void)setupWithBGFrame:(CGRect)bgFrame
{
    CGRect rect = CGRectZero ;
    
    CGFloat stickerWidth;
    CGFloat stickerHeight;
    
    if (imageRatio>1) {
        stickerWidth=self.stickerImg.size.width + FLEX_SLIDE*2;
        stickerHeight=self.stickerImg.size.height + FLEX_SLIDE*2;
    }else{
        stickerHeight=self.stickerImg.size.height + FLEX_SLIDE*2;
        stickerWidth=self.stickerImg.size.width + FLEX_SLIDE*2;
    }
    
    rect.size = CGSizeMake(stickerWidth, stickerHeight) ;
    self.frame = rect ;
    self.center = CGPointMake(bgFrame.size.width / 2, bgFrame.size.height / 2) ;
    self.backgroundColor = nil ;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ;
    [self.imgContentView addGestureRecognizer:tapGesture] ;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
    [self.imgContentView addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)] ;
    pinchGesture.delegate=self;
    [self.imgContentView addGestureRecognizer:pinchGesture] ;
    
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] ;
    rotateGesture.delegate=self;
    [self.imgContentView addGestureRecognizer:rotateGesture] ;
    
    minWidth   = self.bounds.size.width * 0.8;
    minHeight  = self.bounds.size.height * 0.8;
    
    maxWidth   = self.bounds.size.width * 2.0;
    maxHeight  = self.bounds.size.height * 2.0;
    
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x) ;
    
    
}

-(void)move:(UIPanGestureRecognizer *)panGesture
{
    if ([panGesture state] == UIGestureRecognizerStateBegan)
    {
        [self.delegate makeStickerBecomeFirstRespond:self.stickerID] ;
        touchStart = [panGesture locationOfTouch:0 inView:self.superview];
    }
    else if ([panGesture state] == UIGestureRecognizerStateChanged)
    {
        CGPoint touchLocation = [panGesture locationOfTouch:0 inView:self];
        if (CGRectContainsPoint(self.btSizeCtrl.frame, touchLocation)) {
            return;
        }
        
        CGPoint touch = [panGesture locationOfTouch:0 inView:self.superview];
        
        [self translateUsingTouchLocation:touch] ;
        
        touchStart = touch;
        
    }
    else if ([panGesture state] == UIGestureRecognizerStateEnded)
    {
        
    }
    
}

#pragma mark - 触摸事件
- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    [self.delegate makeStickerBecomeFirstRespond:self.stickerID] ;
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y) ;
    
    if (newCenter.x > self.superview.bounds.size.width)
    {
        newCenter.x = self.superview.bounds.size.width;
    }
    if (newCenter.x < 0)
    {
        newCenter.x = 0;
    }
    
    if (newCenter.y > self.superview.bounds.size.height)
    {
        newCenter.y = self.superview.bounds.size.height;
    }
    if (newCenter.y < 0)
    {
        newCenter.y = 0;
    }
    
    self.center = newCenter;
}

#pragma mark - 双指手势
- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture
{
    
    CGPoint originCenter = self.center;
    
    if ([pinchGesture state] == UIGestureRecognizerStateBegan) {
        
        preSize = self.bounds.size;
        [self setNeedsDisplay];
        
    }else if([pinchGesture state] == UIGestureRecognizerStateChanged){
        
        CGFloat finalWidth = preSize.width * pinchGesture.scale ;
        CGFloat finalHeight = preSize.height * pinchGesture.scale ;
        
        if (finalWidth > maxWidth || finalWidth < minWidth || finalHeight > maxHeight || finalHeight < minHeight) {
            finalWidth  = self.bounds.size.width;
            finalHeight = self.bounds.size.height;
        }
        self.bounds = CGRectMake(self.bounds.origin.x,self.bounds.origin.y,finalWidth,finalHeight) ;
        
        self.btSizeCtrl.frame = CGRectMake(self.bounds.size.width-BT_SLIDE-6,6,BT_SLIDE ,BT_SLIDE) ;
        self.btDelete.frame = CGRectMake(6,self.bounds.size.height - BT_SLIDE-6 ,BT_SLIDE ,BT_SLIDE);
        //self.btMirror.frame = CGRectMake(self.bounds.size.width - BT_SLIDE  ,self.bounds.size.height - BT_SLIDE ,BT_SLIDE ,BT_SLIDE);
        borderLayer.bounds = CGRectMake(0, 0, self.blurView.frame.size.width, self.blurView.frame.size.height);
        borderLayer.position = CGPointMake(CGRectGetMidX(self.blurView.bounds), CGRectGetMidY(self.blurView.bounds));
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:5.0].CGPath;
        self.center=originCenter;
        [self setNeedsDisplay];
        
    }else if([pinchGesture state] == UIGestureRecognizerStateEnded){
        
        self.center=originCenter;
        [self setNeedsDisplay];
    }
    
}

- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    [self.delegate makeStickerBecomeFirstRespond:self.stickerID] ;
    self.transform = CGAffineTransformMakeRotation(rotateGesture.rotation);
    
    [self setNeedsDisplay] ;
}

#pragma mark - 创建控件
- (UIImageView *)imgContentView
{
    if (!_imgContentView)
    {
        CGRect rect = CGRectZero ;
        
        CGFloat contentWidth = self.frame.size.width - FLEX_SLIDE *2 ;
        CGFloat contentHeight = self.frame.size.height - FLEX_SLIDE *2 ;
        
        rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
        rect.size = CGSizeMake(contentWidth, contentHeight) ;
        
        _imgContentView = [[UIImageView alloc] initWithFrame:rect] ;
        _imgContentView.backgroundColor = nil ;
        //        _imgContentView.layer.borderColor = [UIColor whiteColor].CGColor ;
        //        _imgContentView.layer.borderWidth = BORDER_LINE_WIDTH ;
        _imgContentView.layer.allowsEdgeAntialiasing=YES;
        _imgContentView.contentMode = UIViewContentModeScaleAspectFit ;
        _imgContentView.userInteractionEnabled = YES;
        
        if (![_imgContentView superview])
        {
            [self addSubview:_imgContentView] ;
        }
    }
    
    return _imgContentView ;
}
- (UIView *)blurView
{
    if (!_blurView) {
        
        CGRect rect = CGRectZero ;
        
        CGFloat contentWidth = self.frame.size.width - 30;
        CGFloat contentHeight = self.frame.size.height - 30;
        
        rect.origin = CGPointMake(15, 15) ;
        rect.size = CGSizeMake(contentWidth, contentHeight) ;
        
        _blurView = [[UIView alloc]initWithFrame:rect];
        _blurView.backgroundColor = [UIColor clearColor];
        _blurView.layer.allowsEdgeAntialiasing=YES;
        _blurView.userInteractionEnabled = YES;
        _blurView.layer.masksToBounds = YES;
        _blurView.layer.cornerRadius = 5.0f;
        if (![_blurView superview])
        {
            [self insertSubview:_blurView atIndex:0] ;
        }
    }
    return _blurView;
}
- (UIImageView *)btSizeCtrl
{
    if (!_btSizeCtrl)
    {
        _btSizeCtrl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - BT_SLIDE-  6,6 ,BT_SLIDE ,BT_SLIDE)] ;
        _btSizeCtrl.userInteractionEnabled = YES;
        _btSizeCtrl.image = [UIImage imageNamed:@"zoom.png"] ;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeTranslate:)] ;
        [_btSizeCtrl addGestureRecognizer:panGesture] ;
        [_btSizeCtrl setEnlargeEdge:15];
        if (![_btSizeCtrl superview]) {
            [self addSubview:_btSizeCtrl] ;
        }
    }
    
    return _btSizeCtrl ;
}

//- (UIImageView *)btMirror
//{
//    if (!_btMirror)
//    {
//        _btMirror = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - BT_SLIDE  ,self.frame.size.height - BT_SLIDE ,BT_SLIDE ,BT_SLIDE)] ;
//        _btMirror.userInteractionEnabled = YES;
//        _btMirror.image = [UIImage imageNamed:@"贴纸－镜像"] ;
//
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btMirrorPressed:)] ;
//        [_btMirror addGestureRecognizer:tapGesture] ;
//        if (![_btMirror superview]) {
//            [self addSubview:_btMirror] ;
//        }
//    }
//
//    return _btMirror ;
//}

- (UIImageView *)btDelete
{
    if (!_btDelete)
    {
        _btDelete = [[UIImageView alloc]initWithFrame:CGRectMake(6  ,self.frame.size.height - BT_SLIDE-6 ,BT_SLIDE ,BT_SLIDE)] ;
        _btDelete.userInteractionEnabled = YES;
        _btDelete.image = [UIImage imageNamed:@"stickers_close.png"] ;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btDeletePressed:)] ;
        [_btDelete addGestureRecognizer:tapGesture] ;
        [_btDelete setEnlargeEdge:15];
        
        if (![_btDelete superview]) {
            [self addSubview:_btDelete] ;
        }
    }
    
    return _btDelete ;
}

#pragma mark - 按钮事件
- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        //拉伸
        CGPoint point = [recognizer locationInView:self];
        
        float wChange = 0.0, hChange = 0.0;
        wChange = (point.x - prevPoint.x);
        float wRatioChange = (wChange/(float)self.imgContentView.frame.size.width);
        
        hChange = wRatioChange * self.imgContentView.frame.size.height;
        
        CGFloat finalWidth = self.bounds.size.width + 2*(wChange) ;
        CGFloat finalHeight = self.bounds.size.height + 2*(hChange) ;
        
        if (finalWidth > maxWidth || finalWidth < minWidth || finalHeight > maxHeight || finalHeight < minHeight) {
            finalWidth  = self.bounds.size.width;
            finalHeight = self.bounds.size.height;
        }
        self.bounds = CGRectMake(self.bounds.origin.x,self.bounds.origin.y,finalWidth,finalHeight) ;
        
        self.btSizeCtrl.frame = CGRectMake(self.bounds.size.width-BT_SLIDE-6  ,6,BT_SLIDE ,BT_SLIDE) ;
        self.btDelete.frame = CGRectMake(6,self.bounds.size.height - BT_SLIDE-6 ,BT_SLIDE ,BT_SLIDE);
        //self.btMirror.frame = CGRectMake(self.bounds.size.width - BT_SLIDE  ,self.bounds.size.height - BT_SLIDE ,BT_SLIDE ,BT_SLIDE);
        borderLayer.bounds = CGRectMake(0, 0, self.blurView.frame.size.width, self.blurView.frame.size.height);
        borderLayer.position = CGPointMake(CGRectGetMidX(self.blurView.bounds), CGRectGetMidY(self.blurView.bounds));
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:5.0].CGPath;
        
        prevPoint = [recognizer locationInView:self];
        
        
        //旋转
        float ang = atan2(self.center.y - [recognizer locationInView:self.superview].y ,[recognizer locationInView:self.superview].x - self.center.x) ;
        float angleDiff = deltaAngle - ang ;
        self.transform = CGAffineTransformMakeRotation(angleDiff) ;
        
        [self setNeedsDisplay] ;
        
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}

- (void)btDeletePressed:(id)btDel
{
    [self removeFromSuperview] ;
    [self.delegate removeSticker:self.stickerID] ;
}

- (void)btMirrorPressed:(id)btMir{
    
    self.imgContentView.transform = CGAffineTransformScale(self.imgContentView.transform, -1, 1);
    
}

#pragma mark - 重新绘制变化后的贴纸
-(UIImage *)getChangedImage{
    
    CGSize imgSize = CGSizeMake(self.stickerImg.size.width , self.stickerImg.size.height);
    CGSize outputSize = imgSize;
    
    CGFloat radius = atan2f(self.transform.b, self.transform.a);
    
    CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
    rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(radius));
    outputSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, radius);
    
    if (self.imgContentView.transform.a<0) {
        CGContextScaleCTM(context, -1, 1);
    }
    
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    
    [self.stickerImg drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]&&[otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return YES;
    }
    
    return NO;
}


@end
