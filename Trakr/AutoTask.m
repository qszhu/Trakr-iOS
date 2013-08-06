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
    if (self.taskCount <= 0) {
        return [IUtils errorWithCode:400 message:@"Number of tasks must be positive"];
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

    double step = plan.total / (double) self.taskCount;

    for (int i = 0; i < self.taskCount; i++) {
        Task *task = [[Task alloc] init];

        int start = (int) round(i * step + 1);
        int end = (int) round((i + 1) * step);
        task.offset = [self getNthOffset:i];
        task.step = end - start + 1;

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