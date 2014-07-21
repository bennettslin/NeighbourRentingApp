//
//  MainViewController.h
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@class User;
@class Item;

typedef enum pageType {
  kProfilePage,
  kOwnerItemPage,
  kOwnerCollectionPage,
  kRenterPage0
} PageType;

@protocol MainPageDelegate <NSObject>

-(void)logout;

@end

@interface MainViewController : UIViewController

@property (strong, nonatomic) id<FBGraphUser> facebookUser;
@property (strong, nonatomic) User *appUser;

@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) UIImage *appProfilePicture;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) id <MainPageDelegate> delegate;

-(void)removeCenterChildVCs;
-(void)loadChildPage:(PageType)pageType withItem:(Item *)item;
-(void)logout;

@end