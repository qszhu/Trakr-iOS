//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface Target : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property(retain) NSString *name;
@property(retain) NSString *summary;
@property(retain) PFUser *creator;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;
@end