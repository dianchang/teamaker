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

@property (strong, nonatomic) NSArray *teams;

// UI
@property (strong, nonatomic) CameraPreviewView *previewView;

@property (strong, nonatomic) UIButton *captureButton;
@property (strong, nonatomic) UIButton *switchToScanQRCodeModeButton;
@property (strong, nonatomic) UIButton *switchCameraButton;

@property (strong, nonatomic) UIView *scanQRCodeView;
@property (strong, nonatomic) UIButton *switchToCaptureModeButton;

@property (strong, nonatomic) TeamButtons *teamButtons;

// AV Foundation
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) BOOL deviceAuthorized;
@property (strong, nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;

// 状态
@property (nonatomic) AVCaptureDevicePosition currentDevicePosition;
@property (nonatomic) BOOL scanningQRCode;

@end

@implementation CaptureViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor blackColor];
    
    // Preview view
    CameraPreviewView *previewView = [[CameraPreviewView alloc] init];
    previewView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:previewView];
    self.previewView = previewView;
    
    // 切换到扫描二维码模式
    UIButton *switchToScanQRCodeModeButton = [UIButton new];
    UIImage *switchToScanQRCodeModeImage = [IonIcons imageWithIcon:ion_qr_scanner iconColor:[UIColor whiteColor] iconSize:23 imageSize:CGSizeMake(50.0f, 50.0f)];
    [switchToScanQRCodeModeButton setImage:switchToScanQRCodeModeImage forState:UIControlStateNormal];
    [previewView addSubview:switchToScanQRCodeModeButton];
    self.switchToScanQRCodeModeButton = switchToScanQRCodeModeButton;
    [switchToScanQRCodeModeButton addTarget:self action:@selector(switchMode) forControlEvents:UIControlEventTouchUpInside];
    
    // 切换镜头按钮
    UIButton *switchCameraButton = [UIButton new];
    UIImage *switchCameraButtonImage = [IonIcons imageWithIcon:ion_ios_reverse_camera iconColor:[UIColor whiteColor] iconSize:30 imageSize:CGSizeMake(50.0f, 50.0f)];
    [switchCameraButton setImage:switchCameraButtonImage forState:UIControlStateNormal];
    [previewView addSubview:switchCameraButton];
    self.switchCameraButton = switchCameraButton;
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    
    // 拍摄按钮
    UIButton *captureButton = [[UIButton alloc] init];
    captureButton.backgroundColor = [UIColor whiteColor];
    captureButton.layer.cornerRadius = 30;
    captureButton.layer.masksToBounds = YES;
    [previewView addSubview:captureButton];
    self.captureButton = captureButton;
    [captureButton addTarget:self action:@selector(preparePublish:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *scanQRCodeView = [self createScanQRCodeView];
    [self.view addSubview:scanQRCodeView];
    self.scanQRCodeView = scanQRCodeView;
    
    // 约束
    [previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [switchToScanQRCodeModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(previewView).offset(0);
        make.right.equalTo(switchCameraButton.mas_left).offset(0);
    }];
    
    [switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(previewView).offset(0);
        make.top.equalTo(previewView).offset(0);
    }];
    
    [captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(previewView);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.bottom.equalTo(previewView).with.offset(-30);
    }];
    
    [scanQRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self hideFrontCameraLayout];
    [self hideScanQRCodeLayout];
    [self showBackCameraLayout];
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    self.previewView.session = session;
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
    
    self.currentDevicePosition = AVCaptureDevicePositionBack;
    
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

- (UIView *)createScanQRCodeView
{
    UIView *scanQRCodeView = [UIView new];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
    [scanQRCodeView addSubview:topView];
    
    UIView *leftView = [UIView new];
    leftView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
    [scanQRCodeView addSubview:leftView];
    
    UIView *rightView = [UIView new];
    rightView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
    [scanQRCodeView addSubview:rightView];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
    [scanQRCodeView addSubview:bottomView];
    
    UIView *centerView = [UIView new];
    [scanQRCodeView addSubview:centerView];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"放入二维码将自动扫描";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:tipLabel];
    
    // 切换到拍摄模式按钮
    UIButton *switchToCaptureModeButton = [UIButton new];
    UIImage *switchToCaptureModeButtonImage = [IonIcons imageWithIcon:ion_ios_camera iconColor:[UIColor whiteColor] iconSize:30 imageSize:CGSizeMake(50.0f, 50.0f)];
    [switchToCaptureModeButton setImage:switchToCaptureModeButtonImage forState:UIControlStateNormal];
    [scanQRCodeView addSubview:switchToCaptureModeButton];
    self.switchToCaptureModeButton = switchToCaptureModeButton;
    [switchToCaptureModeButton addTarget:self action:@selector(switchMode) forControlEvents:UIControlEventTouchUpInside];

    // 约束
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(scanQRCodeView);
    }];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scanQRCodeView);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(scanQRCodeView);
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(leftView.mas_right);
        make.right.equalTo(rightView.mas_left);
        make.width.equalTo(@230);
        make.height.equalTo(@230);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.right.equalTo(scanQRCodeView);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftView.mas_bottom);
        make.top.equalTo(centerView.mas_bottom);
        make.top.equalTo(rightView.mas_bottom);
        make.left.right.and.bottom.equalTo(scanQRCodeView);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.top.equalTo(bottomView).offset(20);
    }];
    
    [switchToCaptureModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(scanQRCodeView);
        make.top.equalTo(scanQRCodeView);
    }];
    
    return scanQRCodeView;
}

// 预备发布
- (void)preparePublish:(UIButton *)sender
{
    dispatch_async(self.sessionQueue, ^{
        [self.session stopRunning];
    });
    
    [self showButtons];
}

/**
 *  取消发布
 *
 *  @param sender
 */
- (void)cancelPublish:(UIButton *)sender
{
    [self hideButtons];
    
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
}

/**
 *  发布
 *
 *  @param sender
 */
- (void)publish:(UIButton *)sender
{
    //    dispatch_async([self sessionQueue], ^{
    //        // Update the orientation on the still image output video connection before capturing.
    //        [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
    //
    //        // Flash set to Auto for Still Capture
    //        [AVCamViewController setFlashMode:AVCaptureFlashModeAuto forDevice:[[self videoDeviceInput] device]];
    //
    //        // Capture a still image.
    //        [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
    //
    //            if (imageDataSampleBuffer)
    //            {
    //                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
    //                UIImage *image = [[UIImage alloc] initWithData:imageData];
    //                [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
    //            }
    //        }];
    //    });
}

/**
 *  切换前后镜头
 */
- (void)switchCamera
{
    CATransition *animation = [CATransition animation];
    animation.duration = .5f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.duration / 2 * NSEC_PER_SEC));
    
    if (self.currentDevicePosition == AVCaptureDevicePositionFront) {
        animation.subtype = kCATransitionFromLeft;
        [self.previewView.layer addAnimation:animation forKey:nil];
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
            [self hideFrontCameraLayout];
            [self showBackCameraLayout];
        });
    } else {
        animation.subtype = kCATransitionFromRight;
        [self.previewView.layer addAnimation:animation forKey:nil];
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
            [self hideBackCameraLayout];
            [self showFrontCameraLayout];
        });
    }
    
    if (TMRunOnSimulator) {
        return;
    }
    
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
            self.switchCameraButton.enabled = YES;
            self.captureButton.enabled = YES;
        });
    });
}

/**
 *  扫描二维码
 */
- (void)switchMode
{
    CATransition *animation = [CATransition animation];
    animation.duration = .5f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.duration / 2 * NSEC_PER_SEC));
    
    if (self.scanningQRCode) {
        animation.subtype = kCATransitionFromLeft;
        [self.previewView.layer addAnimation:animation forKey:nil];
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
            [self hideScanQRCodeLayout];
            [self showBackCameraLayout];
        });
        
        self.scanningQRCode = NO;
    } else {
        animation.subtype = kCATransitionFromRight;
        [self.previewView.layer addAnimation:animation forKey:nil];
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
            [self hideBackCameraLayout];
            [self showScanQRCodeLayout];
        });
        
        self.scanningQRCode = YES;
    }
}

/**
 *  重置界面
 */
- (void)resetLayout
{
    [self hideButtons];
}

#pragma mark - private methods

// 显示按钮组
- (void)showButtons
{
    if (self.currentDevicePosition == AVCaptureDevicePositionBack) {
        [self hideBackCameraLayout];
    } else {
        [self hideFrontCameraLayout];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewShouldHidePagerNotification object:nil];
    
    // 团队按钮
    [self.view addSubview:self.teamButtons];
    
    CGFloat verticalOffset = 25.0;
    CGSize teamButtonsSize = [self.teamButtons systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat teamButtonsHeight = teamButtonsSize.height;
    
    // 照片缩小
    CGFloat imageWidth = self.previewView.bounds.size.width;
    CGFloat imageHeight = self.previewView.bounds.size.height;
    CGFloat horizonalOffset = imageWidth / 2 - imageWidth * (imageHeight - teamButtonsHeight - 2 * verticalOffset) / 2 / imageHeight;
    
    [self.teamButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [self.view layoutIfNeeded];
    
    [self.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(verticalOffset, horizonalOffset, verticalOffset + teamButtonsHeight, horizonalOffset));
    }];
    
    [self.teamButtons mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 隐藏按钮组
- (void)hideButtons
{
    if (!self.teamButtons.superview) {
        return;
    }
    
    [self.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewShouldShowPagerNotification object:nil];
        
        if (self.currentDevicePosition == AVCaptureDevicePositionBack) {
            [self showBackCameraLayout];
        } else {
            [self showFrontCameraLayout];
        }
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

/**
 *  设置设备的闪光灯模式
 *
 *  @param flashMode 闪光模式
 *  @param device    设备
 */
- (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:flashMode])
    {
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }
}

/**
 *  显示适配于前端摄像头的界面布局
 */
- (void)showFrontCameraLayout
{
    self.captureButton.hidden = NO;
    self.switchCameraButton.hidden = NO;
}

/**
 *  隐藏适配于前端摄像头的界面布局
 */
- (void)hideFrontCameraLayout
{
    self.captureButton.hidden = YES;
    self.switchCameraButton.hidden = YES;
}

/**
 *  显示适配于后端摄像头的界面布局
 */
- (void)showBackCameraLayout
{
    self.captureButton.hidden = NO;
    self.switchCameraButton.hidden = NO;
    self.switchToScanQRCodeModeButton.hidden = NO;
}

/**
 *  隐藏适配于后端摄像头的界面布局
 */
- (void)hideBackCameraLayout
{
    self.captureButton.hidden = YES;
    self.switchCameraButton.hidden = YES;
    self.switchToScanQRCodeModeButton.hidden = YES;
}

/**
 *  显示适配于扫描二维码的界面布局
 */
- (void)showScanQRCodeLayout
{
    self.scanQRCodeView.hidden = NO;
}

/**
 *  隐藏适配于扫描二维码的界面
 */
- (void)hideScanQRCodeLayout
{
    self.scanQRCodeView.hidden = YES;
}

#pragma mark - getters and setters

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam MR_findAll];
    }
    
    return _teams;
}

- (TeamButtons *)teamButtons
{
    if (!_teamButtons) {
        _teamButtons = [[TeamButtons alloc] initWithTeams:self.teams];
        _teamButtons.delegate = self;
    }
    
    return _teamButtons;
}

@end
