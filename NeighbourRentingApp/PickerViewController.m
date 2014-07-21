//
//  PickerViewController.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/22/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "PickerViewController.h"
#import "PickerFormViewController.h"

#define kImagePadding 10.f
#define kScrollBottomMargin 116.f // change this value
#define kImageFrameWidth (self.view.frame.size.width * 3/4)

@interface PickerViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) PickerFormViewController *pickerFormVC;

@end

@implementation PickerViewController

-(void)viewDidLoad {
  [super viewDidLoad];
  self.scrollView = [[UIScrollView alloc] init];
  self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kScrollBottomMargin);
  [self.view addSubview:self.scrollView];
  self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600.f); // was 420.f hard coded value
  [self presentForm];
}

-(void)viewWillAppear:(BOOL)animated {
  if (self.myItem) {
    _pickerFormVC.myItem = self.myItem;
  }
}

-(void)presentForm {
  _pickerFormVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pickerFormVC"];
  _pickerFormVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 600.f);
  _pickerFormVC.view.layer.cornerRadius = 10.f;
  _pickerFormVC.view.clipsToBounds = YES;
  
  [self.scrollView addSubview:_pickerFormVC.view];
  [self addChildViewController:_pickerFormVC];
  [_pickerFormVC didMoveToParentViewController:self];
}

#pragma mark - system

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
