//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "SelectPlanViewController.h"
#import "IUtils.h"
#import "CreatePlanViewController.h"
#import "Plan.h"
#import "Constants.h"


@implementation SelectPlanViewController {

}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = @"Plan";
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
    UIViewController *createPlanVC = [[CreatePlanViewController alloc] init];
    [self.navigationController pushViewController:createPlanVC animated:YES];
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

    Plan *plan = [Plan fromPFObject:object];
    cell.textLabel.text = plan.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@s", plan.total, [Constants getNameForUnit:plan.unit]];

    return cell;
}

@end