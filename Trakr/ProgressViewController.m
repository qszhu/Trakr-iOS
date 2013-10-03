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
    PFQuery *query = [Progress query];
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        [query whereKey:@"creator" equalTo:user];
    }
    [query includeKey:@"plan.target"];
    [query includeKey:@"plan.tasks"];
    [query includeKey:@"completions.task"];
    return query;
}

- (NSString *)formatFinishDate:(Progress *)progress {
    NSDate *finishDate = [progress getFinishDate];
    TTTTimeIntervalFormatter *timeIntervalFormatter = [TTTTimeIntervalFormatter new];
    NSTimeInterval interval = [finishDate timeIntervalSinceDate:[NSDate date]];
    NSString *str = [timeIntervalFormatter stringForTimeInterval:interval];
    if (interval <= 0) {
        return [NSString stringWithFormat:@"finished %@", str];
    }
    return [NSString stringWithFormat:@"finishes in %@", str];
}

- (NSString *)formatLateDays:(Progress *)progress {
    NSDate *date = [progress getFirstImcompleteDate];
    if (date == nil) {
        return @"";
    }
    NSInteger lateDays = [IUtils daysBetween:date and:[NSDate date]];
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

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellIdentifier = @"Cell";

    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    Progress *progress = (Progress *)object;
    cell.textLabel.text = progress.plan.target.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d/%d tasks, %@",
                                 progress.completions.count, progress.plan.tasks.count, [self getProgressStatus:progress]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TestFlight passCheckpoint:@"select progress"];

    ProgressDetailViewController *progressDetailVC = [ProgressDetailViewController new];
    Progress *progress = [self.objects objectAtIndex:indexPath.row];
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