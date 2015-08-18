//
//  PunchViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "PunchViewController.h"
#import "Masonry.h"
#import "UIColor+Helper.h"
#import "TMPunch.h"
#import "TMTeam.h"

@interface PunchViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addPunch;
@property (weak, nonatomic) UIView *backdropView;
@property (weak, nonatomic) UIView *buttonsView;
@property (strong, nonatomic) NSArray *punchs;
@property (strong, nonatomic) NSArray *teams;
@end

@implementation PunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSArray *)punchs
{
    if (!_punchs) {
        _punchs = [TMPunch getAll];
    }
    
    return _punchs;
}

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam getAll];
    }
    return _teams;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < -50) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageUp" object:self];
    }
}

#pragma mark - table view delegate & data source

#define MAINLABEL_TAG 1
static float const buttonHeight = 60.0;

// 单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PunchCell";
    
    UILabel *mainLabel;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        mainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mainLabel.tag = MAINLABEL_TAG;
        mainLabel.font = [UIFont systemFontOfSize:20.0];
        mainLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:mainLabel];
    } else {
        mainLabel = (UILabel *)[cell.contentView viewWithTag:MAINLABEL_TAG];
    }
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRGBA:0xDDDDDDFF];
    } else {
        cell.backgroundColor = [UIColor colorWithRGBA:0xAAAAAAFF];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView);
        make.centerY.equalTo(cell.contentView);
    }];

    TMPunch *punch = [self.punchs objectAtIndex:indexPath.row];
    mainLabel.text = punch.content;

    return cell;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.punchs count];
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

// 点击触发事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *backdropView  = [[UIView alloc] initWithFrame:CGRectZero];
    self.backdropView = backdropView;
    backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
    
    // 按钮组
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bounds.size.height, self.tableView.bounds.size.width, buttonHeight * (self.teams.count + 1) + 1 * self.teams.count)];
    buttonsView.backgroundColor = [UIColor colorWithRGBA:0xAAAAAAFF];
    self.buttonsView = buttonsView;
    [self.backdropView addSubview:buttonsView];
    
    // 取消按钮
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitleColor:[UIColor colorWithRGBA:0x999999FF] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hideTeams:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(buttonsView);
        make.bottom.equalTo(buttonsView.mas_bottom).with.offset(0.0);
        make.height.equalTo([NSNumber numberWithInt:buttonHeight]);
    }];
    
    // 团队选择按钮
    for (int i = 0; i < self.teams.count; i++) {
        TMTeam *team = self.teams[i];
        UIButton *teamButton = [[UIButton alloc] init];
        [teamButton setTitle:team.name forState:UIControlStateNormal];
        teamButton.backgroundColor = [UIColor whiteColor];
        [teamButton setTitleColor:[UIColor colorWithRGBA:0x000000FF] forState:UIControlStateNormal];
        [teamButton addTarget:self action:@selector(hideTeams:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:teamButton];
        [teamButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(buttonsView);
            make.bottom.equalTo(buttonsView.mas_bottom).with.offset(-(buttonHeight + 1) * (i + 1));
            make.height.equalTo([NSNumber numberWithInt:buttonHeight]);
        }];
    }
    
    [self.view insertSubview:backdropView aboveSubview:self.addPunch];
    [backdropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CGRect newFrame = buttonsView.frame;
    newFrame.origin.y = newFrame.origin.y - newFrame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        buttonsView.frame = newFrame;
        backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
    }];
}

// 隐藏团队按钮
- (void)hideTeams:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.buttonsView.frame = CGRectMake(0, self.tableView.bounds.size.height, self.tableView.bounds.size.width, buttonHeight * (self.teams.count + 1) + 1 * self.teams.count);
        self.backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
    } completion:^(BOOL finished) {
        [self.backdropView removeFromSuperview];
    }];
}

@end
