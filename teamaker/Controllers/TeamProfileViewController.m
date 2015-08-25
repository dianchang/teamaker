//
//  TeamProfileViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/25.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TeamProfileViewController.h"
#import "TMTeam.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TeamProfileViewController ()

@property (strong, nonatomic) NSNumber *teamId;
@property (strong, nonatomic) TMTeam *team;

@end

@implementation TeamProfileViewController

- (instancetype)initWithTeamId:(NSNumber *)teamId
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.teamId = teamId;
    
    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (TMTeam *)team
{
    if(!_team) {
        _team = [TMTeam MR_findFirstByAttribute:@"id" withValue:self.teamId];
    }
    
    return _team;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.team.name;
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
