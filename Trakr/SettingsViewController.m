//
//  SettingsViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 9/4/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "SettingsViewController.h"
#import "Setting.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (IBAction)showTimerSwitched:(id)sender {
    [Setting setTaskShouldShowTimer:[self.showTimerSwitch isOn]];
}

@end