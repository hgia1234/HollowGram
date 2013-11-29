//
//  GDCamera.h
//  TestCamera
//
//  Created by Gia on 9/11/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCamCaptureManager;

@interface GDCamera : UIView

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic,strong) AVCamCaptureManager *captureManager;



- (void)captureImage:(void(^)(UIImage *image))block;
- (AVCaptureDevice *)device;
- (void)stopCamera;
- (void)startCamera:(void(^)(void))completion;
- (BOOL)isRunning;
@end
