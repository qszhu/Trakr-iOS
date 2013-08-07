//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Plan;

typedef enum _TaskType : NSUInteger {
    TaskTypeLate,
    TaskTypeToday,
    TaskTypeTomorrow,
    TaskTypeFuture
} TaskType;

@interface Progress : NSObject
@property(strong, nonatomic) Plan *plan;
@property(strong, nonatomic) NSDate *startDate;
@property(strong, nonatomic) NSArray *completions;
@property(strong, nonatomic, readonly) NSString *creator;

- (id)initWithParseObject:(PFObject *)object;

- (PFObject *)getParseObject;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;

- (NSArray *)getTasksForType:(TaskType)taskType;

@end