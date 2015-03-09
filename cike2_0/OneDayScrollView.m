//
//  OneDayScrollView.m
//  cike2_0
//
//  Created by BossTiao on 14/12/26.
//  Copyright (c) 2014年 lg. All rights reserved.
//

#import "OneDayScrollView.h"
#import <BmobSDK/Bmob.h>
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "FMDB.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "SuiBiTitleView.h"
#import "BottomView.h"

#define kTitleHeight 64


@interface OneDayScrollView ()<UIScrollViewDelegate,UITextViewDelegate>


@property(nonatomic,copy)NSString *timeString ;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)SuiBiTitleView *titleView;
@property(nonatomic,assign)BOOL isBottomViewPresent;

@end

@implementation OneDayScrollView

-(MBProgressHUD *)hud{
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.webView];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"加载中...";
        [self.webView addSubview:_hud];
    }
    [self bringSubviewToFront:_hud];
    return _hud;
}
-(FMDatabase *)user_db{
    if (_user_db == nil) {
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* dbpath = [docsdir stringByAppendingPathComponent:@"user.sqlite"];
        _user_db = [FMDatabase databaseWithPath:dbpath];

        //创建表
        if ([_user_db open]) {
            NSString* createTable = @"CREATE TABLE IF NOT EXISTS T_Article(title text , desc text , time text primary key, author text , musicUrl text , imageUrl text , webUrl text , diary text , webcontent text ,imageToShareUrl text)";
            [_user_db executeUpdate:createTable];
            [_user_db close];
        }
    }
    return _user_db;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentSize:CGSizeMake(frame.size.width*3, frame.size.height)];
        self.delegate = self;
        //图片视图
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_imageView setImage:[UIImage imageNamed:@"default-image-1920"]];
        [self addSubview:_imageView];

        //网页文字视图
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.size.width, 20, frame.size.width, frame.size.height)];
        _webView.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        _webView.backgroundColor = [UIColor clearColor];
        [self addSubview:_webView];

        //随笔视图
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(frame.size.width*2, kTitleHeight, frame.size.width, frame.size.height)];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];

        _titleView = [[SuiBiTitleView alloc] initWithFrame:CGRectMake(frame.size.width*2, 0, frame.size.width, kTitleHeight)];
        [_titleView.backBtn addTarget:self action:@selector(scrollToWebContent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_titleView];

        //音乐名称和下方选项视图
        [self setPagingEnabled:YES];
        [self setBounces:NO];

        //初始化图片点击事件
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped)];
        self.isBottomViewPresent = NO;
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tapImage];
        self.backgroundColor = [UIColor colorWithRed:255 green:251 blue:247 alpha:1];


    }
    return self;
}

-(void)imageTaped{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kImageTaped" object:nil];
}

//从数据库中取出随笔
-(void)getSuibiContentFromDB{
    __block NSString *diaryString = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self.user_db open]) {
            diaryString = [self.user_db stringForQuery:@"select diary from T_Article where time=?",self.timeString];
            [self.user_db close];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (diaryString != nil && ![diaryString isEqualToString:@""]) {
                self.textView.text = diaryString;
            }
        });
    });
}


-(void)scrollToWebContent{

    [_textView resignFirstResponder];
    [self scrollRectToVisible:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height) animated:YES];
}

#pragma mark 设置指定日期的数据
-(void)setThisViewDate:(NSDate *)thisViewDate{
    _thisViewDate = thisViewDate;
    [self getDataFromBmob];
    [self showImageView];
    [self showWebView];

}

//将图片显示在界面
-(void)showImageView{
    __block NSString *pictureUrl = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self.user_db open]) {
            pictureUrl = [self.user_db stringForQuery:@"select imageUrl from T_Article where time=?",self.timeString];
            [self.user_db close];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (pictureUrl == nil || [pictureUrl isEqualToString:@""]) {
                _imageView.image = [UIImage imageNamed:@"default-image-1920"];
            }else{
                _imageView.image = nil;
                [_imageView sd_setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:[UIImage imageNamed:@"default-image-1920"]];
            }
        });

    });
}

//显示网页文本
-(void)showWebView{
    __block NSString *webContent = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self.user_db open]) {
            webContent = [self.user_db stringForQuery:@"select webcontent from T_Article where time=?",self.timeString];
            [self.user_db close];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (webContent == nil || [webContent isEqualToString:@""]) {
                [self.hud show:NO];
            }else {
                [self.hud hide:NO];
                [self.webView loadHTMLString:webContent baseURL:nil];
            }
        });
    });
}

//从网络获取数据到本地
-(void)getDataFromBmob{
    //转换日期为string
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    self.timeString = [dateformatter stringFromDate:_thisViewDate];

    BmobQuery *bquery = [BmobQuery queryWithClassName:@"T_Article"];
    [bquery whereKey:@"time" equalTo:self.timeString];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {

        //显示以前的随笔
        [self getSuibiContentFromDB];
        //找到数据
        BmobObject *bmobObject = [array firstObject];
        NSLog(@"%@",[bmobObject objectForKey:@"author"]);

        //显示图片
        BmobFile *sourceImage = (BmobFile*)[bmobObject objectForKey:@"image"];
        [self showImageView];

        //保存待分享的图片
        [BmobImage thumbnailImageBySpecifiesTheWidth:120
                                              height:120
                                             quality:100
                                      sourceImageUrl:sourceImage.url
                                          outputType:kBmobImageOutputBmobFile
                                         resultBlock:^(id object, NSError *error) {
                                             BmobFile *shareimage = (BmobFile*)object;
                                             //保存待分享图片的地址
                                             dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                 if ([self.user_db open]) {
                                                     [self.user_db executeUpdate:@"update T_Article set imageToShareUrl=? where time=?",shareimage.url,[bmobObject objectForKey:@"time"]];
                                                     [self.user_db close];
                                                 }
                                             });
                                         }];

//获取web页面的文章内容
        NSString *webUrl = [bmobObject objectForKey:@"web"];
        NSURL *URL = [NSURL URLWithString:webUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseHtml = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *contentString = [self cutHtmlString:responseHtml];
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if ([self.user_db open]) {
                    [self.user_db executeUpdate:@"update T_Article set webcontent=? where time=?",contentString,[bmobObject objectForKey:@"time"]];
                    [self.user_db close];
                }
                [self showWebView];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [[NSOperationQueue mainQueue] addOperation:op];

        self.musicTitle = [bmobObject objectForKey:@"title"];
        //保存音乐地址
        BmobFile *music = [bmobObject objectForKey:@"music"];

        //        将数据存入sqlite
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([self.user_db open]) {
                [self.user_db executeUpdate:@"replace into T_Article(title  , desc  , time  , author , musicUrl  , imageUrl  , webUrl ) values(?,?,?,?,?,?,?);",
                 [bmobObject objectForKey:@"title"],
                 [bmobObject objectForKey:@"desc"],
                 [bmobObject objectForKey:@"time"],
                 [bmobObject objectForKey:@"author"],
                 music.url,
                 sourceImage.url,
                 [bmobObject objectForKey:@"web"]];
                [self.user_db close];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"T_Article_updated" object:nil];
        });


    }];
}

//切割html字符串
-(NSString *)cutHtmlString:(NSString*)sourceStr{
    NSString *destinationStr = [[sourceStr componentsSeparatedByString:@"<div class=\"rich_media_content\" id=\"js_content\">"] lastObject];
    destinationStr = [[destinationStr componentsSeparatedByString:@"<p><img"] firstObject];
    return destinationStr;
}


#pragma mark 滑动代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnedayViewScrollNotification object:nil];
    [_textView resignFirstResponder];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    id superView = self.superview;
    if ([superView isKindOfClass:[UIScrollView class]]) {
        if ([self contentOffset].x!=0 ) {
            [(UIScrollView*)superView setScrollEnabled:NO];
        }else{
            [(UIScrollView*)superView setScrollEnabled:YES];
        }
    }
}

#pragma mark 文字变动代理
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //        将数据存入sqlite
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self.user_db open]) {
            [self.user_db executeUpdate:@"update T_Article set diary=? where time=?",self.textView.text,self.timeString];
            [self.user_db close];
        }
    });
    return YES;
}


@end
