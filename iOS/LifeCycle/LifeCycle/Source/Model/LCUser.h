//
//  LCUser.h
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

@interface LCUser : NSObject

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *profileImageURL;
@property (nonatomic) NSNumber *rating;

- (instancetype)initWithUserName:(NSString *)userName profileImageURL:(NSString *)profileImageURL rating:(NSNumber *)rating;

@end
