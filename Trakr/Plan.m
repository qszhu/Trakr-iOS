//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/PFObject+Subclass.h>
#import "Plan.h"
#import "Target.h"
#import "IUtils.h"
#import "Task.h"
#import "Unit.h"

@implementation Plan {
}

@dynamic target, total, unit, startDate, creator, tasks;

+ (NSString *)parseClassName {
    return NSStringFromClass([Plan class]);
}

- (id)setDefaults {
    self.unit = kUnitChapter;
    self.startDate = [NSDate date];
    return self;
}

- (NSString *)getName {
    return self.target.name;
}

- (NSError *)getValidationError {
    // required fields
    if (self.target == nil) {
        return [IUtils errorWithCode:400 message:@"Target is required"];
    }
    if (self.total <= 0) {
        return [IUtils errorWithCode:400 message:@"Total must be positive"];
    }
    if (![Unit isValidUnit:self.unit]) {
        return [IUtils errorWithCode:400 message:@"Invalid unit"];
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

- (NSInteger)getTaskSpan {
    NSInteger maxOffset = 0;
    for (Task *task in self.tasks) {
        if (maxOffset < task.offset) {
            maxOffset = task.offset;
        }
    }
    return maxOffset + 1;
}

@end