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
#import "TestFlight.h"
#import "TTTTimeIntervalFormatter.h"
#import "Task.h"
#import "Completion.h"

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"My Progress"];

    [IUtils setRightBarAddButton:self action:@selector(newPlanPressed)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"progress view appear"];
}

- (void)newPlanPressed {
    [TestFlight passCheckpoint:@"new plan pressed"];

    SelectPlanViewController *selectPlanVC = [[SelectPlanViewController alloc] init];
    selectPlanVC.progressVC = self;
    [self.navigationController pushViewController:selectPlanVC animated:YES];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Progress class])];
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        [query whereKey:@"creator" equalTo:user];
    }
    [query includeKey:@"plan"];
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
    return [IUtils dateByOffset:offset fromDate:progress.startDate];
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

- (NSUInteger)getLateDays:(Progress *)progress {
    int offset = 0;
    for (Task *task in progress.plan.tasks) {
        for (Completion *completion in progress.completions) {
            if (completion.task.getParseObject.objectId == task.getParseObject.objectId) {
                if (task.offset > offset) {
                    offset = task.offset;
                }
            }
        }
    }
    int nextOffset = NSIntegerMax;
    for (Task *task in progress.plan.tasks) {
        if (task.offset >= offset && task.offset < nextOffset) {
            nextOffset = task.offset;
        }
    }
    NSDate *nextCompleteDate = [IUtils dateByOffset:nextOffset fromDate:progress.startDate];
    return [IUtils daysBetween:nextCompleteDate and:[NSDate date]];
}

- (NSString *)formatLateDays:(Progress *)progress {
    NSUInteger lateDays = [self getLateDays:progress];
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

@end