//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "CreateTargetViewController.h"
#import "IUtils.h"
#import "Target.h"
#import "Plan.h"
#import "SVProgressHUD.h"

@implementation CreateTargetViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Create Target";

    // border around text view
    [self.descriptionText.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [self.descriptionText.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.descriptionText.layer setBorderWidth:1.0];
    [self.descriptionText.layer setCornerRadius:8.0f];
    [self.descriptionText.layer setMasksToBounds:YES];

    // tab to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    self.target = [[Target alloc] init];
}

- (void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.descriptionText resignFirstResponder];
}

- (void)createPressed:(id)sender {
    self.target.name = self.nameField.text;
    self.target.summary = self.descriptionText.text;
    [SVProgressHUD showWithStatus:@"Creating target..." maskType:SVProgressHUDMaskTypeGradient];
    [self.target saveWithTarget:self selector:@selector(saveTargetWithResult:error:)];
}

- (void)saveTargetWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if ([result boolValue]) {
        self.createPlanVC.plan.target = self.target;
        [self.navigationController popToViewController:self.createPlanVC animated:YES];
    } else {
        [IUtils showErrorDialogWithTitle:@"Cannot create target" error:error];
    }
}

@end