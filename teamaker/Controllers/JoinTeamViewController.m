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

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation JoinTeamViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [UITableView new];
    tableView.backgroundColor = [UIColor TMBackgroundColorGray];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"加入圈子";
}

# pragma mark - tableview delegate

static NSString * const cellIdentifier = @"identifier";

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.row) {
        case 0: {
            [self configGapCell:cell];
            break;
        }
            
        case 1: {
            [self configCell:cell withText:@"扫二维码"];
            break;
        }
            
        case 2: {
            [self configCell:cell withText:@"通过邀请码"];
            break;
        }
            
        case 3: {
            [self configGapCell:cell];
            break;
        }
            
        case 4: {
            [self configCell:cell withText:@"面对面，建圈子"];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

// 配置作为分隔符的cell
- (void)configGapCell:(UITableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *innerView = [UIView new];
    innerView.backgroundColor = [UIColor TMBackgroundColorGray];
    [cell.contentView addSubview:innerView];
    
    [innerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
}

// 配置普通cell
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
    CGFloat height;
    
    switch (indexPath.row) {
        case 0 :
        case 3 : {
            height = 20;
            break;
        }
            
        case 1:
        case 2:
        case 4: {
            height = 45;
            break;
        }
            
        default:
            height = 0;
            break;
    }

    return height;
}

// 单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 1: {
            break;
        }
            
        case 2: {
            break;
        }
            
        case 4: {
            break;
        }
            
        default:
            break;
    }
}

@end
