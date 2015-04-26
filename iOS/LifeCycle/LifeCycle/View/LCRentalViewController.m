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

#import "PayPalConfiguration.h"


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
    
    self.payPalConfiguration = [[PayPalConfiguration alloc] init];
    self.payPalConfiguration.acceptCreditCards = YES;
    self.payPalConfiguration.merchantName = @"Awesome Shirts, Inc.";
    self.payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    self.payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    self.environment = kPayPalEnvironment;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

- (void)onTimer {
    NSUInteger unitFlags = NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate new];
    NSDateComponents *components = [calendar components:unitFlags fromDate:_startDate toDate:now options:0];
    NSString *timeElaplsed = [NSString stringWithFormat:@"%02ld:%02ld", (long)components.minute, (long)components.second];
    self.timerLabel.text = timeElaplsed;
}

- (void)pay {
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Bike rental"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"1.49"]
                                    withCurrency:@"GBP"
                                         withSku:@"Bike-00037"];
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"GBP";
    payment.shortDescription = @"Bike rental";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfiguration.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfiguration
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        NSArray *viewControllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:viewControllers[viewControllers.count - 3] animated:YES];
    }];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    [paymentViewController dismissViewControllerAnimated:YES completion:^{
        NSArray *viewControllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:viewControllers[viewControllers.count - 3] animated:YES];
    }];
}

- (IBAction)didTapFinishButton:(id)sender {
    [self endRental];
    [self pay];
}

- (void)endRental {
    [[LCDataManager sharedManager] returnBike:_bike atLocation:_locationManager.location];
    [_locationManager stopUpdatingLocation];
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
