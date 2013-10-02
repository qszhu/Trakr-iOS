//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/Parse.h>
#import "Plan.h"
#import "IUtils.h"
#import "Target.h"
#import "Unit.h"
#import "Task.h"

static NSString *const kTargetKey = @"target";
static NSString *const kTotalKey = @"total";
static NSString *const kUnitKey = @"unit";
static NSString *const kStartDateKey = @"startDate";
static NSString *const kCreatorKey = @"creator";
static NSString *const kTasksKey = @"tasks";

@interface Plan ()
@property(strong, nonatomic) PFObject *parseObject;
@end

@implementation Plan {
}

- (id)init {
    self = [self initWithParseObject:[PFObject objectWithClassName:NSStringFromClass([self class])]];
    self.unit = kUnitChapter;
    self.startDate = [NSDate date];
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
    return [self.parseObject objectForKey:kTargetKey];
}

- (void)setTarget:(Target *)target {
    [self.parseObject setObject:target forKey:kTargetKey];
}

- (NSInteger)total {
    return [[self.parseObject objectForKey:kTotalKey] integerValue];
}

- (void)setTotal:(NSInteger)total {
    [self.parseObject setObject:[NSNumber numberWithInteger:total] forKey:kTotalKey];
}

- (NSInteger)unit {
    return [[self.parseObject objectForKey:kUnitKey] integerValue];
}

- (void)setUnit:(NSInteger)unit {
    [self.parseObject setObject:[NSNumber numberWithInteger:unit] forKey:kUnitKey];
}

- (NSDate *)startDate {
    return [self.parseObject objectForKey:kStartDateKey];
}

- (void)setStartDate:(NSDate *)startDate {
    [self.parseObject setObject:startDate forKey:kStartDateKey];
}

- (NSArray *)tasks {
    NSArray *tasks = [self.parseObject objectForKey:kTasksKey];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (PFObject *object in tasks) {
        [array addObject:[[Task alloc] initWithParseObject:object]];
    }
    return [[NSArray alloc] initWithArray:array];
}

- (void)setTasks:(NSArray *)tasks {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Task *task in tasks) {
        [array addObject:[task getParseObject]];
    }
    [self.parseObject setObject:[[NSArray alloc] initWithArray:array] forKey:kTasksKey];
}

- (NSString *)creator {
    return [[self.parseObject objectForKey:kCreatorKey] username];
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
        self.startDate = [[NSDate alloc] init];
    }
    NSError *error = [self getValidationError];
    if (error) {
        [target performSelector:selector withObject:[NSNumber numberWithBool:NO] withObject:error];
        return;
    }
    [self.parseObject setObject:[PFUser currentUser] forKey:kCreatorKey];
    [self.parseObject saveInBackgroundWithTarget:target selector:selector];
}

@end