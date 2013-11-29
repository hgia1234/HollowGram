//
//  HGSecondReviewViewController.m
//  HollowGram
//
//  Created by Gia on 11/29/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "HGSecondReviewViewController.h"

@interface HGSecondReviewViewController ()

@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HGSecondReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.imageView.image = self.image;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)saveImagePressed:(id)sender{
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeImageToSavedPhotosAlbum:self.image.CGImage orientation:(ALAssetOrientation)self.image.imageOrientation
                       completionBlock:^(NSURL* assetURL, NSError* error) {
                           
                           
                       }];
}

- (IBAction)retakePressed:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
