//
//  TaskStatusType.m
//  Trakr
//
//  Created by Qinsi ZHU on 10/3/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "TaskGroup.h"

@implementation TaskStatus

+ (NSArray *)values {
    static NSArray *values;
    if (!values) {
        values = @[
            [NSNumber numberWithInteger:kTaskGroupLate],
            [NSNumber numberWithInteger:kTaskGroupToday],
            [NSNumber numberWithInteger:kTaskGroupTomorrow],
            [NSNumber numberWithInteger:kTaskGroupThisWeek],
            ];
    }
    return values;
}

+ (NSArray *)names {
    static NSArray *names;
    if (!names) {
        NSMutableArray *array = [NSMutableArray new];
        for (int i = 0; i < [TaskStatus values].count; i++) {
            [array addObject:[TaskStatus getNameForValue:[[TaskStatus values][i] integerValue]]];
        }
        names = [NSArray arrayWithArray:names];
    }
    return names;
}

+ (NSString *)getNameForValue:(NSInteger)taskStatus {
    switch (taskStatus) {
        case kTaskGroupLate:
            return @"Late";
        case kTaskGroupToday:
            return @"Today";
        case kTaskGroupTomorrow:
            return @"Tomorrow";
        case kTaskGroupThisWeek:
            return @"This week";
        default:
            return @"Future";
    }
}

@end
