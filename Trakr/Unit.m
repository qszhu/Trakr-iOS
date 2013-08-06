//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Unit.h"

@implementation Unit {

}

NSString *const kUnitChapter = @"Chapter";
NSString *const kUnitPage = @"Page";

+ (NSDictionary *)UNIT {
    static NSDictionary *aDict;
    if (!aDict) {
        aDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                @1, kUnitChapter,
                @2, kUnitPage,
//                @3, @"Episode",
//                @4, @"Lecture",
//                @5, @"Assignment",
//                @6, @"Quiz",
                nil];
    }
    return aDict;
}

+ (NSUInteger)count {
    return [[Unit UNIT] count];
}

+ (NSNumber *)getValueForName:(NSString *)name {
    return [[Unit UNIT] objectForKey:name];
}

+ (NSString *)getNameForValue:(NSNumber *)unit {
    return [[[Unit UNIT] allKeysForObject:unit] objectAtIndex:0];
}

+ (NSString *)getNameAtIndex:(NSUInteger)index {
    return [[[Unit UNIT] allKeys] objectAtIndex:index];
}

+ (NSNumber *)getValueAtIndex:(NSUInteger)index {
    return [[[Unit UNIT] allValues] objectAtIndex:index];
}

@end