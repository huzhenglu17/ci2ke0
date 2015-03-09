//
//  AppDelegate.m
//  cike
//
//  Created by BossTiao on 14-9-25.
//  Copyright (c) 2014年 liugang. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import "STKAudioPlayer.h"
#import "SampleQueueId.h"
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate ()
{
    STKAudioPlayer* audioPlayer;
}

@end

@implementation AppDelegate

-(STKAudioPlayer *)audioPlayer{
    return audioPlayer;
}
#pragma mark audioPlayerViewDelegate

-(void) audioPlayerViewPlayFromHTTPSelectedWithUrl:(NSURL*)httpUrl
{

    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:httpUrl];

    [audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:httpUrl andCount:0]];
}



-(void) audioPlayerViewPlayFromLocalFileSelectedWithFilePath:(NSString*)filePath
{

    NSURL* url = [NSURL fileURLWithPath:filePath];

    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];

    [audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

-(BOOL) canBecomeFirstResponder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //注册bmob以使用
    [Bmob registerWithAppKey:@"a289dc1a3da312533851e1ab1b6363c6"];

    //设置音频播放
    NSError* error;

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];

    Float32 bufferLength = 0.1;
    AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(bufferLength), &bufferLength);

    audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    audioPlayer.meteringEnabled = YES;
    audioPlayer.volume = 1;
//    demo代码
//    AudioPlayerView* audioPlayerView = [[AudioPlayerView alloc] initWithFrame:self.window.bounds andAudioPlayer:audioPlayer];
//    audioPlayerView.delegate = self;
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    [self becomeFirstResponder];
//    [self.window addSubview:audioPlayerView];
//    [self.window makeKeyAndVisible];

    return YES;
}

/*
-(void)registerShareSDK{
    [ShareSDK registerApp:@"28341e6e2880"];

    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wxce93556d83c50e81"
                           wechatCls:[WXApi class]];

    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1101876921"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];

    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"669958546"
                               appSecret:@"ab60eec718caf037dd06f21cb3d7d158"
                             redirectUri:@"http://www.baidu.com"];

    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    //    [ShareSDK  connectSinaWeiboWithAppKey:@"669958546"
    //                                appSecret:@"ab60eec718caf037dd06f21cb3d7d158"
    //                              redirectUri:@"http://www.baidu.com"
    //                              weiboSDKCls:[WeiboSDK class]];

}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

*/

@end
