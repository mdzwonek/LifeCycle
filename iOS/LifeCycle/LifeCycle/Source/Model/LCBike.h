//
//  LCBike.h
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

@class LCUser;


@interface LCBike : NSObject

@property (nonatomic) NSNumber *bikeID;
@property (nonatomic) CLLocation *location;
@property (nonatomic) LCUser *owner;

- (instancetype)initWithID:(NSNumber *)bikeID location:(CLLocation *)location owner:(LCUser *)owner;

@end
