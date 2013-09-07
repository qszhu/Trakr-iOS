//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Task.h"
#import "IUtils.h"

static NSString *const kOffsetKey = @"offset";
static NSString *const kStepKey = @"step";
static NSString *const kNameKey = @"name";

@interface Task ()
@property(strong, nonatomic) PFObject *parseObject;
@end

@implementation Task {

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

- (NSInteger)offset {
    return [[self.parseObject objectForKey:kOffsetKey] integerValue];
}

- (void)setOffset:(NSInteger)offset {
    [self.parseObject setObject:[NSNumber numberWithInteger:offset] forKey:kOffsetKey];
}

- (NSInteger)step {
    return [[self.parseObject objectForKey:kStepKey] integerValue];
}

- (void)setStep:(NSInteger)step {
    [self.parseObject setObject:[NSNumber numberWithInteger:step] forKey:kStepKey];
}

- (NSString *)name {
    return [self.parseObject objectForKey:kNameKey];
}

- (void)setName:(NSString *)name {
    [self.parseObject setObject:name forKey:kNameKey];
}

- (PFObject *)getParseObject {
    return self.parseObject;
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
        SuppressPerformSelectorLeakWarning(
        [target performSelector:selector withObject:[NSNumber numberWithBool:NO] withObject:error];
        );
        return;
    }
    [self.parseObject saveInBackgroundWithTarget:target selector:selector];
}

@end