//
//  PickerFormViewController.h
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/22/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item;

@protocol PickerFormDelegate;

@interface PickerFormViewController : UIViewController

@property (weak, nonatomic) id<PickerFormDelegate> delegate;
@property (strong, nonatomic) Item *myItem;

-(void)updatePickedImage:(UIImage *)pickedImage;

@end

@protocol PickerFormDelegate <NSObject>

@end
