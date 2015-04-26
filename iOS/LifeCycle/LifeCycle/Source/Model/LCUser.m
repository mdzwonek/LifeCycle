//
//  LCUser.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCUser.h"


@implementation LCUser

- (instancetype)initWithUserName:(NSString *)userName profileImageURL:(NSString *)profileImageURL {
    self = [super init];
    if (self) {
        _userName = userName;
        _profileImageURL = profileImageURL;
    }
    return self;
}

- (NSNumber *)rating {
    return @(4);
}

@end
