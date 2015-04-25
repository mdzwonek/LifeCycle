//
//  LCBike.h
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

@interface LCBike : NSObject

@property (nonatomic) CLLocation *location;

- (instancetype)initWithLocation:(CLLocation *)location;

@end
