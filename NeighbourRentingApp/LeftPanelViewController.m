//
//  LeftPanelViewController.m
//  SlideoutNavigation
//
//  Created by Tammy Coron on 1/10/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "ProfileTableViewCell.h"
#import "OwnerRenterTableViewCell.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MainViewController.h"

@interface LeftPanelViewController () <FacebookUserInfoDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *ownersArray;
@property (strong, nonatomic) NSArray *rentersArray;
@property (strong, nonatomic) NSArray *settingsArray;

@end

@implementation LeftPanelViewController

-(void)viewDidLoad {
  [super viewDidLoad];
  
  self.ownersArray = @[@"Post items for rent", @"Your listings"];
  self.rentersArray = @[@"Discover items in your area", @"See what friends are renting"];
  self.settingsArray = @[@"Log out"];
  self.myTableView.delegate = self;
  self.myTableView.dataSource = self;
}

#pragma mark - Facebook user info delegate methods

-(id<FBGraphUser>)returnUser {
  return self.myMainVC.facebookUser;
}

#pragma mark UITableView Datasource/Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return @"Profile";
      break;
    case 1:
      return @"Owners";
      break;
    case 2:
      return @"Renters";
      break;
    case 3:
      return @"Settings";
      break;
  }
  return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 1;
      break;
    case 1:
      return self.ownersArray.count;
      break;
    case 2:
      return self.rentersArray.count;
      break;
    case 3:
      return self.settingsArray.count;
      break;
  }
  return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 32;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    // row for profile on top is larger
  return indexPath.row == 0 && indexPath.section == 0 ? 96 : 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 0 && indexPath.section == 0) {
    ProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    profileCell.delegate = self;
    [profileCell loadUserData];
    return profileCell;
  } else {
    OwnerRenterTableViewCell *pagesCell = [tableView dequeueReusableCellWithIdentifier:@"ownerRenterCell" forIndexPath:indexPath];
    switch (indexPath.section) {
      case 1:
        pagesCell.titleLabel.text = self.ownersArray[indexPath.row];
        break;
      case 2:
        pagesCell.titleLabel.text = self.rentersArray[indexPath.row];
        break;
      case 3:
        pagesCell.titleLabel.text = self.settingsArray[indexPath.row];
        break;
      default:
        break;
    }
    return pagesCell;
  }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  switch (indexPath.section) {
    case 0:
      [self.myMainVC loadChildPage:kProfilePage withItem:nil];
      break;
    case 1:
      if (indexPath.row == 0) {
        [self.myMainVC loadChildPage:kOwnerItemPage withItem:nil];
      } else if (indexPath.row == 1) {
        [self.myMainVC loadChildPage:kOwnerCollectionPage withItem:nil];
      }
      break;
    case 2:
      [self.myMainVC loadChildPage:kRenterPage0 withItem:nil];
      break;
    case 3:
      [self.myMainVC logout];
      break;
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Default System Code

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
