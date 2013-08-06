//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Progress.h"
#import "Plan.h"
#import "IUtils.h"
#import "Completion.h"

static NSString *const kPlanKey = @"plan";
static NSString *const kStartDateKey = @"startDate";
static NSString *const kCompletionsKey = @"completions";
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

- (NSArray *)completions {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (PFObject *object in [self.parseObject objectForKey:kCompletionsKey]) {
        [array addObject:[[Completion alloc] initWithParseObject:object]];
    }
    return [[NSArray alloc] initWithArray:array];
}

- (void)setCompletions:(NSArray *)completions {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Completion *completion in completions) {
        [array addObject:[completion getParseObject]];
    }
    [self.parseObject setObject:[[NSArray alloc] initWithArray:array] forKey:kCompletionsKey];
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
    NSError *error = [self getValidationError];
    if (error) {
        SuppressPerformSelectorLeakWarning(
        [target performSelector:selector withObject:[NSNumber numberWithBool:NO] withObject:error];
        );
        return;
    }
    [self.parseObject setObject:[PFUser currentUser] forKey:kCreatorKey];
    [self.parseObject saveInBackgroundWithTarget:target selector:selector];
}

@end