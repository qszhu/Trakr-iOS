//
// Created by Qinsi ZHU on 8/7/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "CompleteTaskViewController.h"
#import "Todo.h"
#import "Progress.h"
#import "Plan.h"
#import "Target.h"
#import "Task.h"
#import "Completion.h"
#import "SVProgressHUD.h"
#import "IUtils.h"
#import "TaskViewController.h"
#import "TestFlight.h"

@interface CompleteTaskViewController ()
@property(nonatomic) NSInteger seconds;
@property(nonatomic) BOOL timerRunning;
@property(strong, nonatomic) NSTimer *timer;
@end

@implementation CompleteTaskViewController {

}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"Task"];

    self.seconds = 0;
    self.timerRunning = NO;

    self.targetNameLabel.text = self.todo.progress.plan.target.name;
    self.taskNameLabel.text = self.todo.task.name;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"complete task view appear"];
}

- (NSString *)timerText {
    NSInteger hours = self.seconds / 3600;
    NSInteger minutes = self.seconds % 3600 / 60;
    NSInteger seconds = self.seconds % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

- (void)onTimerTick {
    self.seconds += 1;
    self.timerLabel.text = [self timerText];
}

- (IBAction)cancelPressed:(id)sender {
    [TestFlight passCheckpoint:@"cancel pressed"];

    if (self.timer != nil) {
        [self.timer invalidate];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishPressed:(id)sender {
    [TestFlight passCheckpoint:@"finish pressed"];

    if (self.timer != nil) {
        [self.timer invalidate];
    }
    Completion *completion = [[Completion alloc] init];
    completion.task = self.todo.task;
    completion.cost = self.seconds;
    completion.date = [NSDate date];
    self.todo.progress.completions = [self.todo.progress.completions arrayByAddingObject:completion];
    [SVProgressHUD showWithStatus:@"Completing task..." maskType:SVProgressHUDMaskTypeGradient];
    [self.todo.progress saveWithTarget:self selector:@selector(saveProgress:error:)];
}

- (void)saveProgress:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if ([result boolValue]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidCompleteTaskNotification object:self];
    } else {
        [IUtils showErrorDialogWithTitle:@"Cannot complete task" error:error];
    }
}

- (IBAction)timerPressed:(id)sender {
    [TestFlight passCheckpoint:@"timer pressed"];

    self.timerRunning = !self.timerRunning;
    NSString *title = self.timerRunning ? @"Stop" : @"Start";
    [self.timerButton setTitle:title forState:UIControlStateNormal];
    if (self.timerRunning) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerTick) userInfo:nil repeats:YES];
    } else {
        [self.timer invalidate];
    }
}

@end