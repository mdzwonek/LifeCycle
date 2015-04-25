//
//  LCBikeMapViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LCBikeMapViewController.h"
#import "LCBike.h"
#import "LCDataManager.h"
#import "LCMapPinAnnotation.h"


@interface LCBikeMapViewController () <CLLocationManagerDelegate>

@property (nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) CLLocationManager *locationManager;

@end


@implementation LCBikeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(51.508286, -0.059427), MKCoordinateSpanMake(0.025, 0.025));
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
    
    [self loadData];
}

- (void)loadData {
    NSMutableArray *annotations = [NSMutableArray new];
    [[[LCDataManager sharedManager] bikes] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LCBike *bike = (LCBike *)obj;
        [annotations addObject:[[LCMapPinAnnotation alloc] initWithCoordinates:bike.location.coordinate placeName:nil description:nil]];
    }];
    [self.mapView addAnnotations:annotations];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
}

@end
