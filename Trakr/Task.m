//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/PFObject+Subclass.h>
#import "Task.h"
#import "IUtils.h"

@implementation Task {

}

@dynamic offset;
@dynamic step;
@dynamic name;

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

@end