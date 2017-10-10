//
//  JCCustomPhotoView.m
//  CanCan
//  自定义相册列表
//  Created by xingjian on 2017/8/11.
//  Copyright © 2017年 xingjian. All rights reserved.
//

#import "JCCustomPhotoView.h"
#import "JCPhotoTableViewCell.h"
#import "JCPhotoModel.h"
#import <Photos/Photos.h>

#define jcTableCellHeight 110
@interface JCCustomPhotoView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *jcTable;
@property (nonatomic,strong)UIView  *blurView;
@property (nonatomic,strong)NSArray *jcPhotoData;
@property (nonatomic,assign)CGFloat  jcTableHeight;
@end

@implementation JCCustomPhotoView
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

    [self addSubview:self.blurView];
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight);
    }];
    [self addSubview:self.jcTable];

    
}
- (void)jcConfigData:(NSArray *)jcData
{
    self.jcPhotoData = jcData;
    CGFloat jcTableFrameHeight = 110*4;
    //判断个数
    if (self.jcPhotoData.count>4)
    {
        jcTableFrameHeight = 110*4;
    }
    else
    {
        jcTableFrameHeight = 110*self.jcPhotoData.count;
    }
    self.jcTableHeight = jcTableFrameHeight;
    //布局tableview
    self.jcTable.frame = CGRectMake(0, -jcTableFrameHeight, kScreenWidth, jcTableFrameHeight);
    //布局blurView
    [self.blurView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight);
    }];
    [self.jcTable reloadData];
    
}

#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jcPhotoData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *jcPhotoID = @"jcphotoID";
    JCPhotoTableViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:jcPhotoID];
    if (!photoCell) {
        
        photoCell = [[JCPhotoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jcPhotoID];
        photoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row<self.jcPhotoData.count) {
  
        [photoCell jcConfigPhotoData:[self.jcPhotoData objectAtIndex:indexPath.row]];
    }
    return photoCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.jcPhotoData.count) {
        id  data = [self.jcPhotoData objectAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(jcCustomPhotoView:withIndexPath:withData:)]) {
            [self.delegate jcCustomPhotoView:self withIndexPath:indexPath withData:data];
        }
    }
}

- (void)jcBlurViewOnClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(jcHiddenView)]) {
        [self.delegate jcHiddenView];
    }
}
- (void)jcBlurSwipe:(UISwipeGestureRecognizer *)swipe
{
    if ([self.delegate respondsToSelector:@selector(jcHiddenView)]) {
        [self.delegate jcHiddenView];
    }

}
- (void)jcChangeFrame
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect jcFrame = self.jcTable.frame;
        jcFrame.origin.y = 0;
        self.jcTable.frame = jcFrame;
 
    }];
}
- (void)jcChangeOldFrame
{
    CGRect jcFrame = self.jcTable.frame;
    jcFrame.origin.y = -self.jcTableHeight;
    self.jcTable.frame = jcFrame;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (UITableView *)jcTable
{
    if (!_jcTable) {
        
        _jcTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-110*4) style:UITableViewStylePlain];
        _jcTable.delegate = self;
        _jcTable.dataSource = self;
        
    }
    return _jcTable;
}

- (UIView *)blurView
{
    if (!_blurView) {
        
        _blurView = [UIView new];
        _blurView.backgroundColor = [ToolsHelper colorWithHexString:@"#000000"];
        _blurView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jcBlurViewOnClick:)];
        _blurView.userInteractionEnabled = YES;
        [_blurView addGestureRecognizer:tap];
        UISwipeGestureRecognizer *swp1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(jcBlurSwipe:)];
        swp1.direction = UISwipeGestureRecognizerDirectionUp;
        [_blurView addGestureRecognizer:swp1];
        
    }
    return _blurView;
}
@end
