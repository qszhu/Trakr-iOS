//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Repeat.h"


@implementation Repeat {

}

NSString *const kRepeatEveryDay = @"Every Day";
NSString *const kRepeatEveryWeek = @"Every Week";
NSString *const kRepeatEveryMonth = @"Every Month";

+ (NSDictionary *)REPEAT {
    static NSDictionary *aDict;
    if (!aDict) {
        aDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                @1, kRepeatEveryDay,
                @2, kRepeatEveryWeek,
//                @3, @"Every Two Weeks",
                @4, kRepeatEveryMonth,
//                @5, @"Every Year",
//                @6, @"Custom",
                nil];
    }
    return aDict;
}

+ (NSUInteger)count {
    return [[Repeat REPEAT] count];
}

+ (NSNumber *)getValueForName:(NSString *)name {
    return [[Repeat REPEAT] objectForKey:name];
}

+ (NSString *)getNameForValue:(NSNumber *)unit {
    return [[[Repeat REPEAT] allKeysForObject:unit] objectAtIndex:0];
}

+ (NSString *)getNameAtIndex:(NSUInteger)index {
    return [[[Repeat REPEAT] allKeys] objectAtIndex:index];
}

+ (NSNumber *)getValueAtIndex:(NSUInteger)index {
    return [[[Repeat REPEAT] allValues] objectAtIndex:index];
}

@end