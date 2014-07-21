//
//  ProfileTableViewCell.h
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/18/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

  // this protocol should be its own file
@protocol FacebookUserInfoDelegate <NSObject>

-(id<FBGraphUser>)returnUser;

@end

@interface ProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UIImageView *appProfilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic, assign) id<FacebookUserInfoDelegate> delegate;

-(void)loadUserData;

@end
