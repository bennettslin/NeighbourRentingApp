//
//  MapViewController.m
//  NeighbourRentingApp
//
//  Created by Bennett Lin on 6/22/14.
//  Copyright (c) 2014 Bennett Lin. All rights reserved.
//

#import "MapViewController.h"
#import "Annotation.h"

@interface MapViewController () <MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, NSURLSessionDataDelegate>

@end

@implementation MapViewController {
  CLLocationCoordinate2D _tempCoordinate;
}

-(void)viewDidLoad {
  [super viewDidLoad];
  self.mapAnnotations = [[NSMutableArray alloc] init];
  
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  
  self.mapView = [[MKMapView alloc] init];
  self.mapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
  self.mapView.mapType = MKMapTypeHybrid;
  self.mapView.zoomEnabled = YES; // YES is the default
  self.mapView.scrollEnabled = YES; // YES is the default
  
  self.addressField.placeholder = @"find annotations near this address";
  self.addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.addressField.delegate = self;
  [self.view addSubview:self.mapView];
  
    // place annotation
  UILongPressGestureRecognizer *lpgRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addPinWherePressed:)];
  lpgRecognizer.minimumPressDuration = 1.0;
  [self.mapView addGestureRecognizer:lpgRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self reverseGeocodeUsingUserLocation];
}

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - geocode methods

-(void)forwardGeocodeUsingAddressInField {
  CLGeocoder *geocoder = [[CLGeocoder alloc] init];
  [geocoder geocodeAddressString:self.addressField.text
               completionHandler:^(NSArray *placemarks, NSError *error) {
                 NSLog(@"Number of placemarks: %lu", (unsigned long)[placemarks count]);
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 _tempCoordinate = placemark.location.coordinate;
                 for (Annotation *annotation in self.mapAnnotations) {
                   [self.mapView removeAnnotation:annotation];
                 }
                 [self.mapAnnotations removeAllObjects];
                 Annotation *searchedLocation = [[Annotation alloc]
                                                   initWithTitle:@"Searched Address"
                                                   subtitle:@""
                                                   lat:[NSNumber numberWithDouble:placemark.location.coordinate.latitude]
                                                   lng:[NSNumber numberWithDouble:placemark.location.coordinate.longitude]];
                 [self.mapAnnotations addObject:searchedLocation];
                 [self centerOnLocationCoordinate:placemark.location.coordinate];
                 [self getAnnotationsNearLocation:placemark.location.coordinate];
               }];
}

-(void)reverseGeocodeUsingUserLocation {
  CLGeocoder *geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:self.mapView.userLocation.location
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                   NSLog(@"Number of placemarks: %lu", (unsigned long)[placemarks count]);
                   CLPlacemark *placemark = [placemarks objectAtIndex:0];
                   NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@ %@",
                                        placemark.subThoroughfare, placemark.thoroughfare, placemark.locality,
                                        placemark.administrativeArea, placemark.postalCode];
                   self.addressField.text = address;
                   [self centerOnLocationCoordinate:self.mapView.userLocation.location.coordinate];
                 }];
}

#pragma mark - mapKit methods

-(void)centerOnLocationCoordinate:(CLLocationCoordinate2D)coordinate {
  CLLocationCoordinate2D center = coordinate;
  CLLocationDistance width = 1000;
  CLLocationDistance height = 1000;
  MKCoordinateRegion region =
  MKCoordinateRegionMakeWithDistance(center, width, height);
  [self.mapView setRegion:region animated:NO];
}

-(void)getAnnotationsNearLocation:(CLLocationCoordinate2D)location {
  [self loadURLDataForLocationCoordinate:location];
}

-(void)loadURLDataForLocationCoordinate:(CLLocationCoordinate2D)coordinate {
  NSString *thisString = @"http://bee.engineering-ronin.com/gethives";
    //  NSString *thisString = [NSString stringWithFormat:@"/gethives/%f,%f,%f,%f",
    //                          coordinate.longitude - .45f,
    //                          coordinate.latitude - .45f,
    //                          coordinate.longitude + .45f,
    //                          coordinate.latitude + .45f];
  NSURL *dataURL = [NSURL URLWithString:thisString];
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
  NSURLSessionDataTask *dataTask = [session dataTaskWithURL:dataURL
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            self.dataFromURL = data;
                                            [self addAnnotationsFromParsedData:self.dataFromURL];
                                          }];
  [dataTask resume];
}

-(double)searchedLocationDistanceFromLat:(NSNumber *)lat andLng:(NSNumber *)lng {
    //  NSLog(@"The tempCoordinate is %f, %f", _tempCoordinate.latitude, _tempCoordinate.longitude);
    //  NSLog(@"The sent coordinates are %f, %f", [lat doubleValue], [lng doubleValue]);
  double a = _tempCoordinate.latitude - [lat doubleValue];
    //  NSLog(@"The value of a is %f", a);
  double b = _tempCoordinate.longitude - [lng doubleValue];
    //  NSLog(@"The value of b is %f", b);
  double c = sqrt((a * a) + (b * b));
    //  NSLog(@"The distance is %f", c);
  return c;
}

-(void)addAnnotationsFromParsedData:(NSData *)data {
  NSLog(@"add annotations");
  NSError *error;
  NSArray *mainArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //  NSArray *mainArray = [mainDictionary valueForKeyPath:@"response.venues"];
  NSLog(@"dictionary %@", mainArray);
  NSLog(@"dictionary count %lu", (unsigned long)mainArray.count);
  
  for (NSDictionary *dictionary in mainArray) {
    NSLog(@"dictionary is class %@", [dictionary class]);
    NSString *hiveName = [dictionary objectForKey:@"name"];
    NSLog(@"Adding this hive: %@", hiveName);
    NSString *hiveID = [dictionary objectForKey:@"id"];
      //    NSString *address = [dictionary valueForKeyPath:@"location.address"];
    NSNumber *lat = [dictionary valueForKeyPath:@"latitude"];
    NSNumber *lng = [dictionary valueForKeyPath:@"longitude"];
    
    NSLog(@"%@, %@, %@", hiveID, lat, lng);
    double distance = [self searchedLocationDistanceFromLat:lat andLng:lng];
    
      // only adds annotation if hive is less than around 2 miles away
    if (distance < 999999) {
      Annotation *annotation = [[Annotation alloc] initWithTitle:hiveName subtitle:@"" lat:lat lng:lng];
      [self.mapAnnotations addObject:annotation];
      NSLog(@"Number of annotations in self.mapAnnotations: %lu", (unsigned long)[self.mapAnnotations count]);
      for (Annotation *annotation in self.mapAnnotations) {
        [self.mapView addAnnotation:annotation];
      }
    }
  }
  
  [self centerOnAnnotations];
}

-(void)centerOnAnnotations {
    // for figuring out region of annotations
  NSMutableArray *allLats = [[NSMutableArray alloc] init];
  NSMutableArray *allLngs = [[NSMutableArray alloc] init];
  
  for (Annotation *annotation in self.mapAnnotations) {
    [allLats addObject:[NSNumber numberWithDouble:annotation.coordinate.latitude]];
    [allLngs addObject:[NSNumber numberWithDouble:annotation.coordinate.longitude]];
  }
  
  if (allLats.count > 0 && allLngs.count > 0) {
      // arranges in ascending order
    [allLats sortUsingSelector:@selector(compare:)];
    [allLngs sortUsingSelector:@selector(compare:)];
      // points determine furthest ends of rectangle
    double smallestLat = [allLats[0] doubleValue];
    double smallestLng = [allLngs[0] doubleValue];
    double biggestLat = [[allLats lastObject] doubleValue];
    double biggestLng = [[allLngs lastObject] doubleValue];
    CLLocationCoordinate2D annotationsCenter = CLLocationCoordinate2DMake((biggestLat + smallestLat) / 2.0,
                                                                          (biggestLng + smallestLng) / 2.0);
    MKCoordinateSpan annotationsSpan = MKCoordinateSpanMake((biggestLat - smallestLat) + 0.02,
                                                            (biggestLng - smallestLng) + 0.01);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(annotationsCenter, annotationsSpan);
    
    [self.mapView setRegion:region];
  }
}

-(void)addPinWherePressed:(UIGestureRecognizer *)gestureRecognizer {
  
  if (gestureRecognizer.state !=UIGestureRecognizerStateBegan) {
    return;
  } else {
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    Annotation *annotation = [[Annotation alloc] init];
    annotation.coordinate = touchCoordinate;
    annotation.title = @"my hive";
    [self.mapView addAnnotation:annotation];
  }
}

#pragma mark - delegate methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  if (self.userLocationUpdated == NO) {
    _tempCoordinate = self.mapView.userLocation.location.coordinate;
    [self.mapAnnotations removeAllObjects];
      //  [self centerOnLocationCoordinate:self.mapView.userLocation.location.coordinate];
    [self getAnnotationsNearLocation:self.mapView.userLocation.location.coordinate];
  }
  self.userLocationUpdated = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  [self forwardGeocodeUsingAddressInField];
  return YES;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status != kCLAuthorizationStatusAuthorized) {
    self.getUserLocationAndAddressButton.hidden = YES;
    [self.navigationController setToolbarHidden:YES];
    NSLog(@"authorizationStatus not authorized.");
    self.userLocationUpdated = NO;
  } else if (status == kCLAuthorizationStatusAuthorized) {
    self.getUserLocationAndAddressButton.hidden = NO;
    [self.navigationController setToolbarHidden:NO];
    NSLog(@"authorizationStatus authorized.");
    self.userLocationUpdated = NO;
  }
}

@end
