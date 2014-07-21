//
//  Item.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 7/6/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.image = [aDecoder decodeObjectForKey:@"image"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.detail = [aDecoder decodeObjectForKey:@"detail"];
    self.postDate = [aDecoder decodeObjectForKey:@"date"];
    self.price = [aDecoder decodeObjectForKey:@"price"];
    self.latitude = [aDecoder decodeFloatForKey:@"latitude"];
    self.longitude = [aDecoder decodeFloatForKey:@"longitude"];
    self.owner = [aDecoder decodeObjectForKey:@"owner"];
    self.renter = [aDecoder decodeObjectForKey:@"renter"];
  }
  return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.image forKey:@"image"];
  [aCoder encodeObject:self.title forKey:@"title"];
  [aCoder encodeObject:self.detail forKey:@"detail"];
  [aCoder encodeObject:self.postDate forKey:@"date"];
  [aCoder encodeObject:self.price forKey:@"price"];
  [aCoder encodeFloat:self.latitude forKey:@"latitude"];
  [aCoder encodeFloat:self.longitude forKey:@"longitude"];
  [aCoder encodeObject:self.owner forKey:@"owner"];
  [aCoder encodeObject:self.renter forKey:@"renter"];
}

@end
