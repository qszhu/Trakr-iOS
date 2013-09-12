//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "AutoTask.h"
#import "Repeat.h"
#import "IUtils.h"
#import "Plan.h"
#import "Task.h"
#import "Unit.h"


@implementation AutoTask {

}

- (id)init {
    self = [super init];
    if (self) {
        self.repeat = [Repeat getValueForName:kRepeatEveryDay];
    }

    return self;
}

- (NSError *)getValidationError {
    if (self.workload <= 0) {
        return [IUtils errorWithCode:400 message:@"Workload must be positive"];
    }
    if (self.repeat == nil) {
        return [IUtils errorWithCode:400 message:@"Repeat interval is required"];
    }

    return nil;
}

- (NSInteger)getNthOffset:(int)offset {
    if ([[Repeat getValueForName:kRepeatEveryWeek] isEqualToNumber:self.repeat]) {
        return offset * 7;
    }
    if ([[Repeat getValueForName:kRepeatEveryMonth] isEqualToNumber:self.repeat]) {
        return offset * 30;
    }
    return offset;
}

- (void)createTasksForPlan:(Plan *)plan {
    NSMutableArray *array = [[NSMutableArray alloc] init];

    int step = self.workload;
    for (int count = 0, i = 0; count < plan.total; count += step, i++) {
        Task *task = [[Task alloc] init];

        int start = count + 1;
        int end = MIN(count + step, plan.total);
        task.offset = [self getNthOffset:i];
        task.step = step;

        NSString *unit = [Unit getNameForValue:plan.unit];
        if (start == end) {
            task.name = [NSString stringWithFormat:@"%@ %d", unit, start];
        } else {
            task.name = [NSString stringWithFormat:@"%@ %d - %@ %d", unit, start, unit, end];
        }

        [array addObject:task];
    }

    plan.tasks = [[NSArray alloc] initWithArray:array];
}

@end