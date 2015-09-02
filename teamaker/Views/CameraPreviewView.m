//
//  CameraPreviewView.m
//  teamaker
//
//  Created by hustlzp on 15/9/2.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "CameraPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
    [(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
