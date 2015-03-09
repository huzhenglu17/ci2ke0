//
//  OneDayScrollView.h
//  cike2_0
//
//  Created by BossTiao on 14/12/26.
//  Copyright (c) 2014年 lg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOnedayViewScrollNotification @"OnedayViewScroll"

@class FMDatabase;
@interface OneDayScrollView : UIScrollView

//界面
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIWebView   *webView;
@property (nonatomic,strong)UITextView  *textView;

//数据
@property (nonatomic,strong)NSDate  *thisViewDate;

@property(nonatomic,strong)FMDatabase *user_db;

@property (nonatomic,copy)NSString *musicTitle;

@end
