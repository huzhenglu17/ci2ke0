//
//  ViewController.m
//  cike2_0
//
//  Created by BossTiao on 14/12/26.
//  Copyright (c) 2014年 lg. All rights reserved.
//

#import "ViewController.h"
#import "MainScrollView.h"
#import "OneDayScrollView.h"
#import "BottomView.h"
#import "AppDelegate.h"
#import "AudioPlayerView.h"
#import <FMDB.h>

#define kBottomViewHeight 80/568

@interface ViewController (){
    CGFloat blurViewHeight;
}

@property(strong,nonatomic)MainScrollView *mainScrollView;
@property(nonatomic,strong)UILabel *musicTitleLabel;
@property(nonatomic,strong)UIView *blurTitleView;
@property(nonatomic,strong)BottomView *bottomView;
@end

@implementation ViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.mainScrollView removeObserver:self forKeyPath:@"currentMusicTitleString" context:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _mainScrollView = [[MainScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_mainScrollView];
    self.view.backgroundColor = [UIColor colorWithRed:255 green:251 blue:247 alpha:1];

    _musicTitleLabel = [[UILabel alloc] init];
    _musicTitleLabel.backgroundColor = [UIColor clearColor];
    _musicTitleLabel.textColor = [UIColor colorWithRed:100/255 green:100/255 blue:100/255 alpha:1];
    _musicTitleLabel.font = [UIFont fontWithName:@"Arial" size:16];
    _musicTitleLabel.textAlignment = NSTextAlignmentCenter;


    _blurTitleView = [[UIView alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] init];
    blurViewHeight =navi.navigationBar.frame.size.height  + [[UIApplication sharedApplication] statusBarFrame].size.height;
    _blurTitleView.frame = CGRectMake(0,-blurViewHeight, self.view.frame.size.width, blurViewHeight);
    _blurTitleView.alpha = 0.5;
    _blurTitleView.backgroundColor = [UIColor whiteColor];
    _blurTitleView.hidden = YES;

    CGFloat const statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    _musicTitleLabel.frame = CGRectMake(0, statusBarHeight, _blurTitleView.frame.size.width, _blurTitleView.frame.size.height-statusBarHeight);
    [_blurTitleView addSubview:_musicTitleLabel];
    [self.view addSubview:_blurTitleView];


    self.bottomView = [[[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:self options:nil] objectAtIndex:0];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.alpha = 0.7;
    self.bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.height* kBottomViewHeight);
    [self.view addSubview:self.bottomView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImageTaped) name:@"kImageTaped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOnedayViewScroll) name:kOnedayViewScrollNotification object:nil];
    [self.mainScrollView addObserver:self forKeyPath:@"currentMusicTitleString" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (UIButton *button in self.bottomView.buttonArray) {
        [button addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//底部按钮的事件
-(void)bottomBtnClicked:(UIButton*)button{
    NSUInteger buttonIndex = [self.bottomView.buttonArray indexOfObject:button];
    switch (buttonIndex) {
        case 0:{
            AppDelegate *delegateInstance = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if (delegateInstance.audioPlayer.state == STKAudioPlayerStatePlaying) {
                [delegateInstance.audioPlayer pause];

            }else if (delegateInstance.audioPlayer.state == STKAudioPlayerStatePaused){
                [delegateInstance.audioPlayer resume];
            }
        }
            break;
        case 1:
        {
            AppDelegate *delegateInstance = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if (delegateInstance.audioPlayer.state == STKAudioPlayerStatePaused) {
                [delegateInstance.audioPlayer resume];
            }else {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *playMusicTime = [formatter stringFromDate:self.mainScrollView.presentDayScroll.thisViewDate];
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if (![self.mainScrollView.presentDayScroll.user_db open]) {
                        NSLog(@"self.mainScrollView.presentDayScroll.user_db open fail!");
                    }
                    NSString *musicString = [self.mainScrollView.presentDayScroll.user_db stringForQuery:@"select musicUrl from T_Article where time=?",playMusicTime];
                    [delegateInstance audioPlayerViewPlayFromHTTPSelectedWithUrl:[NSURL URLWithString:musicString]];
                    [self.mainScrollView.presentDayScroll.user_db close];
                });
            }
        }
            break;

        default:
            break;
    }

}

-(void)getImageTaped{
    if (_blurTitleView.hidden == YES) {
        _blurTitleView.hidden = NO;
        self.bottomView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _blurTitleView.frame = CGRectMake(0, 0, self.view.frame.size.width, blurViewHeight);
            self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - self.view.frame.size.height* kBottomViewHeight, self.view.frame.size.width, self.view.frame.size.height* kBottomViewHeight);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _blurTitleView.frame = CGRectMake(0, -blurViewHeight, self.view.frame.size.width, blurViewHeight);
            self.bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            _blurTitleView.hidden = YES;
            self.bottomView.hidden = YES;
        }];
    }
}

-(void)getOnedayViewScroll{
    if (_blurTitleView.hidden == NO){
        [UIView animateWithDuration:0.3 animations:^{
            _blurTitleView.frame = CGRectMake(0, -blurViewHeight, self.view.frame.size.width, blurViewHeight);
            self.bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            _blurTitleView.hidden = YES;
            self.bottomView.hidden = YES;
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"currentMusicTitleString"]) {
        // 这里写相关的观察代码
        _musicTitleLabel.text = self.mainScrollView.currentMusicTitleString;

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}


@end
