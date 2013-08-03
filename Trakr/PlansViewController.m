//
//  PlansViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "PlansViewController.h"
#import "IUtils.h"
#import "SelectPlanViewController.h"

@interface PlansViewController ()

@end

@implementation PlansViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Plans";

    [IUtils setRightBarAddButton:self action:@selector(newPlanPressed)];
}

- (void)newPlanPressed {
    UIViewController *selectPlanVC = [[SelectPlanViewController alloc] init];
    [self.navigationController pushViewController:selectPlanVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"My Plan %d", indexPath.row];
    }
    return cell;
}
@end