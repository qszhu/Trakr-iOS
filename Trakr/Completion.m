//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Completion.h"
#import "IUtils.h"
#import "Task.h"


static NSString *const kDateKey = @"date";
static NSString *const kCostKey = @"cost";
static NSString *const kTaskKey = @"task";

@interface Completion ()
@property(strong, nonatomic) PFObject *parseObject;
@end

@implementation Completion {

}

- (id)init {
    self = [self initWithParseObject:[PFObject objectWithClassName:NSStringFromClass([self class])]];
    return self;
}

- (id)initWithParseObject:(PFObject *)object {
    self = [super init];
    if (self) {
        self.parseObject = object;
    }
    return self;
}

- (NSDate *)date {
    return [self.parseObject objectForKey:kDateKey];
}

- (void)setDate:(NSDate *)date {
    [self.parseObject setObject:date forKey:kDateKey];
}

- (NSInteger)cost {
    return [[self.parseObject objectForKey:kCostKey] integerValue];
}

- (void)setCost:(NSInteger)cost {
    [self.parseObject setObject:[NSNumber numberWithInteger:cost] forKey:kCostKey];
}

- (Task *)task {
    return [[Task alloc] initWithParseObject:[self.parseObject objectForKey:kTaskKey]];
}

- (void)setTask:(Task *)task {
    [self.parseObject setObject:task.getParseObject forKey:kTaskKey];
}

- (PFObject *)getParseObject {
    return self.parseObject;
}

- (NSError *)getValidationError {
    if (self.date == nil) {
        return [IUtils errorWithCode:400 message:@"Completion date is required"];
    }
    return nil;
}

- (void)saveWithTarget:(id)target selector:(SEL)selector {
    if (self.date == nil) {
        self.date = [[NSDate alloc] init];
    }
    NSError *error = [self getValidationError];
    if (error) {
        [target performSelector:selector withObject:[NSNumber numberWithBool:NO] withObject:error];
        return;
    }
    [self.parseObject saveInBackgroundWithTarget:target selector:selector];
}

@end