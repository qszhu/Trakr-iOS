//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

static NSString * const kDidLoginNotification = @"DidLoginNotification";

@interface LogInViewController : PFLogInViewController <PFLogInViewControllerDelegate>
@end