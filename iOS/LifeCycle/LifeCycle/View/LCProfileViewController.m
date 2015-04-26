//
//  LCProfileViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 26/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCProfileViewController.h"
#import "LCDataManager.h"
#import "UIImageView+AFNetworking.h"
#import "LCDataManager.h"
#import "LCBike.h"
#import "LCUser.h"
#import "LCStyling.h"
#import "LCBikeLocationViewController.h"


@interface LCProfileViewController ()

@property (nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (nonatomic) IBOutlet UILabel *rentStatusLabel;
@property (nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic) IBOutlet UIButton *bikesButton;

@property (nonatomic) LCBike *bike;
@property (nonatomic) CLGeocoder *geocoder;

@end


@implementation LCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *bikes = [[LCDataManager sharedManager] bikes];
    for (LCBike *bike in bikes) {
        if ([bike.owner.userName isEqualToString:[[LCDataManager sharedManager] userFullName]]) {
            self.bike = bike;
        }
    }
    
    LCDataManager *dataManager = [LCDataManager sharedManager];
    _profileImageView.layer.borderWidth = 2.0f;
    _profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _profileImageView.layer.cornerRadius = CGRectGetWidth(_profileImageView.frame) / 2.0f;
    [_profileImageView setImageWithURL:[NSURL URLWithString:dataManager.profileImageURL] placeholderImage:[UIImage imageNamed:@"person.png"]];
    _userFullNameLabel.text = dataManager.userFullName;
    
    _rentStatusLabel.text = _bike.rented ? @"rented" : @"not rented";
    _rentStatusLabel.textColor = _bike.rented ? [LCStyling redColor] : [LCStyling mainColor];
    
    _addressLabel.text = @"(refreshing...)";
    [self refreshAddress];
    
    _bikesButton.layer.cornerRadius = 5.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)refreshAddress {
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder reverseGeocodeLocation:_bike.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error != nil && [error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorGeocodeCanceled) {
            return;
        } else if (placemarks == nil || placemarks.count < 1) {
            return;
        }
        
        CLPlacemark *placemark = placemarks[0];
        NSString *street = placemark.thoroughfare;
        NSString *city = placemark.locality;
        NSString *administrativeArea = placemark.administrativeArea;
        
        NSString *address;
        if (street != nil && city != nil) {
            address = [NSString stringWithFormat:@"%@, %@", street, city];
        } else if (city != nil && administrativeArea != nil) {
            address = [NSString stringWithFormat:@"%@, %@", city, administrativeArea];
        } else if (street != nil) {
            address = [NSString stringWithFormat:@"%@", street];
        } else if (city != nil) {
            address = [NSString stringWithFormat:@"%@", city];
        }

        self.addressLabel.text = address;
    }];
}

- (IBAction)didTapBikesButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"bike-location-segue"]) {
        LCBikeLocationViewController *bikeLocationViewController = (LCBikeLocationViewController *)segue.destinationViewController;
        bikeLocationViewController.bike = _bike;
    }
}

@end
