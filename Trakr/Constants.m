//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Constants.h"


@implementation Constants {

}

+ (NSDictionary *)UNIT {
    static NSDictionary *aDict;
    if (!aDict) {
        aDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                @1, @"Chapter",
                @2, @"Page",
//                @3, @"Episode",
//                @4, @"Lecture",
//                @5, @"Assignment",
//                @6, @"Quiz",
                nil];
    }
    return aDict;
}

+ (NSNumber *)getUnitForName:(NSString *)name {
    return [[Constants UNIT] objectForKey:name];
}

+ (NSString *)getNameForUnit:(NSNumber *)unit {
    return [[[Constants UNIT] allKeysForObject:unit] objectAtIndex:0];
}

+ (NSString *)getUnitNameAtIndex:(NSUInteger)index {
    return [[[Constants UNIT] allKeys] objectAtIndex:index];
}

+ (NSDictionary *)REPEAT {
    static NSDictionary *aDict;
    if (!aDict) {
        aDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                @1, @"Every Day",
                @2, @"Every Week",
//                @3, @"Every Two Weeks",
                @4, @"Every Month",
//                @5, @"Every Year",
//                @6, @"Custom",
                nil];
    }
    return aDict;
}

@end