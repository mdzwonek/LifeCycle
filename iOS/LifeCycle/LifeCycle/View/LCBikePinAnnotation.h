//
//  LCMapPinAnnotation.h
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "LCBike.h"


@interface LCBikePinAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) LCBike *bike;

- (instancetype)initWithBike:(LCBike *)bike;

@end
