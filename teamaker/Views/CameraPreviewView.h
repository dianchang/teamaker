//
//  CameraPreviewView.h
//  teamaker
//
//  Created by hustlzp on 15/9/2.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface CameraPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
