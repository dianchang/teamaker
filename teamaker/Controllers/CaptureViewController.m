//
//  CaptureViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CaptureViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Masonry.h"
#import "TMTeam.h"
#import "UIColor+Helper.h"
#import "ComposeViewControllerProtocol.h"
#import "TeamButtons.h"
#import "Constants.h"
#import "IonIcons.h"
#import "CameraPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@interface CaptureViewController () <ComposeViewControllerProtocol>

@property (strong, nonatomic) UIView *imageView;
@property (strong, nonatomic) TeamButtons *teamButtons;
@property (strong, nonatomic) UIButton *captureButton;
@property (strong, nonatomic) UIButton *scanQRCodeButton;
@property (strong, nonatomic) UIButton *switchCameraButton;
@property (nonatomic, strong) NSArray *teams;

@property (strong, nonatomic) CameraPreviewView *previewView;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) BOOL deviceAuthorized;
@property (strong, nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureDevicePosition currentDevicePosition;

@end

@implementation CaptureViewController

- (void)loadView
{
    CameraPreviewView *previewView = [[CameraPreviewView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    previewView.backgroundColor = [UIColor lightGrayColor];
    self.view = previewView;
    self.previewView = previewView;
    
    // 照片
//    UIView *imageView = [[UIView alloc] init];
//    imageView.backgroundColor = [UIColor grayColor];
//    self.imageView = imageView;
//    [self.view addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
    // 二维码扫描按钮
    UIButton *scanQRCodeButton = [[UIButton alloc] init];
    UIImage *scanQRCodeButtonImage = [IonIcons imageWithIcon:ion_qr_scanner iconColor:[UIColor whiteColor] iconSize:23 imageSize:CGSizeMake(50.0f, 50.0f)];
    [scanQRCodeButton setImage:scanQRCodeButtonImage forState:UIControlStateNormal];
    [self.view addSubview:scanQRCodeButton];
    self.scanQRCodeButton = scanQRCodeButton;
    [scanQRCodeButton addTarget:self action:@selector(scanQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    // 切换镜头按钮
    UIButton *switchCameraButton = [[UIButton alloc] init];
    UIImage *switchCameraButtonImage = [IonIcons imageWithIcon:ion_ios_reverse_camera iconColor:[UIColor whiteColor] iconSize:30 imageSize:CGSizeMake(50.0f, 50.0f)];
    [switchCameraButton setImage:switchCameraButtonImage forState:UIControlStateNormal];
    [self.view addSubview:switchCameraButton];
    self.switchCameraButton = switchCameraButton;
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    
    // 拍摄按钮
    UIButton *captureButton = [[UIButton alloc] init];
    captureButton.backgroundColor = [UIColor whiteColor];
    captureButton.layer.cornerRadius = 30;
    captureButton.layer.masksToBounds = YES;
    [self.view addSubview:captureButton];
    self.captureButton = captureButton;
    [captureButton addTarget:self action:@selector(preparePublish:) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [scanQRCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.right.equalTo(switchCameraButton.mas_left).offset(0);
    }];
    
    [switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
    }];
    
    [captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.bottom.equalTo(self.view).with.offset(-30);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    self.previewView.session = session;
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
    
    if (TMRunOnSimulator) {
        return;
    }
    
    dispatch_async(sessionQueue, ^{
        // 视频
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error) {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:videoDeviceInput]) {
            [session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
            self.currentDevicePosition = AVCaptureDevicePositionBack;
        }
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (TMRunOnSimulator) {
        return;
    }
    
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (TMRunOnSimulator) {
        return;
    }
    
    dispatch_async(self.sessionQueue, ^{
        [self.session stopRunning];
    });
}

// 拍摄按钮
- (void)preparePublish:(UIButton *)sender
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewShouldHidePagerNotification object:nil];
//    sender.hidden = YES;
//    
//    // 团队按钮
//    TeamButtons *teamButtons = [[TeamButtons alloc] initWithTeams:self.teams];
//    self.teamButtons = teamButtons;
//    teamButtons.delegate = self;
//    [self.view addSubview:teamButtons];
//    
//    [teamButtons mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.view);
//        make.top.equalTo(self.view.mas_bottom);
//    }];
//    
//    [self.view layoutIfNeeded];
//    
//    [teamButtons mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
//    
//    // 照片缩小
//    CGFloat verticalOffset = 25.0;
//    CGFloat imageWidth = self.imageView.bounds.size.width;
//    CGFloat imageHeight = self.imageView.bounds.size.height;
//    CGFloat horizonalOffset = imageWidth / 2 - imageWidth * (imageHeight - [self getButtonsHeight] - 2 * verticalOffset) / 2 / imageHeight;
//    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(verticalOffset, horizonalOffset, verticalOffset + [self getButtonsHeight], horizonalOffset));
//    }];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.view layoutIfNeeded];
//    }];
}

/**
 *  切换前后镜头
 */
- (void)switchCamera
{
    CATransition *animation = [CATransition animation];
    animation.duration = .5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    
    switch (self.currentDevicePosition) {
        case AVCaptureDevicePositionFront:
            animation.subtype = kCATransitionFromLeft;
            break;
        case AVCaptureDevicePositionBack:
            animation.subtype = kCATransitionFromRight;
            break;
        default:
            animation.subtype = kCATransitionFromLeft;
            break;
    }
    
    [self.view.layer addAnimation:animation forKey:nil];
    
    if (TMRunOnSimulator) {
        return;
    }
    
    self.scanQRCodeButton.enabled = NO;
    self.switchCameraButton.enabled = NO;
    self.captureButton.enabled = NO;
    
    dispatch_async(self.sessionQueue, ^{
        AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        AVCaptureDevicePosition currentPosition = currentVideoDevice.position;
    
        switch (currentPosition) {
            case AVCaptureDevicePositionUnspecified:
            case AVCaptureDevicePositionFront:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
            case AVCaptureDevicePositionBack:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
        }
        
        AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        [self.session beginConfiguration];
        
        [self.session removeInput:[self videoDeviceInput]];
        if ([self.session canAddInput:videoDeviceInput]) {
            [self.session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
            self.currentDevicePosition = preferredPosition;
        } else {
            [self.session addInput:[self videoDeviceInput]];
            self.currentDevicePosition = currentPosition;
        }
        
        [self.session commitConfiguration];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scanQRCodeButton.enabled = YES;
            self.switchCameraButton.enabled = YES;
            self.captureButton.enabled = YES;
            
            if (self.currentDevicePosition == AVCaptureDevicePositionFront) {
                self.scanQRCodeButton.hidden = YES;
            } else {
                self.scanQRCodeButton.hidden = NO;
            }
        });
    });
}

/**
 *  扫描二维码
 */
- (void)scanQRCode
{

}

- (void)cancelPublish:(UIButton *)sender
{
    [self hideButtons];
}

- (void)publish:(UIButton *)sender
{
    [self hideButtons];
}

- (void)resetLayout
{
    [self hideButtons];
}

// 隐藏按钮组
- (void)hideButtons
{
    self.captureButton.hidden = NO;
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.teamButtons mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.teamButtons removeFromSuperview];
        self.teamButtons = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewShouldShowPagerNotification object:nil];
    }];
}

/**
 *  获取指定mediaType与position的设备
 *
 *  @param mediaType
 *  @param position
 *
 *  @return
 */
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

/**
 *  检测是否有使用video权限，若否，则弹框警告
 */
- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted) {
            [self setDeviceAuthorized:YES];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"无法使用相机"
                                            message:@"有圈无法使用相机，请前往系统设置开通权限。"
                                           delegate:self
                                  cancelButtonTitle:@"好的"
                                  otherButtonTitles:nil] show];
                [self setDeviceAuthorized:NO];
            });
        }
    }];
}

#pragma mark - getters and setters

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam MR_findAll];
    }
    
    return _teams;
}

@end
