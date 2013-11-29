//
//  GDCamera.m
//  TestCamera
//
//  Created by Gia on 9/11/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "GDCamera.h"
#import "AVCamUtilities.h"
#import "AVCamCaptureManager.h"

@interface GDCamera()<AVCamCaptureManagerDelegate>

@property (nonatomic,copy) void (^block)(UIImage *image);

@end;

@implementation GDCamera

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
    [self setCaptureManager:manager];
    
    if ([[self captureManager] setupSession]) {
        // Create video preview layer and add it to the UI
        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
        UIView *view = self;
        CALayer *viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [view bounds];
        [newCaptureVideoPreviewLayer setFrame:bounds];
        [newCaptureVideoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        
        
        
        [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
        
        [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
        
        
    }
}


- (void)stopCamera{
    [self.captureManager.session stopRunning];
	[[self.captureManager.videoOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
}
- (void)startCamera:(void(^)(void))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[self captureManager] session] startRunning];
        [[self.captureManager.videoOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

- (BOOL)isRunning{
    return self.captureManager.session.isRunning;
}

- (AVCaptureDevice *)device{
    return self.captureManager.videoInput.device;
}

- (void)captureImage:(void(^)(UIImage *image))block{
    AVCaptureConnection *stillImageConnection = [AVCamUtilities connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self.captureManager stillImageOutput] connections]];
    if ([stillImageConnection isVideoOrientationSupported])
        [stillImageConnection setVideoOrientation:self.captureManager.orientation];
    [[self.captureManager stillImageOutput] captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
															 [self.captureManager.session stopRunning];
															 
															 if (imageDataSampleBuffer != NULL) {
																 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
																 
                                                                 UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                                 block(image);
															 }
															 else
																 block(nil);
                                                         }];
}

- (void) captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error{
    
}
- (void) captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager{
    
}
- (void) captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager{
    
}
- (void) captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager{
    
}
- (void) captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager{
    
}

@end
