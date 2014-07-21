//
//  CenterViewController.h
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "LeftPanelViewController.h"

@protocol CenterViewControllerDelegate <NSObject>

-(void)movePanelRight;
-(void)movePanelToOriginalPosition;

@end

@interface CenterViewController : UIViewController

@property (nonatomic, assign) id<CenterViewControllerDelegate> centerViewDelegate;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
