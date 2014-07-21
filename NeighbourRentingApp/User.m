//
//  User.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 7/6/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "User.h"
#import "Item.h"

@interface User ()

@end

@implementation User

-(id)initWithName:(NSString *)userName andProfileImage:(UIImage *)profileImage {
  self = [super init];
  if (self) {
    NSLog(@"user custom init");
    self.userName = userName;
    self.profileImage = profileImage;
    self.myListings = @[];
  }
  return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.userName = [aDecoder decodeObjectForKey:@"userName"];
    if (!self.userName) {
      self.userName = @"no FB account guy";
    }
    self.profileImage = [aDecoder decodeObjectForKey:@"profileView"];
    self.myListings = [aDecoder decodeObjectForKey:@"myListings"];
    if (!self.myListings) {
      self.myListings = @[];
    }
  }
  return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.userName forKey:@"userName"];
  [aCoder encodeObject:self.profileImage forKey:@"profileView"];
  [aCoder encodeObject:self.myListings forKey:@"myListings"];
}

+(void)saveMyUser:(User *)user {
  [NSKeyedArchiver archiveRootObject:user toFile:[User getPathToArchive]];
}

+(User *)getMyUser {
  return [NSKeyedUnarchiver unarchiveObjectWithFile:[User getPathToArchive]];
}

-(void)addItem:(Item *)item {
  NSMutableArray *mutableArray = self.myListings ?
    [NSMutableArray arrayWithArray:self.myListings] : [NSMutableArray new];
  
  [mutableArray addObject:item];
  self.myListings = [NSArray arrayWithArray:mutableArray];
}

+(NSString *)getPathToArchive {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *directory = [paths objectAtIndex:0];
  NSString *pathString = [directory stringByAppendingPathComponent:@"myUser.plist"];
//  NSLog(@"path is %@", pathString);
  return pathString;
}

#pragma mark - singleton method

+(User *)user {
  static dispatch_once_t pred;
  static User *shared = nil;
  dispatch_once(&pred, ^{
    shared = [[User alloc] init];
  });
  return shared;
}

@end
