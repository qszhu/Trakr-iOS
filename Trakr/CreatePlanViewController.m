//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "CreatePlanViewController.h"
#import "Constants.h"
#import "IUtils.h"

@interface CreatePlanViewController ()
@property(strong, nonatomic) NSArray *textFields;
@end

@implementation CreatePlanViewController {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.title = @"Create a Plan";
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textFields = [[NSArray alloc]
            initWithObjects:self.totalField, self.unitField, self.nameField, self.startDateField, self.repeatField, nil];

    self.scrollView.delegate = self;

    UIPickerView *unitPicker = [[UIPickerView alloc] init];
    unitPicker.dataSource = self;
    unitPicker.delegate = self;
    unitPicker.showsSelectionIndicator = YES;
    self.unitField.inputView = unitPicker;
    self.unitField.text = [Constants UNITS][0];

    UIDatePicker *startDatePicker = [[UIDatePicker alloc] init];
    [startDatePicker addTarget:self
                        action:@selector(startDateChanged:)
              forControlEvents:UIControlEventValueChanged];
    startDatePicker.datePickerMode = UIDatePickerModeDate;
    self.startDateField.inputView = startDatePicker;
    self.startDate = [[NSDate alloc] init];
    self.startDateField.text = [IUtils stringFromDate:self.startDate];

    [self updateOnceLabel];

    UIPickerView *repeatPicker = [[UIPickerView alloc] init];
    repeatPicker.dataSource = self;
    repeatPicker.delegate = self;
    repeatPicker.showsSelectionIndicator = YES;
    self.repeatField.inputView = repeatPicker;
    self.repeatField.text = [Constants REPEAT][0];
}

- (void)selectTarget:(id)sender {
    UIViewController *selectTargetVC = [[UIViewController alloc] init];
    [self presentViewController:selectTargetVC animated:YES completion:nil];
}

- (NSError *)getValidationError {
    if (!self.target) {
        return [IUtils errorWithCode:400 message:@"Plan must have a target"];
    }
    // TODO: more validations
    return nil;
}

- (void)createPressed:(id)sender {
    NSError *error = [self getValidationError];
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Missing Information" error:error];
    } else {

    }
}

- (void)onceChanged:(id)sender {
    [self updateOnceLabel];
}

- (void)updateOnceLabel {
    self.onceLabel.text = [NSString stringWithFormat:@"%d %@", (int) self.onceStepper.value, self.unitField.text];
}

- (void)totalChanged:(id)sender {
    self.onceStepper.maximumValue = self.totalField.text.intValue;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    for (UITextField *textField in self.textFields) {
        [textField resignFirstResponder];
    }
}

- (void)switchCreateTask:(id)sender {
    self.taskView.hidden = !self.createTaskSwitch.isOn;
}

- (void)startDateChanged:(UIDatePicker *)datePicker {
    self.startDate = datePicker.date;
    self.startDateField.text = [IUtils stringFromDate:self.startDate];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:self.unitField.inputView]) {
        return [Constants UNITS].count;
    }
    return [Constants REPEAT].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:self.unitField.inputView]) {
        return [Constants UNITS][row];
    }
    return [Constants REPEAT][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.unitField.inputView]) {
        self.unitField.text = [Constants UNITS][row];
        [self updateOnceLabel];
    } else {
        self.repeatField.text = [Constants REPEAT][row];
    }
}

@end