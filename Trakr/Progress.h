//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Task.h"

@class Plan;

@interface Progress : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property(retain) Plan *plan;
@property(retain) NSDate *startDate;
@property(retain) NSArray *completions;
@property(retain) PFUser *creator;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;

- (NSArray *)getTasksForType:(TaskType)taskType;

@end