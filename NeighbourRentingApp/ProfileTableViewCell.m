//
//  ProfileTableViewCell.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/18/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "ProfileTableViewCell.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation ProfileTableViewCell

-(void)loadUserData {
  id<FBGraphUser> user = [self.delegate returnUser];
  self.profilePictureView.profileID = user.objectID;
  
  self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 4.f;
  self.profilePictureView.clipsToBounds = YES;
  
  self.userNameLabel.text = user.name;
}

//-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
//  [super setSelected:selected animated:animated];
//}

@end
