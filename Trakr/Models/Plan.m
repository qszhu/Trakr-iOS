//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/Parse.h>
#import "Plan.h"
#import "IUtils.h"
#import "Constants.h"
#import "Target.h"


@implementation Plan {

}

- (id)init {
    self = [super init];
    self.unit = [[Constants UNIT] objectForKey:[[[Constants UNIT] allKeys] objectAtIndex:0]];
    self.startDate = [[NSDate alloc] init];
    return self;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@" target: %@ ", self.target];
    [description appendFormat:@" total: %@ ", self.total];
    [description appendFormat:@" unit: %@ ", self.unit];
    [description appendFormat:@" name: %@ ", self.name];
    [description appendFormat:@" startDate: %@ ", self.startDate];
    [description appendFormat:@" tasks: %@ ", self.tasks];
    [description appendFormat:@" pfObject: %@ ", self.pfObject];
    [description appendString:@">"];
    return description;
}

+ (Plan *)fromPFObject:(PFObject *)object {
    Plan *thePlan = [[Plan alloc] init];
    thePlan.target = [object objectForKey:@"target"];
    thePlan.total = [object objectForKey:@"total"];
    thePlan.unit = [object objectForKey:@"unit"];
    thePlan.name = [object objectForKey:@"name"];
    thePlan.startDate = [object objectForKey:@"startDate"];
    thePlan.target = [object objectForKey:@"tasks"];
    thePlan.pfObject = object;
    return thePlan;
}

- (NSError *)getValidationError {
    // required fields
    if (self.target == nil) {
        return [IUtils errorWithCode:400 message:@"Target is required"];
    }
    if (self.total == nil || [self.total intValue] <= 0) {
        return [IUtils errorWithCode:400 message:@"Total must be positive"];
    }
    if (self.unit == nil) {
        return [IUtils errorWithCode:400 message:@"Invalid unit"];
    }

    // TODO: tasks
    return nil;
}

- (PFObject *)toPFObject {
    PFObject *obj = self.pfObject == nil ? [PFObject objectWithClassName:@"Plan"] : self.pfObject;
    [obj setObject:self.target.pfObject forKey:@"target"];
    [obj setObject:self.total forKey:@"total"];
    [obj setObject:self.unit forKey:@"unit"];
    // optional fields
    if (self.name == nil) {
        [obj setObject:self.target.name forKey:@"name"];
    }
    if (self.startDate == nil) {
        [obj setObject:[[NSDate alloc] init] forKey:@"startDate"];
    }
    return obj;
}

- (void)saveWithTarget:(id)target selector:(SEL)selector {
    self.pfObject = [self toPFObject];
    [self.pfObject saveInBackgroundWithTarget:target selector:selector];
}

@end