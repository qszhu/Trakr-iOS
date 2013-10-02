//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Task : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property NSInteger offset;
@property NSInteger step;
@property(retain) NSString *name;
//@property(retain) NSDate *deadline;

- (NSDate *)getDate:(NSDate *)startDate;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;

@end