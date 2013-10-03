//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Target;

@interface Plan : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property(retain) Target *target;
@property NSInteger total;
@property NSInteger unit;
@property(retain) NSDate *startDate;
@property(retain) PFUser *creator;
@property(retain) NSArray *tasks;

- (id)setDefaults;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;

- (NSInteger)getTaskSpan;

@end