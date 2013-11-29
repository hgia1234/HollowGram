//
//  HGViewController.m
//  HollowGram
//
//  Created by Gia on 11/29/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "HGViewController.h"
#import "NTCameraViewController.h"

@interface HGViewController ()

@end

@implementation HGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhotoPressed:(id)sender{
    NTCameraViewController *vc = [[NTCameraViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
