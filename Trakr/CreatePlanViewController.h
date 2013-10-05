//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Target;

@interface CreatePlanViewController : UITableViewController
@property (strong, nonatomic) Target *target;

@property (strong, nonatomic) IBOutlet UILabel *targetLabel;
@property (strong, nonatomic) IBOutlet UITextField *totalField;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;

@property (strong, nonatomic) IBOutlet UITextField *workloadField;
@property (strong, nonatomic) IBOutlet UILabel *repeatLabel;

- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@end