//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface Target : NSObject
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *summary;
@property(strong, nonatomic) NSString *creator;

- (id)initWithParseObject:(PFObject *)object;

- (PFObject *)getParseObject;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;
@end