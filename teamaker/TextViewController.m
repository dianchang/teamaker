//
//  TextViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/18.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TextViewController.h"
#import "Masonry.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.view = [[UIView alloc] init];
        
        // 文字编辑
        UITextView *textView = [[UITextView alloc] init];
        [self.view addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(20);
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
