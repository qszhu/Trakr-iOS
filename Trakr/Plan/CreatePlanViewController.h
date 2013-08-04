//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Plan;


@interface CreatePlanViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property(strong, nonatomic) Plan *plan;

@property(strong, nonatomic) IBOutlet UIButton *targetButton;

@property(strong, nonatomic) IBOutlet UITextField *totalField;
@property(strong, nonatomic) IBOutlet UITextField *unitField;

@property(strong, nonatomic) IBOutlet UITextField *startDateField;

@property(strong, nonatomic) IBOutlet UISwitch *createTaskSwitch;
@property(strong, nonatomic) IBOutlet UIView *taskView;

@property(strong, nonatomic) IBOutlet UITextField *numberOfTasksField;
@property(strong, nonatomic) IBOutlet UITextField *repeatField;

- (IBAction)selectTarget:(id)sender;

- (IBAction)createPressed:(id)sender;

- (IBAction)switchCreateTask:(id)sender;
@end