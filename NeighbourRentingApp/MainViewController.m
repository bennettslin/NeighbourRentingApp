//
//  MainViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "MainViewController.h"
#import "CenterViewController.h"
#import "LeftPanelViewController.h"
#import "ProfileViewController.h"
#import "OwnerTabBarViewController.h"
#import "PickerViewController.h"
#import "RenterTabBarController.h"
//#import "PickerFormViewController.h"
//#import "ItemsViewController.h"
#import "User.h"
#import "Item.h"

#define kCenterTag 1
#define kLeftPanelTag 2

#define kCornerRadius 4.f

#define kSlideTiming .25f
#define kPanelWidth 60.f

  // offset for child VCs to sit below search bar
#define kTopOffset 64.f

@interface MainViewController () <CenterViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) CenterViewController *centerVC;
@property (strong, nonatomic) LeftPanelViewController *leftPanelVC;
@property (assign, nonatomic) BOOL showingLeftPanel;

@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;

@end

@implementation MainViewController

-(void)viewDidLoad {
  [super viewDidLoad];
  [self setupView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationToStoreItem:) name:@"storeItem" object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationToPresentViewToEditItem:) name:@"editItem" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationToPresentUserForItems) name:@"presentItems" object:nil];
}

#pragma mark - views

-(void)setupView {
  
    // setup left view
  self.leftPanelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"leftPanelVC"];
  self.leftPanelVC.view.tag = kLeftPanelTag;
  self.leftPanelVC.myMainVC = self;
  
    // setup center view
  self.centerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"centerVC"];
  self.centerVC.view.tag = kCenterTag;
  self.centerVC.centerViewDelegate = self;
  
  [self.view addSubview:self.centerVC.view];
  [self addChildViewController:_centerVC];
  [_centerVC didMoveToParentViewController:self];
  
    // default page when it loads
  [self loadChildPage:kOwnerItemPage withItem:nil];
  [self movePanelRight];
  
  [self setupGestures];
}

-(void)resetMainView {
  
  _centerVC.leftButton.tag = 1;
  self.showingLeftPanel = NO;
  
    // remove view shadows
  [self showCenterViewWithShadow:NO withOffset:0];
  
}

-(UIView *)getLeftView {

  [self.view addSubview:self.leftPanelVC.view];
  [self addChildViewController:_leftPanelVC];
  [_leftPanelVC didMoveToParentViewController:self];
  
  self.showingLeftPanel = YES;
  
    // set up view shadows
  [self showCenterViewWithShadow:YES withOffset:-3];
  
  UIView *view = self.leftPanelVC.view;
  return view;
}

#pragma mark - child pages

-(void)removeCenterChildVCs {
  UIViewController *centerChildVC;
  if (![self.centerVC.childViewControllers containsObject:centerChildVC]) {
    for (UIViewController *vc in self.centerVC.childViewControllers) {
      [vc willMoveToParentViewController:nil];
      [vc.view removeFromSuperview];
      [vc removeFromParentViewController];
    }
  }
}

-(void)loadChildPage:(PageType)pageType withItem:(Item *)item {
  [self removeCenterChildVCs];
  UIViewController *childVC;

  if (pageType == kProfilePage) {
    ProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    childVC = profileVC;

  } else if (pageType == kOwnerItemPage) {
    OwnerTabBarViewController *ownerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ownerTabVC"];
    ownerVC.selectedIndex = 0;
    childVC = ownerVC;
    
    PickerViewController *pickerVC = (PickerViewController *)ownerVC.selectedViewController;
    pickerVC.myItem = item;
    
  } else if (pageType == kOwnerCollectionPage) {
    OwnerTabBarViewController *ownerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ownerTabVC"];
    ownerVC.selectedIndex = 1;
    childVC = ownerVC;
  
  } else if (pageType == kRenterPage0) {
    RenterTabBarController *renterVC0 = [self.storyboard instantiateViewControllerWithIdentifier:@"renterTabVC0"];
    childVC = renterVC0;
  }
  
  if (childVC) {
    childVC.view.frame = CGRectMake(0, kTopOffset, self.view.frame.size.width, self.view.frame.size.height - kTopOffset);
    [self.centerVC.view addSubview:childVC.view];
    [self.centerVC addChildViewController:childVC];
    [childVC didMoveToParentViewController:self.centerVC];
    [self movePanelToOriginalPosition];
  }
  
  if ([childVC isKindOfClass:[ProfileViewController class]]) {
    ProfileViewController *profileVC = (ProfileViewController *)childVC;
    profileVC.profilePictureView.profileID = self.facebookUser.objectID;
    profileVC.appProfilePictureView.image = self.appUser.profileImage;
    profileVC.userNameLabel.text = self.facebookUser.name;
  }
}

-(void)logout {
  [self.delegate logout];
}

#pragma mark - gestures

-(void)setupGestures {
  UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
  [panRecognizer setMinimumNumberOfTouches:1];
  [panRecognizer setMaximumNumberOfTouches:1];
  [panRecognizer setDelegate:self];
  
  [_centerVC.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender {
  [[[(UITapGestureRecognizer *)sender view] layer] removeAllAnimations];
  
  CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:self.view];
  CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:[sender view]];
  
  if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
    UIView *childView = nil;
    
    if(velocity.x > 0) {
      childView = [self getLeftView];
    }
      // Make sure the view you're working with is front and center.
    [self.view sendSubviewToBack:childView];
    [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer *)sender view]];
  }
  
  if([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
    if (!_showPanel) {
      [self movePanelToOriginalPosition];
    } else {
      if (_showingLeftPanel) {
        [self movePanelRight];
      }
    }
  }
  
  if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
    _showPanel = velocity.x > 0 ?
      [sender view].center.x > _centerVC.view.frame.size.width * 9/16 :
      [sender view].center.x > _centerVC.view.frame.size.width * 23/16 - kPanelWidth;
    
      // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
    [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
    [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
  }
}

#pragma mark - actions

-(void)movePanelRight { // to show left panel
  UIView *childView = [self getLeftView];
  [self.view sendSubviewToBack:childView];
  
  [UIView animateWithDuration:kSlideTiming delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     _centerVC.view.frame = CGRectMake(self.view.frame.size.width - kPanelWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                       _centerVC.leftButton.tag = 0;
                     }
                   }];

}

-(void)movePanelToOriginalPosition {
  [UIView animateWithDuration:kSlideTiming delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     _centerVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                       
                       [self resetMainView];
                     }
                   }];
}

-(void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
  if (value) {
    [_centerVC.view.layer setCornerRadius:kCornerRadius];
    _centerVC.view.clipsToBounds = YES;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_centerVC.view.bounds];
    _centerVC.view.layer.masksToBounds = NO;
    _centerVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _centerVC.view.layer.shadowOffset = CGSizeMake(offset, 0);
    _centerVC.view.layer.shadowOpacity = 0.25f;
    _centerVC.view.layer.shadowPath = shadowPath.CGPath;
    
  } else {
    _centerVC.view.layer.cornerRadius = 0.f;
    _centerVC.view.layer.shadowOffset = CGSizeMake(offset, 0);
  }
}

#pragma mark - NSNotification method

-(void)receiveNotificationToStoreItem:(NSNotification *)notification {
  if ([notification.name isEqualToString:@"storeItem"]) {
    NSDictionary *itemInfo = notification.userInfo;
    Item *item = [itemInfo objectForKey:@"item"];
    [self storeItem:item];
  }
}

-(void)receiveNotificationToPresentViewToEditItem:(NSNotification *)notification {
  if ([notification.name isEqualToString:@"editItem"]) {
    
    NSDictionary *itemInfo = notification.userInfo;
    Item *myItem = [itemInfo objectForKey:@"item"];
    [self loadChildPage:kOwnerItemPage withItem:myItem];
  }
}

-(void)receiveNotificationToPresentUserForItems {
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  [userInfo setObject:self.appUser forKey:@"user"];
  
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter postNotificationName:@"sendUser" object:self userInfo:userInfo];
}

#pragma mark - Store and persist data methods

-(void)storeItem:(Item *)myItem {
  if (![self.appUser.myListings containsObject:myItem]) {
    
      // this info doesn't change
    myItem.owner = self.appUser;
    myItem.postDate = [NSDate date];
    
    [self.appUser addItem:myItem];
  }
  
  [User saveMyUser:self.appUser];
  [self loadChildPage:kOwnerCollectionPage withItem:nil];
}

#pragma mark Default System Code

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
