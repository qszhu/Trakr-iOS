//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Unit.h"

@implementation Unit {

}

+ (NSArray *)values {
    static NSArray *values;
    if (!values) {
        values = @[[NSNumber numberWithInteger:kUnitChapter], [NSNumber numberWithInteger:kUnitPage]];
    }
    return values;
}

+ (NSArray *)names {
    static NSArray *names;
    if (!names) {
        NSMutableArray *array = [NSMutableArray new];
        for (int i = 0; i < [Unit values].count; i++) {
            [array addObject:[Unit getNameForValue:[[Unit values][i] integerValue]]];
        }
        names = [NSArray arrayWithArray:names];
    }
    return names;
}

+ (NSString *)getNameForValue:(NSInteger)unit {
    switch (unit) {
        case kUnitPage:
            return @"Page";
        default:
            return @"Chapter";
    }
}

+ (NSInteger)getValueAtIndex:(NSUInteger)index {
    return [[Unit values][index] integerValue];
}

+ (NSUInteger)getIndexForValue:(NSInteger)unit {
    for (int i = 0; i < [Unit values].count; i++) {
        if (unit == [[Unit values][i] integerValue]) return i;
    }
    return 0;
}

+ (BOOL)isValidUnit:(NSInteger)unit {
    for (int i = 0; i < [Unit values].count; i++) {
        if (unit == [[Unit values][i] integerValue]) return YES;
    }
    return NO;
}

@end