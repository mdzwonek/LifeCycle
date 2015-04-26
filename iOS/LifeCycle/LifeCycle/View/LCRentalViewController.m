//
//  LCRentalViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCRentalViewController.h"
#import "LCDataManager.h"
#import "LCBike.h"


@interface LCRentalViewController () <CLLocationManagerDelegate>

@property (nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic) IBOutlet UILabel *codeLabel;

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSTimer *timer;

@property (nonatomic, readonly) BOOL rentalHasEnded;

@property (nonatomic) CLLocationManager *locationManager;

- (void)endRental;

@end


@implementation LCRentalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _codeLabel.text = _bike.code;
    
    self.startDate = [NSDate new];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
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


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"New location %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

@end
