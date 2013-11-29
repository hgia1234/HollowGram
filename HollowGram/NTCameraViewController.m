//
//  NTCameraViewController.m
//  NghiemTuc
//
//  Created by Gia on 10/20/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "NTCameraViewController.h"
#import "GDCamera.h"
#import "AVCamUtilities.h"
#import "AVCamCaptureManager.h"

#import "HGFirstReviewViewController.h"
#import "HGSecondReviewViewController.h"


@interface NTCameraViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCamCaptureManagerDelegate>

@property (nonatomic, strong) GDCamera *cameraView;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *libraryBtn;
@property (nonatomic, strong) CIDetector *faceDetector;
@property (nonatomic, strong) UILabel *okLabel;

@property (nonatomic) BOOL isFirst;
@property (nonatomic, strong) UIImage *lastImage;
@property (nonatomic, strong) UIImageView *lastImageView;
@end

@implementation NTCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self){
        self.isFirst = YES;
    }
    return self;
}
- (id)initWithImage:(UIImage *)image{
    self = [super init];
    if (self){
        self.lastImage = image;
        self.isFirst = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Camera";
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    self.cameraView = [[GDCamera alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    self.cameraView.captureManager.delegate = self;
    self.cameraView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.cameraView];
	
    if (!self.isFirst) {
        self.lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        self.lastImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.lastImageView.autoresizingMask = UIViewAutoresizingNone;
        self.lastImageView.image = self.lastImage;
        self.lastImageView.alpha = 0.5;
        [self.view addSubview:self.lastImageView];
    }
    
    self.bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    self.bottomBar.frame = CGRectSetY(self.bottomBar.frame,self.view.frame.size.height-80);
    self.bottomBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.bottomBar.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:self.bottomBar];
    
    self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraBtn.frame = CGRectMake(0, 0, 60, 60);
    [self.cameraBtn setImage:[UIImage imageNamed:@"icon_camera.png"] forState:UIControlStateNormal];
    self.cameraBtn.center = CGPointMake(self.bottomBar.frame.size.width/2,
                                        self.bottomBar.frame.size.height/2);
    [self.cameraBtn addTarget:self action:@selector(cameraPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.cameraBtn];
    
    self.okLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.okLabel.text = @"Ok";
    [self.okLabel sizeToFit];
    self.okLabel.center = CGPointMake(255,
                                      self.bottomBar.frame.size.height/2);
    self.okLabel.hidden = YES;
    [self.bottomBar addSubview:self.okLabel];
    
    self.libraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.libraryBtn.frame = CGRectMake(0, 0, 45, 45);
    self.libraryBtn.backgroundColor = [GDUtils colorWithHexString:@"707070"];
    self.libraryBtn.layer.cornerRadius = 10;
    self.libraryBtn.layer.borderColor = [self.libraryBtn.backgroundColor CGColor];
    self.libraryBtn.layer.borderWidth = 3;
    [self.libraryBtn addTarget:self action:@selector(libraryPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.libraryBtn.clipsToBounds = YES;
    
    self.libraryBtn.center = CGPointMake(65, self.bottomBar.frame.size.height/2);
    [self.bottomBar addSubview:self.libraryBtn];
	NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
	self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.cameraView stopCamera];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.cameraView startCamera:^{
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    }];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:([group numberOfAssets] - 1)] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
                UIImage *latestPhoto = [UIImage imageWithCGImage:[alAsset thumbnail]];
                [self.libraryBtn setImage:latestPhoto forState:UIControlStateNormal];
                self.libraryBtn.hidden = NO;
                *innerStop = YES;
            }
        }];
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
        self.libraryBtn.hidden = YES;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)cameraPressed:(id)sender{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    [self.cameraView captureImage:^(UIImage *image) {
        [self gotoProcessWithImage:image];
    }];

}

- (void)libraryPressed:(id)sender{
    NSLog(@"before %@",self.view);
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.allowsEditing = YES;
    vc.delegate = self;
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:vc animated:YES completion:^{
        NSLog(@"after present %@",self.view);
    }];
}

- (void)gotoProcessWithImage:(UIImage *)image{
    UIImage *finalizeImage = nil;
    if (image.size.height==image.size.width&&
        image.size.width==640) {
        finalizeImage = image;
    }else{
        CGSize destSize = CGSizeMake(640, 640);
        if (image.size.height>=image.size.width) {
            destSize = CGSizeMake(image.size.width*(640/image.size.width), image.size.height*(640/image.size.width));
        }else{
            destSize = CGSizeMake(image.size.width*(640/image.size.height), image.size.height*(640/image.size.height));
        }
        UIImage *resizedImage = [image resizedImage:destSize interpolationQuality:kCGInterpolationDefault];
        finalizeImage = [resizedImage croppedImage:CGRectMake((resizedImage.size.width-640)/2,
                                                              (resizedImage.size.height-640)/2,
                                                              640,
                                                              640)];
    }
    
    if (!self.isFirst) {
        GPUImageDissolveBlendFilter *blendFilter = [[GPUImageDissolveBlendFilter alloc] init];
        GPUImagePicture *imageToProcess = [[GPUImagePicture alloc] initWithImage:finalizeImage];
        GPUImagePicture *border = [[GPUImagePicture alloc] initWithImage:self.lastImage];
        
        [imageToProcess addTarget:blendFilter];
        [border addTarget:blendFilter];
        
        [imageToProcess processImage];
        [border processImage];
        finalizeImage = [blendFilter imageFromCurrentlyProcessedOutput];

    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (self.isFirst) {
            HGFirstReviewViewController *vc = [[HGFirstReviewViewController alloc] initWithImage:finalizeImage];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            HGSecondReviewViewController *vc = [[HGSecondReviewViewController alloc] initWithImage:finalizeImage];
            [self.navigationController pushViewController:vc animated:YES];
        }
    });
}

#pragma mark - ImagePicker

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"before close %@",self.view);
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"after close %@",self.view);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [MBProgressHUD showHUDAddedTo:picker.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [[info valueForKey:UIImagePickerControllerEditedImage] fixOrientation];
        if (!image) {
            image = [(UIImage *) [info objectForKey:
                                  UIImagePickerControllerOriginalImage] fixOrientation];
        }
        [self gotoProcessWithImage:image];
        
    });
    
}

- (void)captureManager:(AVCamCaptureManager *)captureManager didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    // got an image
	CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
	CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
	if (attachments)
		CFRelease(attachments);
	NSDictionary *imageOptions = nil;
	UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
	int exifOrientation;
	
    /* kCGImagePropertyOrientation values
     The intended display orientation of the image. If present, this key is a CFNumber value with the same value as defined
     by the TIFF and EXIF specifications -- see enumeration of integer constants.
     The value specified where the origin (0,0) of the image is located. If not present, a value of 1 is assumed.
     
     used when calling featuresInImage: options: The value for this key is an integer NSNumber from 1..8 as found in kCGImagePropertyOrientation.
     If present, the detection will be done based on that orientation but the coordinates in the returned features will still be based on those of the image. */
    
	enum {
		PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
		PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
		PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
		PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
		PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
		PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
	};
	
	switch (curDeviceOrientation) {
		case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
			exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
			break;
		case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			break;
		case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			break;
		case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
		default:
			exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
			break;
	}
    
	imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:exifOrientation] forKey:CIDetectorImageOrientation];
	NSArray *features = [self.faceDetector featuresInImage:ciImage options:imageOptions];
	
    //    // get the clean aperture
    //    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
    //    // that represents image data valid for display.
    //	CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
    //	CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/);
	
	dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (features.count > 0) {
            self.okLabel.hidden = NO;
        }else{
            self.okLabel.hidden = YES;
        }
        //		[self drawFaceBoxesForFeatures:features forVideoBox:clap orientation:curDeviceOrientation];
	});
}

@end
