//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/PFObject+Subclass.h>
#import "Target.h"
#import "IUtils.h"

@implementation Target {
}

@dynamic name;
@dynamic summary;
@dynamic creator;

+ (NSString *)parseClassName {
    return NSStringFromClass([Target class]);
}

- (NSError *)getValidationError {
    self.name = [IUtils trim:self.name];
    if (self.name.length == 0) {
        return [IUtils errorWithCode:400 message:@"Target name is required"];
    }
    return nil;
}

- (void)saveWithTarget:(id)target selector:(SEL)selector {
    NSError *error = [self getValidationError];
    if (error) {
        [target performSelector:selector withObject:[NSNumber numberWithBool:NO] withObject:error];
        return;
    }
    self.creator = [PFUser currentUser];
    [self saveInBackgroundWithTarget:target selector:selector];
}

@end