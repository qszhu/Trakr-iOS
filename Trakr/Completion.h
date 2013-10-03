//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Task;

@interface Completion : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property(retain) NSDate *date;
@property NSInteger cost;
@property(retain) Task *task;
//@property NSInteger step;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;

@end