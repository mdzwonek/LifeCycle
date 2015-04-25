//
//  LCBikeDetailsViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCBikeDetailsViewController.h"
#import "LCBike.h"


@interface LCBikeDetailsViewController ()

@property (nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation LCBikeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = [NSString stringWithFormat:@"I'm an awesome bike located at (%f, %f)",
                            self.bike.location.coordinate.latitude,
                            self.bike.location.coordinate.longitude];
}

@end
