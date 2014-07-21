//
//  Annotation.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/22/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle
               lat:(NSNumber *)latitude lng:(NSNumber *)longitude {
  self = [super init];
  if (self) {
    self.title = title;
    self.subtitle = subtitle;
    
    double lat = [latitude doubleValue];
    double lng = [longitude doubleValue];
    self.coordinate = CLLocationCoordinate2DMake(lat, lng);
  }
  return self;
}

@end
