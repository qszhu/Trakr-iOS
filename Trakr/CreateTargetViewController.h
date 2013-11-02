//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CreateTargetViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *summaryField;

- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)scanPressed:(id)sender;
@end