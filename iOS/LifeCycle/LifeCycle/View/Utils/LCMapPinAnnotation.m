//
//  LCMapPinAnnotation.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCMapPinAnnotation.h"


@interface LCMapPinAnnotation ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end


@implementation LCMapPinAnnotation

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description {
    self = [super init];
    if (self) {
        _coordinate = location;
        _title = placeName;
        _subtitle = description;
    }
    
    return self;
}

@end