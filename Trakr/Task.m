//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/PFObject+Subclass.h>
#import "Task.h"
#import "IUtils.h"

@implementation Task {

}

@dynamic offset, step, name;

+ (NSString *)parseClassName {
    return NSStringFromClass([Task class]);
}

- (NSDate *)getDate:(NSDate *)startDate {
    return [IUtils dateByOffset:self.offset fromDate:startDate];
}

- (NSError *)getValidationError {
    if (self.step < 0) {
        return [IUtils errorWithCode:400 message:@"Task step cannot be negative"];
    }
    if (self.name == nil) {
        return [IUtils errorWithCode:400 message:@"Task name is required"];
    }
    return nil;
}

- (void)saveWithTarget:(id)target selector:(SEL)selector {
    NSError *error = [self getValidationError];
    if (error) {
        [target performSelector:selector withObject:[NSNumber numberWithBool:NO] withObject:error];
        return;
    }
    [self saveInBackgroundWithTarget:target selector:selector];
}

- (TaskType)taskType:(NSDate *)startDate {
    NSDate *taskDate = [self getDate:startDate];
    NSDate *today = [NSDate date];
    NSInteger dayDiff = [IUtils daysBetween:today and:taskDate];
    if (dayDiff < 0) return TaskTypeLate;
    if (dayDiff == 0) return TaskTypeToday;
    if (dayDiff == 1) return TaskTypeTomorrow;
    if (dayDiff < 7) return TaskTypeThisWeek;
    return TaskTypeFuture;
}

@end