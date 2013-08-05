//
//  ProgressViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "ProgressViewController.h"
#import "IUtils.h"
#import "SelectPlanViewController.h"
#import "Progress.h"
#import "Plan.h"
#import "Target.h"

@implementation ProgressViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = NSStringFromClass([Progress class]);
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"My Progress"];

    [IUtils setRightBarAddButton:self action:@selector(newPlanPressed)];
}

- (void)newPlanPressed {
    SelectPlanViewController *selectPlanVC = [[SelectPlanViewController alloc] init];
    selectPlanVC.progressVC = self;
    [self.navigationController pushViewController:selectPlanVC animated:YES];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        [query whereKey:@"creator" equalTo:[PFUser currentUser]];
    }
    [query includeKey:@"plan"];
    [query includeKey:@"plan.target"];
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

    Progress *progress = [[Progress alloc] initWithParseObject:object];
    cell.textLabel.text = progress.plan.target.name;

    return cell;
}

@end