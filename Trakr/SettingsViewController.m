//
//  SettingsViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 9/4/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "SettingsViewController.h"
#import "Setting.h"
#import "TestFlight.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"Settings"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"settings view appear"];

    [self.showTimerSwitch setOn:[Setting taskShouldShowTimer]];
}

- (IBAction)showTimerSwitched:(id)sender {
    [TestFlight passCheckpoint:@"settings timer switched"];

    [Setting setTaskShouldShowTimer:[self.showTimerSwitch isOn]];
}

@end