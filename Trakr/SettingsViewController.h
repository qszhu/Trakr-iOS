//
//  SettingsViewController.h
//  Trakr
//
//  Created by Qinsi ZHU on 9/4/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UISwitch *showTimerSwitch;

- (IBAction)showTimerSwitched:(id)sender;
@end
