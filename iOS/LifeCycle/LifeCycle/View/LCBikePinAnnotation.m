//
//  LCMapPinAnnotation.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCBikePinAnnotation.h"


@interface LCBikePinAnnotation ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end


@implementation LCBikePinAnnotation

- (instancetype)initWithBike:(LCBike *)bike {
    self = [super init];
    if (self) {
        _bike = bike;
        _coordinate = bike.location.coordinate;
        _title = nil;
        _subtitle = nil;
    }
    
    return self;
}

@end