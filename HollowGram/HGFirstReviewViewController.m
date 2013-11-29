//
//  HGFirstReviewViewController.m
//  HollowGram
//
//  Created by Gia on 11/29/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "HGFirstReviewViewController.h"
#import "NTCameraViewController.h"

@interface HGFirstReviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *reviewImageView;
@property (nonatomic, strong) UIImage *reviewImage;

@end

@implementation HGFirstReviewViewController

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
        self.reviewImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
    self.reviewImageView.image = self.reviewImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhotoPressed:(id)sender{
    NTCameraViewController *vc = [[NTCameraViewController alloc] initWithImage:self.reviewImage];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
