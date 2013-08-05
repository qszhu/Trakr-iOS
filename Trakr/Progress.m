//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Progress.h"
#import "Plan.h"
#import "IUtils.h"

static NSString *const kPlanKey = @"plan";
static NSString *const kStartDateKey = @"startDate";
static NSString *const kCreatorKey = @"creator";

@interface Progress ()
@property(strong, nonatomic) PFObject *parseObject;
@end

@implementation Progress {

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

- (PFObject *)getParseObject {
    return self.parseObject;
}

- (Plan *)plan {
    PFObject *plan = [self.parseObject objectForKey:kPlanKey];
    if (plan != nil) {
        return [[Plan alloc] initWithParseObject:plan];
    }
    return nil;
}

- (void)setPlan:(Plan *)plan {
    [self.parseObject setObject:[plan getParseObject] forKey:kPlanKey];
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
    if (self.plan == nil) {
        return [IUtils errorWithCode:400 message:@"Plan is required"];
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