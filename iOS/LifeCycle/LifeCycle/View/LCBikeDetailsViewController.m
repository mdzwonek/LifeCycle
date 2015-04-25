//
//  LCBikeDetailsViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LCBikeDetailsViewController.h"
#import "LCUser.h"
#import "LCBike.h"
#import "LCBikePinAnnotation.h"
#import "LCStyling.h"
#import "UIImageView+AFNetworking.h"


@interface LCBikeDetailsViewController () <MKMapViewDelegate>

@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic) IBOutlet UIButton *bookButton;

@end


@implementation LCBikeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView.region = MKCoordinateRegionMake(_bike.location.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [_mapView addAnnotation:[[LCBikePinAnnotation alloc] initWithBike:_bike]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    });
    
    _profileImageView.layer.borderWidth = 2.0f;
    _profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _profileImageView.layer.cornerRadius = CGRectGetWidth(_profileImageView.frame) / 2.0f;
    [_profileImageView setImageWithURL:[NSURL URLWithString:_bike.owner.profileImageURL] placeholderImage:[UIImage imageNamed:@"person.png"]];
    
    _userNameLabel.text = _bike.owner.userName;
    
    _bookButton.backgroundColor = [[LCStyling mainColor] colorWithAlphaComponent:0.8f];
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
