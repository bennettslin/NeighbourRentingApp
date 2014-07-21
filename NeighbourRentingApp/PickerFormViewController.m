//
//  PickerFormViewController.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/22/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "PickerFormViewController.h"
#import "MapViewController.h"
#import "Item.h"
//#import "User.h"

@interface PickerFormViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addOrChangePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *postItemButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *detailField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;

@property (strong, nonatomic) MapViewController *myMapVC;

@property (strong, nonatomic) User *myUser;

@end

@implementation PickerFormViewController {
  NSUInteger _sourceType;
  BOOL _posting;
}

-(void)viewDidLoad {
  [super viewDidLoad];
  
  self.titleField.delegate = self;
  self.detailField.delegate = self;
  
  self.imageView.contentMode = UIViewContentModeScaleAspectFit;
  self.imageView.layer.cornerRadius = 10.f;
  self.imageView.clipsToBounds = YES;
  
    // FIXME: need other method to determine if posting or editing
    // check whether posting or editing
  _posting = self.myItem ? NO : YES;
}

-(void)viewWillAppear:(BOOL)animated {
  
  if (!self.myItem) {
    NSLog(@"my item instantiated");
    self.myItem = [[Item alloc] init];
    [self updatePickedImage:nil];
    
  } else {
      // if edit mode
    NSLog(@"edit mode");
    [self updatePickedImage:self.myItem.image];
    
    self.titleField.text = self.myItem.title;
    self.detailField.text = self.myItem.detail;
    self.priceField.text = [self.myItem.price descriptionWithLocale:[NSLocale currentLocale]];
    self.latitudeLabel.text = [NSString stringWithFormat:@"latitude: %.2f", self.myItem.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"longitude: %.2f", self.myItem.longitude];
    self.postDateLabel.text = [NSString stringWithFormat:@"postDate: %@", self.myItem.postDate];
    NSLog(@"%@, %@, %@", self.latitudeLabel.text, self.longitudeLabel.text, self.postDateLabel.text);
  }
  
//  self.myMapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
    // hard coded
//  self.myMapVC.view.frame = CGRectMake(36, 375, 100.f, 100.f);
    //  self.myMapVC.view.center = self.view.center;
//  [self.view addSubview:self.myMapVC.view];
//  [self addChildViewController:self.myMapVC];
//  [self.myMapVC didMoveToParentViewController:self];
  
  NSString *buttonText = _posting ? @"Post item" : @"Save changes";
  [self.postItemButton setTitle:buttonText forState:UIControlStateNormal];
}

-(void)updatePickedImage:(UIImage *)pickedImage {
  
  if (pickedImage) {
    self.imageView.image = pickedImage;
    [self.addOrChangePhotoButton setTitle:@"Change photo" forState:UIControlStateNormal];
    
  } else {
    [self.addOrChangePhotoButton setTitle:@"Add photo" forState:UIControlStateNormal];
    // FIXME: present default background image if no picked image
    self.imageView.backgroundColor = [UIColor darkGrayColor];
  }

    // save image only if source is camera
//  if (_sourceType == UIImagePickerControllerSourceTypeCamera) {
//    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//  }
  
  self.myItem.image = self.imageView.image;
}


#pragma mark - UIImagePickerController

-(void)pickerWithSourceType:(NSUInteger)sourceType {
  
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  
  _sourceType = sourceType;
  picker.sourceType = sourceType;
  picker.delegate = self;
  picker.allowsEditing = YES;
  
  [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  [self dismissViewControllerAnimated:YES completion:^{
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self updatePickedImage:pickedImage];
  }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:^{
    NSLog(@"User cancelled image picker");
  }];
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
  if (error) {
    NSLog(@"There was an error");
  } else {
    NSLog(@"Image successfully saved");
  }
}

-(void)presentPickerActionSheet {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      // if camera is available, let user choose between taking or selecting photo
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take a photo", @"Select photo from camera roll", nil];
    [actionSheet showInView:self.view.superview];
  } else {
      // otherwise user has no choice but to select photo
    [self pickerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
  }
}

#pragma mark - button methods

-(IBAction)addPhotoTapped:(id)sender {
  [self presentPickerActionSheet];
}

-(IBAction)postItemTapped:(id)sender {
  
  NSMutableDictionary *itemInfo = [NSMutableDictionary dictionary];
  [itemInfo setObject:self.myItem forKey:@"item"];
  
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter postNotificationName:@"storeItem" object:self userInfo:itemInfo];
}

#pragma mark - action sheet methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0:
        // take photo
      NSLog(@"User chose to take photo");
      [self pickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
      break;
    case 1:
        // select photo
      NSLog(@"User chose to select photo");
      [self pickerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
      break;
  }
}

#pragma mark - text field delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  self.myItem.title = self.titleField.text;
  self.myItem.detail = self.detailField.text;
  self.myItem.price = [NSDecimalNumber decimalNumberWithString:self.priceField.text locale:[NSLocale currentLocale]];
  [textField resignFirstResponder];
  return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.titleField resignFirstResponder];
  [self.detailField resignFirstResponder];
  [self.priceField resignFirstResponder];
  [self.addressField resignFirstResponder];
}

#pragma mark - system methods

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
