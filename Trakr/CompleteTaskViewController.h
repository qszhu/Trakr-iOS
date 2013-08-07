//
// Created by Qinsi ZHU on 8/7/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Todo;


@interface CompleteTaskViewController : UIViewController
@property(strong, nonatomic) Todo *todo;

@property(strong, nonatomic) IBOutlet UILabel *targetNameLabel;
@property(strong, nonatomic) IBOutlet UILabel *taskNameLabel;
@property(strong, nonatomic) IBOutlet UILabel *timerLabel;
@property(strong, nonatomic) IBOutlet UIButton *timerButton;
@property(strong, nonatomic) IBOutlet UIButton *finishButton;
@property(strong, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)timerPressed:(id)sender;

- (IBAction)finishPressed:(id)sender;

- (IBAction)cancelPressed:(id)sender;
@end