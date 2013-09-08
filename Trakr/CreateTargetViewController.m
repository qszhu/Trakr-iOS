//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "CreateTargetViewController.h"
#import "IUtils.h"
#import "Target.h"
#import "Plan.h"
#import "SVProgressHUD.h"
#import "Const.h"
#import "TestFlight.h"

@implementation CreateTargetViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Create Target";

    // tab to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    self.target = [[Target alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [TestFlight passCheckpoint:@"create target view appear"];
}

- (void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.summaryField resignFirstResponder];
}

- (IBAction)donePressed:(id)sender {
    [TestFlight passCheckpoint:@"done pressed"];

    self.target.name = self.nameField.text;
    self.target.summary = self.summaryField.text;

    [SVProgressHUD showWithStatus:@"Creating target..." maskType:SVProgressHUDMaskTypeGradient];
    [self.target saveWithTarget:self selector:@selector(saveTargetWithResult:error:)];
}

- (void)saveTargetWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot create target" error:error];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidCreateTargetNotification object:self];
    }];
}

- (IBAction)cancelPressed:(id)sender {
    [TestFlight passCheckpoint:@"cancel pressed"];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end