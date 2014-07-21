//
//  ItemsViewController.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 7/6/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemViewCell.h"
#import "User.h"
#import "Item.h"

@interface ItemsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ItemsViewController

-(void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveUser:) name:@"sendUser" object:nil];
  
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
}

-(void)viewWillAppear:(BOOL)animated {
    // post notification to get user from mainVC
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter postNotificationName:@"presentItems" object:self userInfo:nil];
}

#pragma mark - collection view data source and delegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.myUser.myListings.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
  
  Item *item = self.myUser.myListings[indexPath.row];
  cell.imageView.image = item.image;
  cell.titleLabel.text = item.title;
  cell.ownerLabel.text = item.owner.userName;
  cell.priceLabel.text = [item.price descriptionWithLocale:[NSLocale currentLocale]];
  return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
  Item *myItem = self.myUser.myListings[indexPath.row];
  NSMutableDictionary *itemInfo = [NSMutableDictionary dictionary];
  [itemInfo setObject:myItem forKey:@"item"];
  
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter postNotificationName:@"editItem" object:self userInfo:itemInfo];
}

#pragma mark - NSNotification methods

-(void)retrieveUser:(NSNotification *)notification {
  if ([notification.name isEqualToString:@"sendUser"]) {
    NSDictionary *userInfo = notification.userInfo;
    self.myUser = [userInfo objectForKey:@"user"];
    [self.collectionView reloadData];
  }
}

#pragma mark - system methods

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
