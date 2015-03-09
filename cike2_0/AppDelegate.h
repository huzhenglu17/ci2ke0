//
//  AppDelegate.h
//  cike2_0
//
//  Created by BossTiao on 14/12/26.
//  Copyright (c) 2014年 lg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STKAudioPlayer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void) audioPlayerViewPlayFromHTTPSelectedWithUrl:(NSURL*)httpUrl;

-(void) audioPlayerViewPlayFromLocalFileSelectedWithFilePath:(NSString*)filePath;

-(STKAudioPlayer*)audioPlayer;


@end

