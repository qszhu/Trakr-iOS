//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CreatePlanViewController.h"

@class Target;

@interface CreateTargetViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *summaryField;

@property(strong, nonatomic) Target *target;
@property(strong, nonatomic) CreatePlanViewController *createPlanVC;

- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@end