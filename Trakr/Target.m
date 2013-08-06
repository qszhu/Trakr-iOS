//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/Parse.h>
#import "Target.h"
#import "IUtils.h"

static NSString *const kNameKey = @"name";
static NSString *const kSummaryKey = @"summary";
static NSString *const kCreatorKey = @"creator";

@interface Target ()
@property(strong, nonatomic) PFObject *parseObject;
@end

@implementation Target {
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

- (NSString *)name {
    return [self.parseObject objectForKey:kNameKey];
}

- (void)setName:(NSString *)name {
    [self.parseObject setObject:name forKey:kNameKey];
}

- (NSString *)summary {
    return [self.parseObject objectForKey:kSummaryKey];
}

- (void)setSummary:(NSString *)summary {
    [self.parseObject setObject:summary forKey:kSummaryKey];
}

- (NSString *)creator {
    return [[self.parseObject objectForKey:kCreatorKey] username];
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
        SuppressPerformSelectorLeakWarning(
        [target performSelector:selector withObject:[NSNumber numberWithBool:NO] withObject:error];
        );
        return;
    }
    [self.parseObject setObject:[PFUser currentUser] forKey:kCreatorKey];
    [self.parseObject saveInBackgroundWithTarget:target selector:selector];
}

@end