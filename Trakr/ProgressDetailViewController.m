//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProgressDetailViewController.h"
#import "Progress.h"
#import "IUtils.h"
#import "Plan.h"
#import "Completion.h"
#import "Todo.h"
#import "TodoUtils.h"
#import "Const.h"
#import "ODRefreshControl.h"
#import "SVProgressHUD.h"
#import "TestFlight.h"

@interface ProgressDetailViewController()
@property (strong, nonatomic) Progress *progress;
@property (strong, nonatomic) TodoUtils *todoUtils;
@property(strong, nonatomic) ODRefreshControl *rc;
@end

@implementation ProgressDetailViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.todoUtils = [[TodoUtils alloc] initWithViewController:self];

    self.rc = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.rc addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteTask:) name:kDidCompleteTaskNotification object:nil];

    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"progress detail view appear"];
}

- (void)didCompleteTask:(NSNotification *)notification {
    [self refresh];
}

- (void)pullToRefresh:(ODRefreshControl *)refreshControl {
    [self refresh];
}

- (void)refresh {
    PFQuery *query = [Progress query];
    [query includeKey:@"plan.target"];
    [query includeKey:@"plan.tasks"];
    [query includeKey:@"completions.task"];

    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeNone];
    [query getObjectInBackgroundWithId:self.progressId target:self selector:@selector(getProgress:error:)];
}

- (void)getProgress:(PFObject *)progress error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Error" error:error];
        return;
    }
    self.progress = (Progress *)progress;
    [self.navigationItem setTitle:[self.progress getName]];

    [self.tableView reloadData];
    [self.rc endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.progress == nil) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    return self.progress.plan.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.progress == nil) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    UITableViewCell *cell = [IUtils recycleCellFromTableView:tableView];

    Task *task = [self.progress.plan.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task.name;

    NSString *taskDateString = [IUtils stringFromDate:[task getDate:self.progress.startDate]];
    NSString *taskStatusString = [self.progress getTaskStatusString:task];
    NSString *separator = [taskStatusString isEqualToString:@""] ? @"" : @" / ";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@", taskDateString, separator, taskStatusString];

    if ([self.progress isTaskCompleted:task]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ([self.progress getTaskLateDays:task] > 0) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.progress.plan.tasks objectAtIndex:indexPath.row];
    Todo *todo = [[Todo alloc] initWithTask:task inProgress:self.progress];
    if (todo.isCompleted) return;
    [self.todoUtils completeTodo:todo];
}

@end