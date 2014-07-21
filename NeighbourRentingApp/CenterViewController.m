//
//  CenterViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController () <UISearchBarDelegate>

@end

@implementation CenterViewController

-(void)viewDidLoad {
  [super viewDidLoad];
  self.leftButton.tag = 1;
  [self.leftButton setImage:[UIImage imageNamed:@"hamburger_icon"] forState:UIControlStateNormal];
  
  self.searchBar.delegate = self;
}

#pragma mark - button actions

-(IBAction)btnMovePanelRight:(id)sender {
  UIButton *button = sender;
  switch (button.tag) {
    case 0: {
      [_centerViewDelegate movePanelToOriginalPosition];
      break;
    }
    case 1: {
      [_centerViewDelegate movePanelRight];
      break;
    }
  }
}

#pragma mark - search bar delegate methods

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  self.searchBar.showsCancelButton = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  self.searchBar.showsCancelButton = NO;
}


#pragma mark - default system code

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
