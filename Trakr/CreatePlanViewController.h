//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

@class ProgressViewController;


@interface CreatePlanViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *targetLabel;
@property (strong, nonatomic) IBOutlet UITextField *totalField;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;

@property (strong, nonatomic) IBOutlet UITextField *workloadField;
@property (strong, nonatomic) IBOutlet UILabel *repeatLabel;

@property(strong, nonatomic) ProgressViewController *progressVC;

- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@end