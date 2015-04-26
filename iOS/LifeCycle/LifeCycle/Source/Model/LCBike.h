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
@property (nonatomic) NSString *nearableIdentifier;
@property (nonatomic) BOOL rented;
@property (nonatomic) NSString *code;
@property (nonatomic) NSArray *pictures;

- (instancetype)initWithID:(NSNumber *)bikeID location:(CLLocation *)location owner:(LCUser *)owner rented:(BOOL)rented code:(NSString *)code pictures:(NSArray *)pictures;

@end
