//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CreatePlanViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(strong, nonatomic) IBOutlet UIButton *targetButton;
@property(strong, nonatomic) NSObject *target;

@property(strong, nonatomic) IBOutlet UITextField *totalField;
@property(strong, nonatomic) IBOutlet UITextField *unitField;

@property(strong, nonatomic) IBOutlet UITextField *nameField;
@property(strong, nonatomic) IBOutlet UITextField *startDateField;
@property(strong, nonatomic) NSDate *startDate;

@property(strong, nonatomic) IBOutlet UISwitch *createTaskSwitch;
@property(strong, nonatomic) IBOutlet UIView *taskView;

@property(strong, nonatomic) IBOutlet UILabel *onceLabel;
@property(strong, nonatomic) IBOutlet UIStepper *onceStepper;

@property(strong, nonatomic) IBOutlet UITextField *repeatField;

- (IBAction)selectTarget:(id)sender;
- (IBAction)createPressed:(id)sender;
- (IBAction)onceChanged:(id)sender;
- (IBAction)totalChanged:(id)sender;
- (IBAction)switchCreateTask:(id)sender;
@end