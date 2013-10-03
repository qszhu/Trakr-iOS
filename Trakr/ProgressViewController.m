//
//  ProgressViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "ProgressViewController.h"
#import "ProgressDetailViewController.h"
#import "Progress.h"
#import "IUtils.h"
#import "SelectPlanViewController.h"
#import "Plan.h"
#import "Target.h"
#import "TTTTimeIntervalFormatter.h"
#import "Task.h"
#import "Completion.h"
#import "SVProgressHUD.h"
#import "Const.h"
#import "TestFlight.h"

@interface ProgressViewController()
@property (strong, nonatomic) NSIndexPath *selectedIndex;
@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateProgress:) name:kDidCreateProgressNotification object:nil];
    [IUtils setRightBarAddButton:self action:@selector(newPlanPressed)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"My Progress";

    [TestFlight passCheckpoint:@"progress view appear"];
}

- (void)didCreateProgress:(NSNotification *)notification {
    [self loadObjects];
}

- (void)newPlanPressed {
    [TestFlight passCheckpoint:@"new plan pressed"];

    SelectPlanViewController *selectPlanVC = [SelectPlanViewController new];

    self.navigationItem.title = @"";
    [self.navigationController pushViewController:selectPlanVC animated:YES];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Progress class])];
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        [query whereKey:@"creator" equalTo:user];
    }
    [query includeKey:@"plan.target"];
    [query includeKey:@"plan.tasks"];
    [query includeKey:@"completions.task"];
    return query;
}

- (NSDate *)getFinishDate:(Progress *)progress {
    int offset = 0;
    for (Task *task in progress.plan.tasks) {
        if (task.offset > offset) {
            offset = task.offset;
        }
    }
    return [IUtils dateByOffset:offset+1 fromDate:progress.startDate];
}

- (NSString *)formatFinishDate:(Progress *)progress {
    NSDate *finishDate = [self getFinishDate:progress];
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    NSTimeInterval interval = [finishDate timeIntervalSinceDate:[NSDate date]];
    NSString *str = [timeIntervalFormatter stringForTimeInterval:interval];
    if (interval <= 0) {
        return [NSString stringWithFormat:@"finished %@", str];
    }
    return [NSString stringWithFormat:@"finishes in %@", str];
}

- (NSInteger)getLateDays:(Progress *)progress {
    int offset = 0;
    for (Task *task in progress.plan.tasks) {
        for (Completion *completion in progress.completions) {
            if ([[completion.task objectId] isEqualToString:[task objectId]]) {
                if (task.offset > offset) {
                    offset = task.offset;
                }
            }
        }
    }
    int nextOffset = NSIntegerMax;
    for (Task *task in progress.plan.tasks) {
        if (task.offset > offset && task.offset < nextOffset) {
            nextOffset = task.offset;
        }
    }
    NSDate *nextCompleteDate = [IUtils dateByOffset:nextOffset fromDate:progress.startDate];
    return [IUtils daysBetween:nextCompleteDate and:[NSDate date]];
}

- (NSString *)formatLateDays:(Progress *)progress {
    NSInteger lateDays = [self getLateDays:progress];
    if (lateDays <= 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%d days late", lateDays];
}

- (NSString *)getProgressStatus:(Progress *)progress {
    NSString *lateStr = [self formatLateDays:progress];
    if ([lateStr isEqualToString:@""]) {
        return [self formatFinishDate:progress];
    }
    return lateStr;
}

- (PFTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *cellIdentifier = @"Cell";

    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }

    Progress *progress = [[Progress alloc] initWithParseObject:object];
    cell.textLabel.text = progress.plan.target.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d/%d tasks, %@",
                                 progress.completions.count, progress.plan.tasks.count, [self getProgressStatus:progress]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TestFlight passCheckpoint:@"select progress"];

    ProgressDetailViewController *progressDetailVC = [[ProgressDetailViewController alloc] init];
    PFObject *progress = [self.objects objectAtIndex:indexPath.row];
    progressDetailVC.progressId = progress.objectId;
    [self.navigationController pushViewController:progressDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.selectedIndex = indexPath;
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure to delete this progress?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Delete"
                                                  otherButtonTitles:nil];
        [sheet showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [TestFlight passCheckpoint:@"delete progress"];

        [SVProgressHUD showWithStatus:@"Deleting progress..." maskType:SVProgressHUDMaskTypeGradient];
        [[self.objects objectAtIndex:self.selectedIndex.row] deleteInBackgroundWithTarget:self selector:@selector(deleteProgressWithResult:error:)];
    }
}

- (void)deleteProgressWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot delete progress" error:error];
        return;
    }
    [self loadObjects];
}

@end