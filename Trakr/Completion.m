//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/PFObject+Subclass.h>
#import "Completion.h"
#import "IUtils.h"


@implementation Completion {

}

@dynamic date, cost, task;

+ (NSString *)parseClassName {
    return NSStringFromClass([Completion class]);
}

- (NSError *)getValidationError {
    if (self.date == nil) {
        return [IUtils errorWithCode:400 message:@"Completion date is required"];
    }
    return nil;
}

- (void)saveWithTarget:(id)target selector:(SEL)selector {
    if (self.date == nil) {
        self.date = [NSDate date];
    }
    NSError *error = [self getValidationError];
    if (error) {
        [target performSelector:selector withObject:[NSNumber numberWithBool:NO] withObject:error];
        return;
    }
    [self saveInBackgroundWithTarget:target selector:selector];
}

@end