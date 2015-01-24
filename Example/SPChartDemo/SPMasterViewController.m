//
//  SPMasterViewController.m
//  SPChartDemo
//
//  Created by Alessandro Calzavara on 13/06/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPMasterViewController.h"

#import "SPDetailViewController.h"

@interface SPMasterViewController ()

@end

@implementation SPMasterViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SPDetailViewController * viewController = (SPDetailViewController *)[segue destinationViewController];
    
    if ([@"demoBarChart1" isEqualToString:segue.identifier]) {
        [viewController showBarChart1];
    }
    if ([@"demoBarChart2" isEqualToString:segue.identifier]) {
        [viewController showBarChart2];
    }
    if ([@"demoBarChart3" isEqualToString:segue.identifier]) {
        [viewController showBarChart3];
    }
    
    
    
    if ([@"demoLineChart1" isEqualToString:segue.identifier]) {
        [viewController showLineChart1];
    }
    
    
    if ([@"demoPieChart1" isEqualToString:segue.identifier]) {
        [viewController showPieChart1];
    }
    
    
}

@end
