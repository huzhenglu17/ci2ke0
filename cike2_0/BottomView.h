//
//  BottomView.h
//  cike
//
//  Created by jiangjie on 14-9-26.
//  Copyright (c) 2014年 liugang. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 @protocol BtnClickedDelegate <NSObject>

 @optional
 -(void)musicControlBtnClicked;
 -(void)favoriteBtnClicked;
 -(void)shareBtnClicked;
 -(void)savePictureBtnClicked;

 @end
 */

@interface BottomView : UIView

@property (weak, nonatomic) IBOutlet UIView *favoriteView;
@property (weak, nonatomic) IBOutlet UIView *musicControlView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *savePictureView;

@property (nonatomic,strong)NSArray *buttonArray;
//@property (nonatomic,weak) id<BtnClickedDelegate> delegate;

@end
