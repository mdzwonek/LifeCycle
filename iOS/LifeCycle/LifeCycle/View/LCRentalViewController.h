//
//  LCRentalViewController.h
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "PayPalMobile.h"

@class PayPalConfiguration;
@class LCBike;

#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface LCRentalViewController : UIViewController<PayPalPaymentDelegate>

@property (nonatomic) LCBike *bike;

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

- (void)pay;

@end
