//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "CreatePlanViewController.h"
#import "Constants.h"
#import "IUtils.h"
#import "SelectTargetViewController.h"
#import "Plan.h"
#import "Target.h"
#import "ProgressViewController.h"
#import "Progress.h"

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

    self.unitField.text = [Constants getUnitNameAtIndex:0];
    self.startDateField.text = [IUtils stringFromDate:self.plan.startDate];

//    self.repeatField.text = [[[Constants REPEAT] allKeys] objectAtIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Create Plan";

    self.textFields = [[NSArray alloc]
            initWithObjects:self.totalField, self.unitField, self.startDateField, self.numberOfTasksField, self.repeatField, nil];

    self.plan = [[Plan alloc] init];

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

//    UIPickerView *repeatPicker = [[UIPickerView alloc] init];
//    repeatPicker.dataSource = self;
//    repeatPicker.delegate = self;
//    repeatPicker.showsSelectionIndicator = YES;
//    self.repeatField.inputView = repeatPicker;
//    self.repeatField.text = [[[Constants REPEAT] allKeys] objectAtIndex:0];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    for (UITextField *field in self.textFields) {
        [field resignFirstResponder];
    }
}

- (void)selectTarget:(id)sender {
    SelectTargetViewController *selectTargetVC = [[SelectTargetViewController alloc] init];
    selectTargetVC.createPlanVC = self;
    [self.navigationController pushViewController:selectTargetVC animated:YES];
}

- (void)createPressed:(id)sender {
    self.plan.total = [NSNumber numberWithInt:[self.totalField.text intValue]];
    NSError *error = [self.plan getValidationError];
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Missing Information" error:error];
    } else {
        [self.plan saveWithTarget:self selector:@selector(savePlanWithResult:error:)];
    }
}

- (void)savePlanWithResult:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        Progress *progress = [[Progress alloc] init];
        progress.plan = self.plan;
        [progress saveWithTarget:self selector:@selector(saveProgressWithResult:error:)];
    } else {
        [IUtils showErrorDialogWithTitle:@"Cannot create plan" error:error];
    }
}

- (void)saveProgressWithResult:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        [self.navigationController popToViewController:self.progressVC animated:YES];
    } else {
        [IUtils showErrorDialogWithTitle:@"Cannot create progress" error:error];
    }
}

- (void)switchCreateTask:(id)sender {
    self.taskView.hidden = !self.createTaskSwitch.isOn;
}

- (void)startDateChanged:(UIDatePicker *)datePicker {
    self.plan.startDate = datePicker.date;
    self.startDateField.text = [IUtils stringFromDate:datePicker.date];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:self.unitField.inputView]) {
        return [Constants UNIT].count;
    }
    return 0;
//    return [Constants REPEAT].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:self.unitField.inputView]) {
        return [Constants getUnitNameAtIndex:row];
    }
    return nil;
//    return [[[Constants REPEAT] allKeys] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.unitField.inputView]) {
        NSString *unitName = [Constants getUnitNameAtIndex:row];
        self.unitField.text = unitName;
        self.plan.unit = [Constants getUnitForName:unitName];
    } else {
//        NSString *repeatName = [[[Constants REPEAT] allKeys] objectAtIndex:row];
//        self.repeatField.text = repeatName;
    }
}

@end