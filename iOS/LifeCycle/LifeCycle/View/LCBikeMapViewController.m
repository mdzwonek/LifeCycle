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
#import "LCBikePinAnnotation.h"
#import "LCBikeDetailsViewController.h"


static NSString *const BikeDetailsSegueIdentifier = @"bike-details-segue";


@interface LCBikeMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UIButton *profileButton;

@property (nonatomic) CLLocationManager *locationManager;

@end


@implementation LCBikeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(51.508286, -0.059427), MKCoordinateSpanMake(0.04, 0.04));
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestAlwaysAuthorization];
    } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _mapView.showsUserLocation = YES;
    }
    
    _profileButton.layer.cornerRadius = 5.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[LCDataManager sharedManager] updateBikesWithCompletion:^{
        [self loadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)loadData {
    NSMutableArray *annotations = [NSMutableArray new];
    [[[LCDataManager sharedManager] bikes] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LCBike *bike = (LCBike *)obj;
        if (!bike.rented) {
            [annotations addObject:[[LCBikePinAnnotation alloc] initWithBike:bike]];
        }
    }];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:annotations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:BikeDetailsSegueIdentifier]) {
        LCBikeDetailsViewController *detailsViewController = (LCBikeDetailsViewController *)segue.destinationViewController;
        detailsViewController.bike = (LCBike *)sender;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _mapView.showsUserLocation = YES;
    }
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    if (annotation != mapView.userLocation) {
        static NSString *identifier = @"bike";
        
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (pinView == nil) {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        pinView.canShowCallout = NO;
        pinView.image = [UIImage imageNamed:@"bike"];
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (![view.annotation isKindOfClass:[LCBikePinAnnotation class]]) {
        return;
    }
    
    [mapView deselectAnnotation:view.annotation animated:NO];
    
    LCBikePinAnnotation *annotation = (LCBikePinAnnotation *)view.annotation;
    
    [self performSegueWithIdentifier:BikeDetailsSegueIdentifier sender:annotation.bike];
}

@end
