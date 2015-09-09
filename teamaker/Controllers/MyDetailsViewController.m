//
//  MyDetailsViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/26.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "MyDetailsViewController.h"
#import "TMUser.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import <MagicalRecord/MagicalRecord.h>
#import "UIColor+Helper.h"

@interface MyDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) TMUser *loggedInUser;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MyDetailsViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor TMBackgroundColorGray];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
}

#pragma mark - table view delegate and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return 4;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configTableViewCell:cell key:@"头像" imageUrl:[NSURL URLWithString:self.loggedInUser.avatar]];
        } else if (indexPath.row == 1) {
            [self configTableViewCell:cell key:@"名字" value:self.loggedInUser.name];
        } else if (indexPath.row == 2) {
            [self configTableViewCell:cell key:@"性别" value:self.loggedInUser.sex];
        } else if (indexPath.row == 3) {
            [self configTableViewCell:cell key:@"地区" value:self.loggedInUser.province];
        } else if (indexPath.row == 4) {
            [self configTableViewCell:cell key:@"个性签名" value:self.loggedInUser.motto];
        }
    } else if (indexPath.section == 1) {    // 其他
        if (indexPath.row == 0) {
            [self configTableViewCell:cell key:@"手机号" value:self.loggedInUser.phone];
        } else if (indexPath.row == 1) {
            [self configTableViewCell:cell key:@"微信" value:self.loggedInUser.wechat];
        } else if (indexPath.row == 2) {
            [self configTableViewCell:cell key:@"邮箱" value:self.loggedInUser.email];
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"+ 添加更多联系方式";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    } else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)configTableViewCell:(UITableViewCell *)cell key:(NSString *)key value:(NSString *)value
{
    UILabel *keyLabel = [UILabel new];
    keyLabel.text = key;
    keyLabel.textColor = [UIColor grayColor];
    keyLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:keyLabel];
    
    UILabel *valueLabel = [UILabel new];
    valueLabel.text = value;
    valueLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:valueLabel];
    
    // 约束
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(15);
        make.width.equalTo(@80);
    }];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(keyLabel.mas_right);
    }];
}

- (void)configTableViewCell:(UITableViewCell *)cell key:(NSString *)key imageUrl:(NSURL *)url
{
    UILabel *keyLabel = [UILabel new];
    keyLabel.text = key;
    keyLabel.textColor = [UIColor grayColor];
    keyLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:keyLabel];
    
    UIImageView *imageView = [UIImageView new];
    [imageView setImageWithURL:url];
    imageView.layer.cornerRadius = 25;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    // 约束
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(15);
        make.width.equalTo(@80);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.left.equalTo(keyLabel.mas_right);
    }];
}

#pragma mark - getters and setters

- (TMUser *)loggedInUser
{
    if (!_loggedInUser) {
        _loggedInUser = [TMUser findLoggedInUser];
    }
    
    return _loggedInUser;
}


@end
