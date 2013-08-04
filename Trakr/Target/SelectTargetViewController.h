//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class CreatePlanViewController;

@interface SelectTargetViewController : PFQueryTableViewController
@property(strong, nonatomic) CreatePlanViewController *createPlanVC;
@end