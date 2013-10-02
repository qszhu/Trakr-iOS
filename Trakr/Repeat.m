//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Repeat.h"


@implementation Repeat {

}

+ (NSArray *)values {
    static NSArray *values;
    if (!values) {
        values = @[
            [NSNumber numberWithInteger:kRepeatEveryDay],
            [NSNumber numberWithInteger:kRepeatEveryWeek],
            [NSNumber numberWithInteger:kRepeatEveryMonth]
            ];
    }
    return values;
}

+ (NSArray *)names {
    static NSArray *names;
    if (!names) {
        NSMutableArray *array = [NSMutableArray new];
        for (int i = 0; i < [Repeat values].count; i++) {
            [array addObject:[Repeat getNameForValue:[[Repeat values][i] integerValue]]];
        }
        names = [NSArray arrayWithArray:array];
    }
    return names;
}

+ (NSString *)getNameForValue:(NSInteger)repeat {
    switch (repeat) {
        case 2:
            return @"Every week";
        case 4:
            return @"Every month";
        default:
            return @"Every day";
    }
}

+ (NSInteger)getValueAtIndex:(NSUInteger)index {
    return [[Repeat values][index] integerValue];
}

+ (NSUInteger)getIndexForValue:(NSInteger)repeat {
    for (int i = 0; i < [Repeat values].count; i++) {
        if (repeat == [[Repeat values][i] integerValue]) return i;
    }
    return 0;
}

+ (BOOL)isValidRepeat:(NSInteger)repeat {
    for (int i = 0; i < [Repeat values].count; i++) {
        if (repeat == [[Repeat values][i] integerValue]) return YES;
    }
    return NO;
}

@end