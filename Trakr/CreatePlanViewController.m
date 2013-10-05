//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "CreatePlanViewController.h"
#import "IUtils.h"
#import "Plan.h"
#import "Target.h"
#import "Unit.h"
#import "Repeat.h"
#import "AutoTask.h"
#import "SVProgressHUD.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "Const.h"
#import "TestFlight.h"

@interface CreatePlanViewController ()
@property(strong, nonatomic) Plan *plan;
@property(strong, nonatomic) AutoTask *autoTask;
@end

@implementation CreatePlanViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.plan = [[Plan object] setDefaults];
    self.plan.target = self.target;
    self.autoTask = [AutoTask new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectTarget:) name:kDidSelectTargetNotification object:nil];

    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"Create Plan";

    [TestFlight passCheckpoint:@"create plan view appear"];
}

- (void)didSelectTarget:(NSNotification *)notification {
    self.plan.target = notification.object;
    [self refresh];
}

- (void)refresh {
    if (self.plan.target != nil) {
        [self.targetLabel setText:self.plan.target.name];
    }
    [self.unitLabel setText:[Unit getNameForValue:self.plan.unit]];
    [self.startDateLabel setText:[IUtils stringFromDate:self.plan.startDate]];
    [self.repeatLabel setText:[Repeat getNameForValue:self.autoTask.repeat]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    [self.totalField resignFirstResponder];
    [self.workloadField resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 2:
                [self pickUnit];
                return;
            case 3:
                [self pickStartDate];
                return;
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1:
                [self pickRepeat];
                return;
        }
    }
}

- (void)pickUnit {
    [TestFlight passCheckpoint:@"pick unit"];

    [ActionSheetStringPicker showPickerWithTitle:@"Select unit"
                                            rows:[Unit names]
                                initialSelection:[Unit getIndexForValue:self.plan.unit]
                                          target:self
                                   successAction:@selector(unitPicked:element:)
                                    cancelAction:nil
                                          origin:self.view];
}

- (void)unitPicked:(NSNumber *)selectedIndex element:(id)element {
    NSUInteger index = [selectedIndex unsignedIntegerValue];
    self.plan.unit = [Unit getValueAtIndex:index];
    [self refresh];
}

- (void)pickStartDate {
    [TestFlight passCheckpoint:@"pick start date"];

    [ActionSheetDatePicker showPickerWithTitle:@"Select start date"
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:self.plan.startDate
                                        target:self
                                        action:@selector(startDatePicked:element:)
                                        origin:self.view];
}

- (void)startDatePicked:(NSDate *)date element:(id)element {
    self.plan.startDate = date;
    [self refresh];
}

- (void)pickRepeat {
    [TestFlight passCheckpoint:@"pick repeat"];

    [ActionSheetStringPicker showPickerWithTitle:@"Select repeat mode"
                                            rows:[Repeat names]
                                initialSelection:[Repeat getIndexForValue:self.autoTask.repeat]
                                          target:self
                                   successAction:@selector(repeatPicked:element:)
                                    cancelAction:nil
                                          origin:self.view];
}

- (void)repeatPicked:(NSNumber *)selectedIndex element:(id)element {
    NSUInteger index = [selectedIndex unsignedIntegerValue];
    self.autoTask.repeat = [Repeat getValueAtIndex:index];
    [self refresh];
}

- (IBAction)donePressed:(id)sender {
    [TestFlight passCheckpoint:@"done pressed"];

    self.plan.total = [self.totalField.text integerValue];
    self.autoTask.workload = [self.workloadField.text integerValue];
    NSError *error = [self.autoTask getValidationError];
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Missing Information" error:error];
        return;
    }

    [SVProgressHUD showWithStatus:@"Creating plan..." maskType:SVProgressHUDMaskTypeGradient];
    [self.autoTask createTasksForPlan:self.plan];
    [self.plan saveWithTarget:self selector:@selector(savePlanWithResult:error:)];
}

- (void)savePlanWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot create plan" error:error];
        return;
    }

    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidCreatePlanNotification object:self.plan];
    }];
}

- (IBAction)cancelPressed:(id)sender {
    [TestFlight passCheckpoint:@"cancel pressed"];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end