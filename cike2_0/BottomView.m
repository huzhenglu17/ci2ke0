//
//  BottomView.m
//  cike
//
//  Created by jiangjie on 14-9-26.
//  Copyright (c) 2014年 liugang. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView

- (void)drawRect:(CGRect)rect {
    CGFloat btnWidth = _favoriteView.frame.size.width;
    CGFloat btnHeight = _favoriteView.frame.size.height;
    CGPoint center ;

    UIButton *collectionImageView = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth/4, btnHeight/8, btnWidth/2, btnHeight/2)];
    [collectionImageView setBackgroundImage:[UIImage imageNamed:@"collection_normal"] forState:UIControlStateNormal];
    [collectionImageView setBackgroundImage:[UIImage imageNamed:@"collection_highlight"] forState:UIControlStateHighlighted];
    [_favoriteView addSubview:collectionImageView];

    UIButton *musicImageView = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth/4, btnHeight/8, btnWidth/2, btnHeight/2)];
    [musicImageView setBackgroundImage:[UIImage imageNamed:@"musicControl_normal"] forState:UIControlStateNormal];
    [musicImageView setBackgroundImage:[UIImage imageNamed:@"musicControl_highlight"] forState:UIControlStateHighlighted];
    [_musicControlView addSubview:musicImageView];

    UIButton *shareImageView = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth/4, btnHeight/8, btnWidth/2, btnHeight/2)];
    [shareImageView setBackgroundImage:[UIImage imageNamed:@"share_normal"] forState:UIControlStateNormal];
    [shareImageView setBackgroundImage:[UIImage imageNamed:@"share_highlight"] forState:UIControlStateHighlighted];
    //     [shareImageView addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:shareImageView];

    UIButton *picSaveImageView = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth/4, btnHeight/8, btnWidth/2, btnHeight/2)];
    [picSaveImageView setBackgroundImage:[UIImage imageNamed:@"pictureSave_normal"] forState:UIControlStateNormal];
    [picSaveImageView setBackgroundImage:[UIImage imageNamed:@"pictureSave_highlight"] forState:UIControlStateHighlighted];
    //     [picSaveImageView addTarget:self action:@selector(savePictureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_savePictureView addSubview:picSaveImageView];

    self.buttonArray = @[collectionImageView,musicImageView,shareImageView,picSaveImageView];

    UILabel *collectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth/4, btnHeight * 6/8, btnWidth/2, btnHeight/8)];
    collectionLabel.text = @"暂停";
    center = collectionLabel.center;
    [collectionLabel sizeToFit];
    collectionLabel.center = center;
    collectionLabel.font = [UIFont fontWithName:@"Arial" size:14];
    collectionLabel.textAlignment = NSTextAlignmentCenter;
    collectionLabel.textColor = [UIColor colorWithRed:54/255 green:54/255 blue:54/255 alpha:1];
    [_favoriteView addSubview:collectionLabel];

    UILabel *musicLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth/4, btnHeight * 6/8, btnWidth/2, btnHeight/8)];
    musicLabel.text = @"音乐";
    center = musicLabel.center;
    [musicLabel sizeToFit];
    musicLabel.center = center;
    musicLabel.font = [UIFont fontWithName:@"Arial" size:14];
    musicLabel.textAlignment = NSTextAlignmentCenter;
    musicLabel.textColor = [UIColor colorWithRed:54/255 green:54/255 blue:54/255 alpha:1];
    [_musicControlView addSubview:musicLabel];

    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth/4, btnHeight * 6/8, btnWidth/2, btnHeight/8)];
    shareLabel.text = @"分享";
    center = shareLabel.center;
    [shareLabel sizeToFit];
    shareLabel.center = center;
    shareLabel.font = [UIFont fontWithName:@"Arial" size:14];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.textColor = [UIColor colorWithRed:54/255 green:54/255 blue:54/255 alpha:1];
    [_shareView addSubview:shareLabel];

    UILabel *picSaveLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth/4, btnHeight * 6/8, btnWidth/2, btnHeight/8)];
    picSaveLabel.text = @"图片";
    picSaveLabel.font = [UIFont fontWithName:@"Arial" size:14];
    picSaveLabel.textAlignment = NSTextAlignmentCenter;
    picSaveLabel.textColor = [UIColor colorWithRed:54/255 green:54/255 blue:54/255 alpha:1];

    center = picSaveLabel.center;
    [picSaveLabel sizeToFit];
    picSaveLabel.center = center;
    [_savePictureView addSubview:picSaveLabel];

}

/*
 -(void)musicControlBtnClicked{
 if ([_delegate respondsToSelector:@selector(musicControlBtnClicked)]) {
 [_delegate musicControlBtnClicked];
 }else{
 NSLog(@"不响应播放音乐方法");
 }
 }

 -(void)favoriteBtnClicked{
 if ([_delegate respondsToSelector:@selector(favoriteBtnClicked)]) {
 [_delegate favoriteBtnClicked];
 }else{
 NSLog(@"不响应收藏点击事件");
 }
 }

 -(void)shareBtnClicked{
 if ([_delegate respondsToSelector:@selector(shareBtnClicked)]) {
 [_delegate shareBtnClicked];
 }else{
 NSLog(@"不响应分享点击事件");
 }

 }

 -(void)savePictureBtnClicked{
 if ([_delegate respondsToSelector:@selector(savePictureBtnClicked)]) {
 [_delegate savePictureBtnClicked];
 }else{
 NSLog(@"不响应图片保存点击事件");
 }

 }
 */


@end
