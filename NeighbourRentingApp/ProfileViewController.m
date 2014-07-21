//
//  ProfileViewController.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/18/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

-(void)viewDidLoad {
  [super viewDidLoad];
  
  self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 4.f;
  self.profilePictureView.clipsToBounds = YES;
}



-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
