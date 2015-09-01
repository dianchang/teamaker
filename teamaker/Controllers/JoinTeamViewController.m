//
//  JoinTeamViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/31.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "JoinTeamViewController.h"
#import "Masonry.h"
#import "Constants.h"
#import "UIColor+Helper.h"

@interface JoinTeamViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation JoinTeamViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor TMBackgroundColorGray];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"加入圈子";
}

# pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configCell:cell withText:@"扫二维码"];
        } else if (indexPath.row == 1) {
            [self configCell:cell withText:@"通过邀请码"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configCell:cell withText:@"面对面，建圈子"];
        }
    }
    
    return cell;
}

// 配置cell
- (void)configCell:(UITableViewCell *)cell withText:(NSString *)text
{
    UILabel *textLabel = [UILabel new];
    textLabel.text = text;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor colorWithRGBA:0x666666FFF];
    [cell.contentView addSubview:textLabel];

    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
    }];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

// 单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
        
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
        
        }
    }
}

@end
