//
//  LCBikeLocationViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 26/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LCBikeLocationViewController.h"
#import "LCBike.h"
#import "LCBikePinAnnotation.h"


@interface LCBikeLocationViewController () <MKMapViewDelegate>

@property (nonatomic) IBOutlet MKMapView *mapView;

@end


@implementation LCBikeLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView.region = MKCoordinateRegionMake(_bike.location.coordinate, MKCoordinateSpanMake(0.025, 0.025));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:[[LCBikePinAnnotation alloc] initWithBike:_bike]];
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

@end
