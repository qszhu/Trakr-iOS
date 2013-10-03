//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Progress.h"
#import "Plan.h"
#import "IUtils.h"

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

- (NSArray *)getTasksForType:(TaskType)taskType {
    NSMutableArray *array = [NSMutableArray new];
    for (Task *task in self.plan.tasks) {
        if ([task taskType:self.startDate] == taskType) {
            [array addObject:task];
        }
    }
    return [[NSArray alloc] initWithArray:array];
}

@end