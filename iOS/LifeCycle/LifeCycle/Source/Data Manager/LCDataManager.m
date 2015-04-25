//
//  LCDataManager.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCDataManager.h"
#import "LCUser.h"
#import "LCBike.h"


@interface LCDataManager ()

@property (nonatomic) NSArray *bikes;

- (instancetype)initPrivate;

@end


@implementation LCDataManager

+ (instancetype)sharedManager {
    static LCDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LCDataManager alloc] initPrivate];
    });
    return instance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        LCUser *user = [[LCUser alloc] initWithUserName:@"Mateusz Dzwonek" profileImageURL:@"https://graph.facebook.com/mateusz.dzwonek/picture"];
        _bikes = @[ [[LCBike alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:51.511 longitude:-0.056] owner:user],
                    [[LCBike alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:51.505 longitude:-0.057] owner:user],
                    [[LCBike alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:51.508 longitude:-0.067] owner:user] ];
    }
    return self;
}

@end
