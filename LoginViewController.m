//
//  LoginViewController.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/15/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "User.h"

@interface LoginViewController () <FBLoginViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) MainViewController *myMainVC;

@end

@implementation LoginViewController {
  UIImage *_appUserImage;
}

-(void)viewDidLoad {
  [super viewDidLoad];
  
    // mock email and password text fields
  self.emailField.delegate = self;
  self.passwordField.delegate = self;
  self.passwordField.secureTextEntry = YES;
  
    // Facebook login/logout button
  FBLoginView *loginView = [[FBLoginView alloc] init];
  loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), self.view.frame.size.height * 0.85f);
  [self.view addSubview:loginView];
  loginView.delegate = self;
  
    // reference to main VC will be used by both Facebook and email login
  self.myMainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
}

#pragma mark - Facebook delegate methods

  // This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
  if (user) {
    NSLog(@"load main vc with user Facebook user");
    [self loadMainVCWithUser:user];
  }
}

  // Logged-in user experience
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
}

  // Logged-out user experience
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}

  // Handle possible errors that can occur during login
-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
  NSString *alertMessage, *alertTitle;
  
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
  if ([FBErrorUtility shouldNotifyUserForError:error]) {
    alertTitle = @"Facebook error";
    alertMessage = [FBErrorUtility userMessageForError:error];
    
      // This code will handle session closures that happen outside of the app
      // You can take a look at our error handling guide to know more about it
      // https://developers.facebook.com/docs/ios/errors
  } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
    alertTitle = @"Session Error";
    alertMessage = @"Your current session is no longer valid. Please log in again.";
    
      // If the user has cancelled a login, we will do nothing.
      // You can also choose to show the user a message if cancelling login will result in
      // the user not being able to complete a task they had initiated in your app
      // (like accessing FB-stored information or posting to Facebook)
  } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
    NSLog(@"User cancelled login.");
    
      // For simplicity, this sample handles other errors with a generic message
      // You can checkout our error handling guide for more detailed information
      // https://developers.facebook.com/docs/ios/errors
  } else {
    alertTitle  = @"Something went wrong.";
    alertMessage = @"Please try again later.";
    NSLog(@"Unexpected error:%@", error);
  }
  
  if (alertMessage) {
    [[[UIAlertView alloc] initWithTitle:alertTitle
                                message:alertMessage
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
  }
}

#pragma mark - app user methods

-(User *)findAppUserFromFBUser:(id<FBGraphUser>)facebookUser {
    // FIXME: this method will eventually get app user data from FB user data
    // for now, hard-coded
  User *appUser = [User getMyUser];
  if (!appUser) {
    appUser = [[User alloc] initWithName:@"Bennett" andProfileImage:nil];
    [User saveMyUser:appUser];
  }
  
  return appUser;
}

#pragma mark - main VC methods

-(IBAction)loginButtonTapped:(id)sender {

    // mock email login for now
  [self loadMainVCWithUser:nil];
}

-(void)loadMainVCWithUser:(id<FBGraphUser>)facebookUser {
  
  self.myMainVC.facebookUser = facebookUser;
  self.myMainVC.appUser = [self findAppUserFromFBUser:facebookUser];
  self.myMainVC.delegate = self;
  
  [self.view addSubview:self.myMainVC.view];
  [self addChildViewController:self.myMainVC];
  [self.myMainVC didMoveToParentViewController:self];
  NSLog(@"main vc loaded with user facebook user");
}

-(void)logout {
    // FIXME: doesn't log out Facebook user
  [self.myMainVC willMoveToParentViewController:nil];
  [self.myMainVC.view removeFromSuperview];
  [self.myMainVC removeFromParentViewController];
}

#pragma mark - textField delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - system methods

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
