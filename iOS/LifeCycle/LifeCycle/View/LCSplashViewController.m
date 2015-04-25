//
//  LCSplashViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCSplashViewController.h"
#import "LCDataManager.h"


@implementation LCSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[LCDataManager sharedManager] userIsLoggedIn]) {
        [self performSegueWithIdentifier:@"login-segue" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"splash-bike-map-segue" sender:nil];
    }
}

@end
