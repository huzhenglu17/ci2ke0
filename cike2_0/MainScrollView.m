//
//  MainScrollView.m
//  cike2_0
//
//  Created by BossTiao on 14/12/26.
//  Copyright (c) 2014年 lg. All rights reserved.
//

#import "MainScrollView.h"
#import "OneDayScrollView.h"
#import "FMDB.h"
#import "NSDate+convenience.h"

@interface MainScrollView ()<UIScrollViewDelegate>
{
    BOOL isInitialFinished;
}

@end

@implementation MainScrollView
-(FMDatabase *)user_db{
    if (_user_db == nil) {
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* dbpath = [docsdir stringByAppendingPathComponent:@"user.sqlite"];
        _user_db = [FMDatabase databaseWithPath:dbpath];
    }
    return _user_db;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //initview
        self.presentDayScroll = [[OneDayScrollView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height)];
        [self addSubview:self.presentDayScroll];

        self.nextDayScroll = [[OneDayScrollView alloc] initWithFrame:CGRectMake(0, frame.size.height*2, frame.size.width, frame.size.height)];
        [self addSubview:self.nextDayScroll];

        self.lastDayScroll = [[OneDayScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.lastDayScroll];

        //setDate
        NSDate *today = [NSDate date];
        isInitialFinished = NO;
        [self.presentDayScroll setThisViewDate:[today dateByAddingTimeInterval:-60*60*24]];
        [self.lastDayScroll setThisViewDate:[today dateByAddingTimeInterval:-2*60*60*24]];
        [self.nextDayScroll setThisViewDate:today];

        self.contentSize = CGSizeMake(frame.size.width, frame.size.height*3);
        [self setOffset];
        self.delegate = self;
        self.contentOffset =CGPointMake(0, self.frame.size.height*2);
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:255 green:251 blue:247 alpha:1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getT_Article_updatedNotification) name:@"T_Article_updated" object:nil];

    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getT_Article_updatedNotification{
    NSDate *today = [NSDate date];
    if (self.nextDayScroll.thisViewDate.day == today.day &&
        self.nextDayScroll.thisViewDate.month == today.month &&
        self.nextDayScroll.thisViewDate.year == today.year  &&
        self.contentOffset.y == self.frame.size.height*2) {
        self.currentMusicTitleString = self.nextDayScroll.musicTitle;
    }else{
        self.currentMusicTitleString = self.presentDayScroll.musicTitle;
    }
}

-(void)setOffset{
    [self.presentDayScroll setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [self.nextDayScroll setFrame:CGRectMake(0, self.frame.size.height*2, self.frame.size.width, self.frame.size.height)];
    [self.lastDayScroll setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.contentOffset = CGPointMake(0, self.frame.size.height);
}

#pragma mark 滑动代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    isInitialFinished = YES;
    if (self.contentOffset.y == self.frame.size.height*2) {
        //滑到下一天
        //如果滑动到今天
        NSDate *today = [NSDate date];
        if (self.nextDayScroll.thisViewDate.day == today.day &&
            self.nextDayScroll.thisViewDate.month == today.month &&
            self.nextDayScroll.thisViewDate.year == today.year) {
            self.currentMusicTitleString = self.nextDayScroll.musicTitle;
            return;
        }
        OneDayScrollView *tmpPointer = self.lastDayScroll;
        self.lastDayScroll = self.presentDayScroll;
        self.presentDayScroll = self.nextDayScroll;
        self.nextDayScroll = tmpPointer;
        [self.nextDayScroll setThisViewDate:[self.presentDayScroll.thisViewDate dateByAddingTimeInterval:60*60*24]];
        [self setOffset];
    }else if(self.contentOffset.y == 0){
        //滑到上一天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *firstDate = [formatter dateFromString:@"2014-08-28"];
        //如果滑动到最早的一天
        if (self.lastDayScroll.thisViewDate.month == firstDate.month &&
            self.lastDayScroll.thisViewDate.day == firstDate.day &&
            self.lastDayScroll.thisViewDate.year == firstDate.year) {
            self.currentMusicTitleString = self.lastDayScroll.musicTitle;
            return;
        }
        OneDayScrollView *tmpPointer = self.nextDayScroll;
        self.nextDayScroll = self.presentDayScroll;
        self.presentDayScroll = self.lastDayScroll;
        self.lastDayScroll = tmpPointer;
        [self.lastDayScroll setThisViewDate:[self.presentDayScroll.thisViewDate dateByAddingTimeInterval:-60*60*24]];
        [self setOffset];

    }
    self.currentMusicTitleString = self.presentDayScroll.musicTitle;
}


@end
