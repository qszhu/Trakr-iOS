//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Progress.h"
#import "Plan.h"
#import "Completion.h"
#import "TaskGroup.h"
#import "IUtils.h"
#import "TTTTimeIntervalFormatter.h"

@implementation Progress {

}

@dynamic plan, startDate, completions, creator;

+ (NSString *)parseClassName {
    return NSStringFromClass([Progress class]);
}

- (NSError *)getValidationError {
    // required fields
    if (self.plan == nil) {
        return [IUtils errorWithCode:400 message:@"Plan is required"];
    }

    return nil;
}

- (void)saveWithTarget:(id)target selector:(SEL)selector {
    if (self.startDate == nil) {
        self.startDate = [NSDate date];
    }
    NSError *error = [self getValidationError];
    if (error) {
        [target performSelector:selector withObject:[NSNumber numberWithBool:NO] withObject:error];
        return;
    }
    self.creator = [PFUser currentUser];
    [self saveInBackgroundWithTarget:target selector:selector];
}

- (NSString *)getName {
    return [self.plan getName];
}

- (NSArray *)getTasksInGroup:(NSInteger)taskGroup {
    NSMutableArray *array = [NSMutableArray new];
    for (Task *task in self.plan.tasks) {
        if (taskGroup == kTaskGroupAll || [task taskGroup:self.startDate] == taskGroup) {
            [array addObject:task];
        }
    }
    return [[NSArray alloc] initWithArray:array];
}

- (NSDate *)getFinishDate {
    return [IUtils dateByOffset:[self.plan getTaskSpan] fromDate:self.startDate];
}

- (void)completeTask:(Task *)task withCost:(NSInteger)cost {
    Completion *completion = [Completion object];
    completion.task = task;
    completion.cost = cost;
    completion.date = [NSDate date];
    if (!self.completions) {
        self.completions = [NSArray new];
    }
    self.completions = [self.completions arrayByAddingObject:completion];
}

- (void)uncompleteTask:(Task *)task {
    if (!self.completions) {
        self.completions = [NSArray new];
    }
    NSMutableArray *array = [NSMutableArray new];
    for (Completion *completion in self.completions) {
        if (![completion.task.objectId isEqualToString:task.objectId]) {
            [array addObject:completion];
        }
    }
    self.completions = [NSArray arrayWithArray:array];
}

- (NSInteger)getNumberOfTasks {
    return self.plan.tasks.count;
}

- (NSInteger)getNumberOfCompletedTasks {
    return self.completions.count;
}

- (Task *)getFirstImcompleteTask {
    NSMutableSet *set = [NSMutableSet new];
    for (Completion *completion in self.completions) {
        [set addObject:completion.task.objectId];
    }
    NSInteger minOffset = NSIntegerMax;
    Task *firstTask = nil;
    for (Task *task in self.plan.tasks) {
        if (![set containsObject:task.objectId] && minOffset > task.offset) {
            minOffset = task.offset;
            firstTask = task;
        }
    }
    return firstTask;
}

- (NSInteger)getLateDays {
    Task *task = [self getFirstImcompleteTask];
    if (task == nil) {
        return 0;
    }
    NSDate *date = [task getDate:self.startDate];
    return [IUtils daysBetween:date and:[NSDate date]];
}

+ (NSString *)formatFinishDate:(Progress *)progress {
    NSDate *finishDate = [progress getFinishDate];
    NSTimeInterval interval = [finishDate timeIntervalSinceDate:[NSDate date]];
    NSString *str = [IUtils relativeDate:finishDate];
    if (interval <= 0) {
        return [NSString stringWithFormat:@"finished %@", str];
    }
    return [NSString stringWithFormat:@"finishes in %@", str];
}

+ (NSString *)formatLateDays:(Progress *)progress {
    NSInteger lateDays = [progress getLateDays];
    if (lateDays <= 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%d days late", lateDays];
}

- (NSString *)getProgressStatusString {
    NSString *lateStr = [Progress formatLateDays:self];
    if ([lateStr isEqualToString:@""]) {
        return [Progress formatFinishDate:self];
    }
    return lateStr;
}

- (NSInteger)getTaskLateDays:(Task *)task {
    NSDate *taskDate = [task getDate:self.startDate];
    return [IUtils daysBetween:taskDate and:[NSDate date]];
}

- (NSString *)getTaskStatusString:(Task *)task {
    for (Completion *completion in self.completions) {
        if ([[completion.task objectId] isEqualToString:[task objectId]]) {
            return [NSString stringWithFormat:@"completed %@", [IUtils relativeDate:completion.date]];
        }
    }
    NSInteger lateDays = [self getTaskLateDays:task];
    if (lateDays > 0) {
        return [NSString stringWithFormat:@"%d days late", lateDays];
    }
    return @"";
}

- (BOOL)isTaskCompleted:(Task *)task {
    for (Completion *completion in self.completions) {
        if ([completion.task.objectId isEqualToString:task.objectId]) {
            return YES;
        }
    }
    return NO;
}

@end