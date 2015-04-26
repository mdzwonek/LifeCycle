//
//  LCBike.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCBike.h"

@implementation LCBike

- (instancetype)initWithID:(NSNumber *)bikeID location:(CLLocation *)location owner:(LCUser *)owner rented:(BOOL)rented {
    self = [super init];
    if (self) {
        _bikeID = bikeID;
        _location = location;
        _owner = owner;
        _rented = rented;
    }
    return self;
}

- (NSString *)nearableIdentifier {
    return @"7da014651bfbbb85";
}

@end
