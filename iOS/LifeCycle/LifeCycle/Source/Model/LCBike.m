//
//  LCBike.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCBike.h"

@implementation LCBike

- (instancetype)initWithLocation:(CLLocation *)location {
    self = [super init];
    if (self) {
        _location = location;
    }
    return self;
}

@end
