//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "CreatePlanViewController.h"
#import "IUtils.h"
#import "SelectTargetViewController.h"
#import "Plan.h"
#import "Target.h"
#import "ProgressViewController.h"
#import "Progress.h"
#import "Unit.h"
#import "Repeat.h"
#import "AutoTask.h"
#import "SVProgressHUD.h"
#import "TestFlight.h"

@interface CreatePlanViewController ()
@property(strong, nonatomic) NSArray *textFields;
@end

@implementation CreatePlanViewController {
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.plan.target != nil) {
        [self.targetButton setTitle:self.plan.target.name forState:UIControlStateNormal];
    }

    self.unitField.text = [Unit getNameForValue:self.plan.unit];
    self.startDateField.text = [IUtils stringFromDate:self.plan.startDate];

    self.repeatField.text = [Repeat getNameForValue:self.autoTask.repeat];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Create Plan";

    self.textFields = [[NSArray alloc]
            initWithObjects:self.totalField, self.unitField, self.startDateField, self.numberOfTasksField, self.repeatField, nil];

    self.plan = [[Plan alloc] init];
    self.autoTask = [[AutoTask alloc] init];

    UIPickerView *unitPicker = [[UIPickerView alloc] init];
    unitPicker.dataSource = self;
    unitPicker.delegate = self;
    unitPicker.showsSelectionIndicator = YES;
    self.unitField.inputView = unitPicker;

    UIDatePicker *startDatePicker = [[UIDatePicker alloc] init];
    [startDatePicker addTarget:self
                        action:@selector(startDateChanged:)
              forControlEvents:UIControlEventValueChanged];
    startDatePicker.datePickerMode = UIDatePickerModeDate;
    self.startDateField.inputView = startDatePicker;

    UIPickerView *repeatPicker = [[UIPickerView alloc] init];
    repeatPicker.dataSource = self;
    repeatPicker.delegate = self;
    repeatPicker.showsSelectionIndicator = YES;
    self.repeatField.inputView = repeatPicker;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"create plan view appear"];
}

- (void)dismissKeyboard {
    for (UITextField *field in self.textFields) {
        [field resignFirstResponder];
    }
}

- (void)selectTarget:(id)sender {
    [TestFlight passCheckpoint:@"select target pressed"];

    SelectTargetViewController *selectTargetVC = [[SelectTargetViewController alloc] init];
    selectTargetVC.createPlanVC = self;
    [self.navigationController pushViewController:selectTargetVC animated:YES];
}

- (void)createPressed:(id)sender {
    [TestFlight passCheckpoint:@"create pressed"];

    self.plan.total = [self.totalField.text intValue];
    if ([self.createTaskSwitch isOn]) {
        self.autoTask.taskCount = [self.numberOfTasksField.text integerValue];
        NSError *error = [self.autoTask getValidationError];
        if (error) {
            [IUtils showErrorDialogWithTitle:@"Missing Information" error:error];
            return;
        }
        [self.autoTask createTasksForPlan:self.plan];
    }
    [SVProgressHUD showWithStatus:@"Creating plan..." maskType:SVProgressHUDMaskTypeGradient];
    [self.plan saveWithTarget:self selector:@selector(savePlanWithResult:error:)];
}

- (void)savePlanWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot create plan" error:error];
        return;
    }
    Progress *progress = [[Progress alloc] init];
    progress.plan = self.plan;
    [SVProgressHUD showWithStatus:@"Creating progress..." maskType:SVProgressHUDMaskTypeGradient];
    [progress saveWithTarget:self selector:@selector(saveProgressWithResult:error:)];
}

- (void)saveProgressWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot create progress" error:error];
        return;
    }
    [self.navigationController popToViewController:self.progressVC animated:YES];
    [self.progressVC loadObjects];
}

- (void)switchCreateTask:(id)sender {
    [TestFlight passCheckpoint:@"switch create task"];

    self.taskView.hidden = !self.createTaskSwitch.isOn;
}

- (void)startDateChanged:(UIDatePicker *)datePicker {
    [TestFlight passCheckpoint:@"picked start date"];

    self.plan.startDate = datePicker.date;
    self.startDateField.text = [IUtils stringFromDate:datePicker.date];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:self.unitField.inputView]) {
        return [Unit count];
    }
    return [Repeat count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:self.unitField.inputView]) {
        return [Unit getNameAtIndex:(NSUInteger) row];
    }
    return [Repeat getNameAtIndex:(NSUInteger) row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.unitField.inputView]) {
        [TestFlight passCheckpoint:@"picked unit"];

        NSString *unitName = [Unit getNameAtIndex:(NSUInteger) row];
        self.unitField.text = unitName;
        self.plan.unit = [Unit getValueForName:unitName];
    } else {
        [TestFlight passCheckpoint:@"picked repeat"];

        NSString *repeatName = [Repeat getNameAtIndex:(NSUInteger) row];
        self.repeatField.text = repeatName;
        self.autoTask.repeat = [Repeat getValueForName:repeatName];
    }
}

@end