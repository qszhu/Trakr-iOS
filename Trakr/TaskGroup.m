//
//  TaskStatusType.m
//  Trakr
//
//  Created by Qinsi ZHU on 10/3/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "TaskGroup.h"

@implementation TaskGroup

+ (NSArray *)values {
    static NSArray *values;
    if (!values) {
        values = @[
            [NSNumber numberWithInteger:kTaskGroupLate],
            [NSNumber numberWithInteger:kTaskGroupToday],
            [NSNumber numberWithInteger:kTaskGroupTomorrow],
            [NSNumber numberWithInteger:kTaskGroupThisWeek],
            [NSNumber numberWithInteger:kTaskGroupFuture],
            [NSNumber numberWithInteger:kTaskGroupAll]
            ];
    }
    return values;
}

+ (NSArray *)names {
    static NSArray *names;
    if (!names) {
        NSMutableArray *array = [NSMutableArray new];
        for (int i = 0; i < [TaskGroup values].count; i++) {
            [array addObject:[TaskGroup getNameForValue:[[TaskGroup values][i] integerValue]]];
        }
        names = [NSArray arrayWithArray:names];
    }
    return names;
}

+ (NSString *)getNameForValue:(NSInteger)taskGroup {
    switch (taskGroup) {
        case kTaskGroupLate:
            return @"Late";
        case kTaskGroupToday:
            return @"Today";
        case kTaskGroupTomorrow:
            return @"Tomorrow";
        case kTaskGroupThisWeek:
            return @"This week";
        case kTaskGroupFuture:
            return @"Future";
        default:
            return @"All";
    }
}

+ (NSInteger)getValueAtIndex:(NSUInteger)index {
    return [[TaskGroup values][index] integerValue];
}

@end
