//
//  MainScrollView.h
//  cike2_0
//
//  Created by BossTiao on 14/12/26.
//  Copyright (c) 2014年 lg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMDatabase;
@class OneDayScrollView;

@interface MainScrollView : UIScrollView

@property(nonatomic,strong)FMDatabase *user_db;

@property(nonatomic,strong)OneDayScrollView *lastDayScroll;
@property(nonatomic,strong)OneDayScrollView *presentDayScroll;
@property(nonatomic,strong)OneDayScrollView *nextDayScroll;

@property (nonatomic,copy)NSString *currentMusicTitleString;

@end
