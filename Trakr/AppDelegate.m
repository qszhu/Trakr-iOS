//
//  AppDelegate.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "AppDelegate.h"
#import "Plan/PlansViewController.h"
#import "SecondViewController.h"
#import "MainViewController.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (void)parseInit:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"vWqZkcSCvOlkcGltPDBYwy9Gt5k1cZyBMI32WVpl"
                  clientKey:@"bligFq7ajuGKzzM17eTRUp5PQRd8aUv6frJ8rAU0"];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

//    [PFUser logOut];

    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self parseInit:launchOptions];

    PlansViewController *plansVC = [[PlansViewController alloc] init];
    UINavigationController *plansNav = [[UINavigationController alloc] initWithRootViewController:plansVC];
    plansNav.tabBarItem.title = @"Plans";
    plansNav.tabBarItem.image = [UIImage imageNamed:@"first.png"];

    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.tabBarItem.title = @"Second";
    secondVC.tabBarItem.image = [UIImage imageNamed:@"second.png"];

    MainViewController *mainVC = [[MainViewController alloc] init];
    [mainVC setViewControllers:@[plansNav, secondVC] animated:NO];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];

    return YES;
}

@end