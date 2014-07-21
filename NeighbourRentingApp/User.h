//
//  User.h
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 7/6/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Item;

@interface User : NSObject <NSCoding>

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSArray *myListings;

-(id)initWithName:(NSString *)userName andProfileImage:(UIImage *)profileImage;

+(User *)getMyUser;
+(void)saveMyUser:(User *)user;
-(void)addItem:(Item *)item;

@end
