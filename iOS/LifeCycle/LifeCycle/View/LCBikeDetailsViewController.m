//
//  LCBikeDetailsViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import <EstimoteSDK/EstimoteSDK.h>
#import <MapKit/MapKit.h>
#import "LCBikeDetailsViewController.h"
#import "LCUser.h"
#import "LCBike.h"
#import "LCBikePinAnnotation.h"
#import "LCRentalViewController.h"
#import "LCStyling.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+MHFacebookImageViewer.h"


@interface LCBikePictureCell : UICollectionViewCell
@property (nonatomic) IBOutlet UIImageView *pictureImageView;

@end


@implementation LCBikePictureCell

@end


@interface LCBikeDetailsViewController () <ESTNearableManagerDelegate, MKMapViewDelegate, UICollectionViewDataSource>

@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic) IBOutletCollection(UIImageView) NSArray *starImageViews;
@property (nonatomic) IBOutlet UIView *nearableView;
@property (nonatomic) IBOutlet NSLayoutConstraint *nearableLeftConstraint;
@property (nonatomic) IBOutlet UIButton *bookButton;

@property (nonatomic) ESTNearableManager *nearableManager;
@property (nonatomic) ESTBeaconManager *beaconManager;

@end


@implementation LCBikeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView.region = MKCoordinateRegionMake(_bike.location.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    });
    
    _profileImageView.layer.borderWidth = 2.0f;
    _profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _profileImageView.layer.cornerRadius = CGRectGetWidth(_profileImageView.frame) / 2.0f;
    [_profileImageView setImageWithURL:[NSURL URLWithString:_bike.owner.profileImageURL] placeholderImage:[UIImage imageNamed:@"person.png"]];
    
    _userNameLabel.text = _bike.owner.userName;
    
    for (NSInteger i = 0; i < _starImageViews.count; i++) {
        UIImageView *starImageView = _starImageViews[i];
        starImageView.image = [UIImage imageNamed:_bike.owner.rating.integerValue > i ? @"star_full" : @"star_empty"];
    }
    
    _bookButton.backgroundColor = [[LCStyling mainColor] colorWithAlphaComponent:0.8f];
    
    [self initializeEstimoteTracking];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:[[LCBikePinAnnotation alloc] initWithBike:_bike]];
}

- (void)initializeEstimoteTracking {
    self.nearableManager = [[ESTNearableManager alloc] init];
    _nearableManager.delegate = self;
    [_nearableManager startRangingForIdentifier:_bike.nearableIdentifier];
}

- (void)tearDownEstimoteTracking {
    [_nearableManager stopMonitoring];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"rental-segue"]) {
        LCRentalViewController *rentalViewController = (LCRentalViewController *)segue.destinationViewController;
        rentalViewController.bike = _bike;
    }
    [super prepareForSegue:segue sender:sender];
}


#pragma mark - ESTNearableManagerDelegate

- (void)nearableManager:(ESTNearableManager *)manager didRangeNearable:(ESTNearable *)nearable {
    if ([nearable.identifier isEqualToString:_bike.nearableIdentifier]) {
        NSLog(@"%ld", (long)nearable.zone);
        NSArray *constants = @[ @(0.81), @(0.14f), @(0.36f), @(0.6f) ];
        NSNumber *percentage = constants[nearable.zone];
        _nearableLeftConstraint.constant = percentage.floatValue * CGRectGetWidth(_nearableView.superview.frame);
        [UIView animateWithDuration:0.25f animations:^{
            [_nearableView layoutIfNeeded];
        }];
    }
}

- (void)nearableManager:(ESTNearableManager *)manager rangingFailedWithError:(NSError *)error {
    NSLog(@"nearableManager: rangingFailedWithError: %@", error);
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


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _bike.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCBikePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.pictureImageView setImageWithURL:[NSURL URLWithString:_bike.pictures[indexPath.row]] placeholderImage:[UIImage new]];
    [cell.pictureImageView setupImageViewer];
    return cell;
}

@end
