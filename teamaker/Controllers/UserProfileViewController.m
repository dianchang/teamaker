//
//  UserProfileViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/25.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TMUser.h"
#import <MagicalRecord/MagicalRecord.h>

@interface UserProfileViewController ()
@property (nonatomic) NSNumber *userId;
@property (strong, nonatomic) TMUser *user;
@end

@implementation UserProfileViewController

- (instancetype)initWithUserId:(NSNumber *)userId
{
    self = [super init];
    
    if (self) {
        self.userId = userId;
    }

    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.user.name;
}

- (TMUser *)user
{
    if (!_user) {
        _user = [TMUser MR_findFirstByAttribute:@"id" withValue:self.userId];
    }
    
    return _user;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
