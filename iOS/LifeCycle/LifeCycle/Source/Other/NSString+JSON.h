//
//  NSString+JSON.h
//  connected
//
//  Created by Mateusz Dzwonek on 16/05/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

@interface NSString (JSON)

+ (NSString *)dictionaryToJSON:(NSDictionary *)dictionary;
- (NSDictionary *)jsonToDictionary;

@end
