//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "SelectPlanViewController.h"
#import "IUtils.h"
#import "CreatePlanViewController.h"
#import "Plan.h"
#import "Constants.h"
#import "Target.h"
#import "Progress.h"
#import "ProgressViewController.h"


@implementation SelectPlanViewController {

}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = NSStringFromClass([Plan class]);
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Select Plan";

    [IUtils setRightBarAddButton:self action:@selector(createPlanPressed)];
}

- (void)createPlanPressed {
    CreatePlanViewController *createPlanVC = [[CreatePlanViewController alloc] init];
    createPlanVC.progressVC = self.progressVC;
    [self.navigationController pushViewController:createPlanVC animated:YES];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:@"target"];
    return query;
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

    Plan *plan = [[Plan alloc] initWithParseObject:object];
    cell.textLabel.text = plan.target.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@s", plan.total, [Constants getNameForUnit:plan.unit]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Progress *progress = [[Progress alloc] init];
    Plan *plan = [[Plan alloc] initWithParseObject:[self.objects objectAtIndex:indexPath.row]];
    progress.plan = plan;
    [progress saveWithTarget:self selector:@selector(saveProgressWithResult:error:)];
}

- (void)saveProgressWithResult:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.progressVC loadObjects];
    } else {
        [IUtils showErrorDialogWithTitle:@"Cannot create progress" error:error];
    }
}

@end