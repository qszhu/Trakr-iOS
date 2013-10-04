//
// Created by Qinsi ZHU on 8/7/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "CompleteTaskViewController.h"
#import "Todo.h"
#import "Progress.h"
#import "Plan.h"
#import "Target.h"
#import "SVProgressHUD.h"
#import "IUtils.h"
#import "Const.h"
#import "TodoUtils.h"
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
    TodoUtils *todoUtils = [[TodoUtils alloc] initWithViewController:self];
    [todoUtils completeTodoWithCost:self.seconds];
    [self dismissViewControllerAnimated:YES completion:nil];
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