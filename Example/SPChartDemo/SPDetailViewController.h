//
//  SPDetailViewController.h
//  SPChartDemo
//
//  Created by Alessandro Calzavara on 13/06/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPChartDelegate.h"

@interface SPDetailViewController : UIViewController <SPChartDelegate>

- (void)showLineChart1;

- (void)showBarChart1;
- (void)showBarChart2;

- (void)showPieChart1;

@end
