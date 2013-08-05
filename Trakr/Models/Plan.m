//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/Parse.h>
#import "Plan.h"
#import "IUtils.h"
#import "Constants.h"
#import "Target.h"

static NSString *const kTargetKey = @"target";
static NSString *const kTotalKey = @"total";
static NSString *const kUnitKey = @"unit";
static NSString *const kStartDateKey = @"startDate";
static NSString *const kCreatorKey = @"creator";
//static NSString * const kTasksKey = @"tasks";

@interface Plan ()
@property(strong, nonatomic) PFObject *parseObject;
@end

@implementation Plan {
}

- (id)init {
    self = [self initWithParseObject:[PFObject objectWithClassName:NSStringFromClass([self class])]];
    self.unit = [Constants getUnitForName:[Constants getUnitNameAtIndex:0]];
    self.startDate = [[NSDate alloc] init];
    return self;
}

- (id)initWithParseObject:(PFObject *)object {
    self = [super init];
    if (self) {
        self.parseObject = object;
    }
    return self;
}

- (PFObject *)getParseObject {
    return self.parseObject;
}

- (Target *)target {
    PFObject *target = [self.parseObject objectForKey:kTargetKey];
    if (target != nil) {
        return [[Target alloc] initWithParseObject:target];
    }
    return nil;
}

- (void)setTarget:(Target *)target {
    [self.parseObject setObject:[target getParseObject] forKey:kTargetKey];
}

- (NSNumber *)total {
    return [self.parseObject objectForKey:kTotalKey];
}

- (void)setTotal:(NSNumber *)total {
    [self.parseObject setObject:total forKey:kTotalKey];
}

- (NSNumber *)unit {
    return [self.parseObject objectForKey:kUnitKey];
}

- (void)setUnit:(NSNumber *)unit {
    [self.parseObject setObject:unit forKey:kUnitKey];
}

- (NSDate *)startDate {
    return [self.parseObject objectForKey:kStartDateKey];
}

- (void)setStartDate:(NSDate *)startDate {
    [self.parseObject setObject:startDate forKey:kStartDateKey];
}

- (NSString *)creator {
    return [[self.parseObject objectForKey:kCreatorKey] username];
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

    return nil;
}

- (void)saveWithTarget:(id)target selector:(SEL)selector {
    if (self.startDate == nil) {
        self.startDate = [[NSDate alloc] init];
    }
    [self.parseObject setObject:[PFUser currentUser] forKey:kCreatorKey];
    [self.parseObject saveInBackgroundWithTarget:target selector:selector];
}

@end