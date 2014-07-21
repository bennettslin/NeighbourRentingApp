//
//  ProfileViewController.h
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/18/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBProfilePictureView;

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UIImageView *appProfilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
