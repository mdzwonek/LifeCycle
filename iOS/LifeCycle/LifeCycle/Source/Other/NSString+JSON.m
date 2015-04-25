//
//  NSString+JSON.m
//  connected
//
//  Created by Mateusz Dzwonek on 16/05/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

+ (NSString *)dictionaryToJSON:(NSDictionary *)dictionary {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
    if (!jsonData) {
        return nil;
    } else {
        return [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    }
    
}

- (NSDictionary *)jsonToDictionary {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
    if (!result) {
        return nil;
    } else {
        return result;
    }
}

@end
