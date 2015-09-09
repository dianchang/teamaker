//
//  CreateTeamViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/31.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CreateTeamViewController.h"
#import "AddTeamMemberViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "TMUser.h"
#import "TMTeam.h"
#import "TMTeamUserInfo.h"
#import "Masonry.h"
#import "UIColor+Helper.h"
#import "Ionicons.h"

@interface CreateTeamViewController ()

@property (strong, nonatomic) TMUser *loggedInUser;
@property (strong, nonatomic) NSString *teamName;
@property (strong, nonatomic) UITextField *teamNameTextField;

@end

@implementation CreateTeamViewController

- (void)loadView
{
    self.view = [UIView new];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    
    // 团队头像
    UIView *imageWapView = [UIView new];
    imageWapView.layer.cornerRadius = 2;
    imageWapView.layer.masksToBounds = YES;
    imageWapView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:imageWapView];
    UITapGestureRecognizer *gestureForImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageWapDidTapped)];
    gestureForImage.numberOfTapsRequired = 1;
    imageWapView.userInteractionEnabled = YES;
    
    UIImageView *imageView = [UIImageView new];
    [imageWapView addSubview:imageView];
    imageView.backgroundColor = [UIColor colorWithRGBA:0x333333FF];
    imageView.layer.cornerRadius = 2;
    imageView.layer.masksToBounds = YES;
    
    UIImage *cameraImage = [IonIcons imageWithIcon:ion_camera iconColor:[UIColor colorWithRGBA:0x333333FF] iconSize:14 imageSize:CGSizeMake(21, 14)];
    UIImageView *cameraImageView = [[UIImageView alloc] initWithImage:cameraImage];
    cameraImageView.layer.cornerRadius = 5;
    cameraImageView.layer.masksToBounds = YES;
    cameraImageView.backgroundColor = [UIColor grayColor];
    [imageWapView addSubview:cameraImageView];
    
    // 团队名称输入框
    UITextField *textField = [UITextField new];
    self.teamNameTextField = textField;
    textField.textColor = [UIColor whiteColor];
    [self.view addSubview:textField];
    textField.placeholder = @"输入圈子名称";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入圈子名称" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 约束
    [imageWapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.width.height.equalTo(@70);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageWapView);
        make.width.height.equalTo(@66);
    }];
    
    [cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageWapView);
        make.bottom.equalTo(imageWapView).offset(-1);
    }];
     
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(80);
        make.right.equalTo(self.view).offset(-80);
        make.top.equalTo(imageWapView.mas_bottom).offset(25);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"创建圈子";
    
    // 继续按钮
    UIBarButtonItem *continueButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"继续" style:UIBarButtonItemStylePlain target:self action:@selector(redirectToAddTeamMemberView)];
    self.navigationItem.rightBarButtonItem = continueButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.teamNameTextField becomeFirstResponder];
}

# pragma mark - private methods

- (void)imageWapDidTapped
{
}

- (void)textFieldDidChange:(id)sender
{
    if (!self.teamNameTextField.text.length) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

/**
 *  创建团队，并跳转成员添加页
 */
- (void)redirectToAddTeamMemberView
{
//    __block TMTeam *team;
    
    if (!self.teamNameTextField.text.length) {
        return;
    }
    
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//        team = [TMTeam MR_createEntityInContext:localContext];
//        team.idValue = [TMTeam findMaxIdValue] + 1;
//        team.name = self.teamNameTextField.text;
//        team.avatar = @"http://www.blogbar.cc/static/image/apple-touch-icon-precomposed-152.png";
//    } completion:^(BOOL contextDidSave, NSError *error) {
//        UIViewController *controller = [[AddTeamMemberViewController alloc] initWithTeamId:team.id];
//        [self.navigationController pushViewController:controller animated:YES];
//    }];
    
    UIViewController *controller = [[AddTeamMemberViewController alloc] initWithTeamId:@3];
    [self.navigationController pushViewController:controller animated:YES];
}

# pragma mark - getters and setters

- (TMUser *)loggedInUser
{
    if (_loggedInUser) {
        _loggedInUser = [TMUser findLoggedInUser];
    }
    
    return _loggedInUser;
}

@end
