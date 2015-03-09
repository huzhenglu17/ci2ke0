//
//  SuiBiTitleView.m
//  cike2_0
//
//  Created by BossTiao on 14/12/27.
//  Copyright (c) 2014年 lg. All rights reserved.
//

#import "SuiBiTitleView.h"

@implementation SuiBiTitleView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _backBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 20, 40, 40);
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"note_return"] forState:UIControlStateNormal];
        [self addSubview:_backBtn];


        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height-20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"随笔";
//        _titleLabel.textColor = [UIColor colorWithRed:66 green:61 blue:58 alpha:1];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];

        self.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

@end
