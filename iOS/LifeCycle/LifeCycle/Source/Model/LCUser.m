//
//  LCUser.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCUser.h"


@implementation LCUser

- (instancetype)initWithUserName:(NSString *)userName profileImageURL:(NSString *)profileImageURL rating:(NSNumber *)rating {
    self = [super init];
    if (self) {
        _userName = userName;
        _profileImageURL = profileImageURL;
        _rating = rating;
    }
    return self;
}

@end
