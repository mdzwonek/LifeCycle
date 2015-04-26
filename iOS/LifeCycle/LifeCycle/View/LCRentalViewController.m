//
//  LCRentalViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LCRentalViewController.h"
#import "LCDataManager.h"
#import "LCBike.h"


@interface LCRentalViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) IBOutlet UILabel *codeLabel;
@property (nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSTimer *timer;

@property (nonatomic, readonly) BOOL rentalHasEnded;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) MKPolylineRenderer *pathRenderer;
@property (nonatomic) MKPolyline *path;
@property (nonatomic) NSMutableArray *locationHistory;

- (void)endRental;

@end


@implementation LCRentalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _codeLabel.text = _bike.code;
    
    _mapView.region = MKCoordinateRegionMake(_bike.location.coordinate, MKCoordinateSpanMake(0.025, 0.025));
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    });
    
    self.startDate = [NSDate new];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    _locationHistory = [NSMutableArray new];
    
    [[LCDataManager sharedManager] rentBike:_bike];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.rentalHasEnded) {
        [self endRental];
    }
}

- (void)onTimer {
    NSUInteger unitFlags = NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate new];
    NSDateComponents *components = [calendar components:unitFlags fromDate:_startDate toDate:now options:0];
    NSString *timeElaplsed = [NSString stringWithFormat:@"%02ld:%02ld", (long)components.minute, (long)components.second];
    self.timerLabel.text = timeElaplsed;
}

- (IBAction)didTapFinishButton:(id)sender {
    [self endRental];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endRental {
    [[LCDataManager sharedManager] returnBike:_bike atLocation:_locationManager.location];
    [_timer invalidate];
}

- (BOOL)rentalHasEnded {
    return !_timer.isValid;
}

- (void)registerNewLocation:(CLLocation *)location {
    [[LCDataManager sharedManager] updateLocation:location ofBike:_bike];
    [_locationHistory addObject:location];
    
    CLLocationCoordinate2D coordinates[_locationHistory.count];
    for (NSInteger i = 0; i < _locationHistory.count; i++) {
        coordinates[i] = [_locationHistory[i] coordinate];
    }
    
    [_mapView removeOverlay:_path];
    self.path = [MKPolyline polylineWithCoordinates:coordinates count:_locationHistory.count];
    [_mapView addOverlay:_path];
    
    self.pathRenderer = [[MKPolylineRenderer alloc] initWithPolyline:_path];
    _pathRenderer.strokeColor = [UIColor redColor];
    _pathRenderer.lineWidth = 5;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self registerNewLocation:newLocation];
    NSLog(@"New location %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager: didFailWithError: %@", error);
}


#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    return _pathRenderer;
}

@end
