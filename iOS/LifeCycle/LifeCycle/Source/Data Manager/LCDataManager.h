//
//  LCDataManager.h
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

@interface LCDataManager : NSObject

@property (nonatomic, readonly) NSArray *bikes;

+ (instancetype)sharedManager;

@end
