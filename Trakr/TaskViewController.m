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
#import "DeleteUtils.h"
#import "SettingsViewController.h"
#import "SWTableViewCell.h"
#import "TestFlight.h"

static NSString * const kDidDeleteProgressNotification = @"DidDeleteProgressNotification";

@interface TaskViewController () <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>
@property(strong, nonatomic) GroupedTasks *groupedTasks;
@property(strong, nonatomic) ODRefreshControl *rc;
@property(strong, nonatomic) Todo *todo;
@property(nonatomic) NSInteger selectedTaskGroup;
@property(strong, nonatomic) TodoUtils *todoUtils;
@property(strong, nonatomic) DeleteUtils *deleteUtils;
@end

enum CellType {
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

    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(viewSettings)];
    self.navigationItem.rightBarButtonItem = btn;

    [self.navigationItem setTitle:@"Tasks"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteTask:) name:kDidCompleteTaskNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateProgress:) name:kDidCreateProgressNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteProgress:) name:kDidDeleteProgressNotification object:nil];

    [self.progressesTable setDelegate:self];
    [self.progressesTable setDataSource:self];

    self.rc = [[ODRefreshControl alloc] initInScrollView:self.progressesTable];
    [self.rc addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];

    self.todoUtils = [[TodoUtils alloc] initWithViewController:self];
    self.deleteUtils = [DeleteUtils new];

    self.selectedTaskGroup = kTaskGroupToday;
    [self refresh];
}

- (void)viewSettings {
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    SettingsViewController *settingsVC = [settingsStoryboard instantiateInitialViewController];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)didLogin:(NSNotification *)notification {
    [self refresh];
}

- (void)didCompleteTask:(NSNotification *)notification {
    [self refresh];
}

- (void)didCreateProgress:(NSNotification *)notification {
    [self refresh];
}

- (void)didDeleteProgress:(NSNotification *)notification {
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
    return [[self groupedTasks] getNumberOfProgressesInGroup:self.selectedTaskGroup];
}

- (UITableViewCell *)recycleCellFromTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    [IUtils resetTableViewCell:cell];
    return cell;
}

- (NSInteger)getCellTypeAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedTaskGroup == kTaskGroupAll) {
        return CellTypeProgressOverview;
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

- (UITableViewCell *)setProgressOverviewCell:(UITableViewCell *)cell forProgress:(Progress *)progress {
    cell.textLabel.text = [progress getName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d/%d tasks, %@",
                                 [progress getNumberOfCompletedTasks], [progress getNumberOfTasks], [progress getProgressStatusString]];
    if ([progress getLateDays] > 0) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.progressesTable indexPathForCell:cell];
    Progress *progress = [[self.groupedTasks getProgressesInGroup:self.selectedTaskGroup] objectAtIndex:indexPath.row];
    NSArray *tasks = [self.groupedTasks getTasksOfProgressById:progress.objectId inGroup:self.selectedTaskGroup];
    Todo *todo = [[Todo alloc] initWithTask:[tasks objectAtIndex:0] inProgress:progress];
    if ([todo isCompleted]) {
        if (index == 0) {
            [self.todoUtils showUncompleteTaskDialog:todo];
        }
        return;
    }
    switch (index) {
        case 0:
            [self.todoUtils showCompleteTaskDialog:todo];
            break;
        case 1:
            [self.todoUtils showCompleteTaskTimer:todo];
            break;
        default:
            break;
    }
}

- (UITableViewCell *)setSingleTaskCell:(UITableViewCell *)cell forTask:(Task *)task inProgress:(Progress *)progress {
    BOOL completed = [progress isTaskCompleted:task];
    UITableViewCell *swcell = [TodoUtils recycleSWCellFromTableView:self.progressesTable delegate:self completed:completed];
    swcell.textLabel.text = [progress getName];
    swcell.detailTextLabel.text = task.name;
    swcell.accessoryType = completed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return swcell;
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
    if ([todo isCompleted]) return;
    [self.todoUtils completeTodo:todo];
}

- (void)selectedProgressOverview:(Progress *)progress {
    [TestFlight passCheckpoint:@"select progress overview"];

    ProgressDetailViewController *progressDetailVC = [ProgressDetailViewController new];
    progressDetailVC.progressId = progress.objectId;
    [self.navigationController pushViewController:progressDetailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellType = [self getCellTypeAtIndexPath:indexPath];
    return cellType == CellTypeProgressOverview;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [TestFlight passCheckpoint:@"delete progress"];

        Progress *progress = [[self.groupedTasks getProgressesInGroup:self.selectedTaskGroup] objectAtIndex:indexPath.row];
        [self.deleteUtils delete:@"progress" object:progress inView:self.tabBarController.tabBar withNotificationName:kDidDeleteProgressNotification];
    }
}

@end