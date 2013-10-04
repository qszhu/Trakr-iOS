//
//  TaskViewController.h
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *taskGroupSegment;
@property (strong, nonatomic) IBOutlet UITableView *progressesTable;

- (IBAction)groupChanged:(id)sender;
@end