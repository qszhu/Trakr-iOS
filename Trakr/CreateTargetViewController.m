//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "CreateTargetViewController.h"
#import "IUtils.h"
#import "Target.h"
#import "SVProgressHUD.h"
#import "Const.h"
#import "TestFlight.h"

@interface CreateTargetViewController()
@property(strong, nonatomic) Target *target;
@end

@implementation CreateTargetViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.target = [Target object];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [TestFlight passCheckpoint:@"create target view appear"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
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
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidCreateTargetNotification object:self.target];
}

- (IBAction)cancelPressed:(id)sender {
    [TestFlight passCheckpoint:@"cancel pressed"];

    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end