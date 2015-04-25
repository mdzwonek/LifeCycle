//
//  LCDataManager.h
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

@class LCBike;


@interface LCDataManager : NSObject

@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) NSString *userFullName;
@property (nonatomic, readonly) NSString *profileImageURL;
@property (nonatomic, readonly) BOOL userIsLoggedIn;
@property (nonatomic, readonly) NSArray *bikes;

+ (instancetype)sharedManager;

- (void)loginWithUsername:(NSString *)username fullName:(NSString *)fullName profileImageURL:(NSString *)profileImageURL completion:(void (^)())completion;
- (void)updateBikesWithCompletion:(void (^)())completion;

- (void)rentBike:(LCBike *)bike;
- (void)returnBike:(LCBike *)bike atLocation:(CLLocation *)location;

@end
