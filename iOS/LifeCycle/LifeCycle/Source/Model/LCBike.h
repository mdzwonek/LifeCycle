//
//  LCBike.h
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

@class LCUser;


@interface LCBike : NSObject

@property (nonatomic) CLLocation *location;
@property (nonatomic) LCUser *owner;

- (instancetype)initWithLocation:(CLLocation *)location owner:(LCUser *)owner;

@end
