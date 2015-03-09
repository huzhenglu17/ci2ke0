//
//  CustomWebView.m
//  cike2_0
//
//  Created by BossTiao on 14/12/27.
//  Copyright (c) 2014年 lg. All rights reserved.
//

#import "CustomWebView.h"

@implementation CustomWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL{
    if (string == nil || [string isEqualToString:@""]) {
        
    }else{
        [super loadHTMLString:string baseURL:baseURL];
    }
}

@end
