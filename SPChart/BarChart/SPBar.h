//
//  SPBar.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SPBar : UIView

@property (nonatomic, assign) CGFloat barRadius;

@property (nonatomic, strong) NSArray * grades;
@property (nonatomic, strong) NSArray * barColors;

@end
