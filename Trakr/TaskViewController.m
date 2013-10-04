//
//  TaskViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "TaskViewController.h"
#import "Progress.h"
#import "IUtils.h"
#import "TaskGroup.h"
#import "GroupedTasks.h"
#import "SVProgressHUD.h"
#import "Todo.h"
#import "Plan.h"
#import "ProgressDetailViewController.h"
#import "Completion.h"
#import "ODRefreshControl.h"
#import "TTTTimeIntervalFormatter.h"
#import "Const.h"
#import "TodoUtils.h"
#import "TestFlight.h"

@interface TaskViewController () <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) GroupedTasks *groupedTasks;
@property(strong, nonatomic) ODRefreshControl *rc;
@property(strong, nonatomic) Todo *todo;
@property(nonatomic) NSInteger selectedTaskGroup;
@property(strong, nonatomic) TodoUtils *todoUtils;
@end

enum CellType {
    CellTypeEmpty,
    CellTypeSingleTask,
    CellTypeProgress,
    CellTypeProgressOverview
};

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self.navigationItem setTitle:@"Tasks"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteTask:) name:kDidCompleteTaskNotification object:nil];

    [self.progressesTable setDelegate:self];
    [self.progressesTable setDataSource:self];

    self.rc = [[ODRefreshControl alloc] initInScrollView:self.progressesTable];
    [self.rc addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];

    self.todoUtils = [[TodoUtils alloc] initWithViewController:self];

    self.selectedTaskGroup = kTaskGroupToday;
    [self refresh];
}

- (void)didLogin:(NSNotification *)notification {
    [self refresh];
}

- (void)didCompleteTask:(NSNotification *)notification {
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [TestFlight passCheckpoint:@"task view appear"];
}

- (void)pullToRefresh:(ODRefreshControl *)refreshControl {
    [self refresh];
}

- (void)refresh {
    NSLog(@"refresh");
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        PFQuery *query = [Progress query];
        [query whereKey:@"creator" equalTo:user];
        [query includeKey:@"plan"];
        [query includeKey:@"plan.target"];
        [query includeKey:@"plan.tasks"];
        [query includeKey:@"completions"];

        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeNone];
        [query findObjectsInBackgroundWithTarget:self selector:@selector(getProgresses:error:)];
    }
}

- (void)getProgresses:(NSArray *)results error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Error" error:error];
        return;
    }

    self.groupedTasks = [[GroupedTasks alloc] initWithProgresses:results];

    NSLog(@"reload");
    [self.progressesTable reloadData];
    [self.rc endRefreshing];

    [TestFlight passCheckpoint:@"task list reloaded"];
}

- (IBAction)groupChanged:(id)sender {
    [TestFlight passCheckpoint:@"switch task group segment"];

    switch (self.taskGroupSegment.selectedSegmentIndex) {
        case 1:
            self.selectedTaskGroup = kTaskGroupToday;
            break;
        case 2:
            self.selectedTaskGroup = kTaskGroupTomorrow;
            break;
        default:
            self.selectedTaskGroup = kTaskGroupAll;
            break;
    }

    [self.progressesTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numOfProgresses = [[self groupedTasks] getNumberOfProgressesInGroup:self.selectedTaskGroup];
    return numOfProgresses > 0 ? numOfProgresses : 1;
}

- (void)resetCell:(UITableViewCell *)cell {
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)recycleCellFromTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    [self resetCell:cell];
    return cell;
}

- (NSInteger)getCellTypeAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedTaskGroup == kTaskGroupAll) {
        return CellTypeProgressOverview;
    }

    NSInteger numOfProgresses = [self.groupedTasks getNumberOfProgressesInGroup:self.selectedTaskGroup];
    if (numOfProgresses == 0) {
        return CellTypeEmpty;
    }

    Progress *progress = [[self.groupedTasks getProgressesInGroup:self.selectedTaskGroup] objectAtIndex:indexPath.row];
    NSInteger numOfTasks = [self.groupedTasks getNumberOfTasksOfProgressById:progress.objectId inGroup:self.selectedTaskGroup];
    if (numOfTasks == 1) {
        return CellTypeSingleTask;
    }

    return CellTypeProgress;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self recycleCellFromTableView:tableView];

    NSInteger cellType = [self getCellTypeAtIndexPath:indexPath];
    if (cellType == CellTypeEmpty) {
        return [self setEmptyCell:cell];
    }

    Progress *progress = [[self.groupedTasks getProgressesInGroup:self.selectedTaskGroup] objectAtIndex:indexPath.row];
    NSArray *tasks = [self.groupedTasks getTasksOfProgressById:progress.objectId inGroup:self.selectedTaskGroup];
    switch (cellType) {
        case CellTypeProgressOverview:
            return [self setProgressOverviewCell:cell forProgress:progress];
        case CellTypeSingleTask:
            return [self setSingleTaskCell:cell forTask:[tasks objectAtIndex:0] inProgress:progress];
        default:
            return [self setProgressCell:cell forProgress:progress tasks:tasks];
    }
}

- (UITableViewCell *)setEmptyCell:(UITableViewCell *)cell {
    cell.textLabel.text = @"No tasks";
    return cell;
}

- (UITableViewCell *)setProgressOverviewCell:(UITableViewCell *)cell forProgress:(Progress *)progress {
    cell.textLabel.text = [progress getName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d/%d tasks, %@",
                                 [progress getNumberOfCompletedTasks], [progress getNumberOfTasks], [progress getProgressStatusString]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell *)setSingleTaskCell:(UITableViewCell *)cell forTask:(Task *)task inProgress:(Progress *)progress{
    cell.textLabel.text = [progress getName];
    cell.detailTextLabel.text = task.name;
    cell.accessoryType = [progress isTaskCompleted:task] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (UITableViewCell *)setProgressCell:(UITableViewCell *)cell forProgress:(Progress *)progress tasks:(NSArray *)tasks {
    cell.textLabel.text = [progress getName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d tasks", tasks.count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TestFlight passCheckpoint:@"select task"];

    NSInteger cellType = [self getCellTypeAtIndexPath:indexPath];
    if (cellType == CellTypeEmpty) {
        return;
    }

    Progress *progress = [[self.groupedTasks getProgressesInGroup:self.selectedTaskGroup] objectAtIndex:indexPath.row];
    NSArray *tasks = [self.groupedTasks getTasksOfProgressById:progress.objectId inGroup:self.selectedTaskGroup];
    switch (cellType) {
        case CellTypeProgressOverview:
            [self selectedProgressOverview:progress];
            return;
        case CellTypeSingleTask:
            [self selectedTask:[tasks objectAtIndex:0] inProgress:progress];
            return;
        default:
            [TestFlight passCheckpoint:@"select progress"];
            return;
    }
}

- (void)selectedTask:(Task *)task inProgress:(Progress *)progress {
    [TestFlight passCheckpoint:@"select task"];

    Todo *todo = [[Todo alloc] initWithTask:task inProgress:progress];
    [self.todoUtils completeTodo:todo];
}

- (void)selectedProgressOverview:(Progress *)progress {
    [TestFlight passCheckpoint:@"select progress overview"];

    ProgressDetailViewController *progressDetailVC = [ProgressDetailViewController new];
    progressDetailVC.progressId = progress.objectId;
    [self.navigationController pushViewController:progressDetailVC animated:YES];
}

@end