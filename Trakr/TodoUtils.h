//
//  TodoUtils.h
//  Trakr
//
//  Created by Qinsi ZHU on 10/4/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Todo;
@class SWTableViewCell;

@interface TodoUtils : NSObject

- (id)initWithViewController:(UIViewController *)viewController;

- (void)completeTodo:(Todo *)todo;

- (void)showCompleteTaskTimer:(Todo *)todo;

- (void)showCompleteTaskDialog:(Todo *)todo;

- (void)showUncompleteTaskDialog:(Todo *)todo;

- (void)completeTodo:(Todo *)todo withCost:(NSInteger)cost;

+ (SWTableViewCell *)recycleSWCellFromTableView:(UITableView *)tableView delegate:(id)delegate completed:(BOOL)completed;
@end
