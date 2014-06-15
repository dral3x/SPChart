//
//  SPDetailViewController.m
//  SPChartDemo
//
//  Created by Alessandro Calzavara on 13/06/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPDetailViewController.h"

#import "SPChart.h"

#define Color1  [UIColor colorWithRed:247.0 / 255.0 green:221.0 / 255.0 blue:0.0 / 255.0 alpha:1.0f]
#define Color2  [UIColor colorWithRed:207.0 / 255.0 green:171.0 / 255.0 blue:0.0 / 255.0 alpha:1.0f]
#define Color3  [UIColor colorWithRed:155.0 / 255.0 green:137.0 / 255.0 blue:19.0 / 255.0 alpha:1.0f]
#define Color4  [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0f]

#define CHART_FRAME CGRectMake(0, 64, 320, CGRectGetHeight(self.view.bounds)-64)

@interface SPDetailViewController ()
@property (weak, nonatomic) SPLineChart * lineChart1;
@property (weak, nonatomic) SPBarChart * barChart2;
@property (weak, nonatomic) SPPieChart * pieChart1;

@property (weak, nonatomic) SPChartPopup * popup;
@end

@implementation SPDetailViewController

- (void)showLineChart1
{
    self.navigationItem.title = @"Line Chart";
    
    SPLineChart * chart = [[SPLineChart alloc] initWithFrame:CHART_FRAME];
    
    [chart setDatas:@[
                      [SPLineChartData dataWithValues:@[ @9, @6, @11, @14, @8, @5 ] color:Color1],
                      [SPLineChartData dataWithValues:@[ @1, @5, @8, @12, @11, @6 ] color:Color2]
                      ]
         forXValues:@[
                      @"GEN",
                      @"FEB",
                      @"MAR",
                      @"APR",
                      @"MAY",
                      @"JUN"
                      ]];
    
    
    // Show empty message, if the chart is empty
    chart.emptyChartText = @"The chart is empty.";
    
    [self.view addSubview:chart];
    
    [chart drawChart];
    
    chart.delegate = self;
    self.lineChart1 = chart;
}

- (void)showBarChart1
{
    self.navigationItem.title = @"Bar Chart";
    
    SPBarChart * chart = [[SPBarChart alloc] initWithFrame:CHART_FRAME];
    
    [chart setDatas:@[
                      [SPBarChartData dataWithValue:1 color:Color1 description:@"SEP 1"],
                      [SPBarChartData dataWithValue:24 color:Color1 description:@"SEP 2"],
                      [SPBarChartData dataWithValue:12 color:Color1 description:@"SEP 3"],
                      [SPBarChartData dataWithValue:18 color:Color1 description:@"SEP 4"],
                      [SPBarChartData dataWithValue:30 color:Color1 description:@"SEP 5"],
                      [SPBarChartData dataWithValue:10 color:Color1 description:@"SEP 6"],
                      [SPBarChartData dataWithValue:21 color:Color1 description:@"SEP 7"],
                      ]];
    
    
    // Show axis
    chart.showAxis = YES;
    // and section lines inside
    chart.showSectionLines = YES;
    
    // Show empty message, if the chart is empty
    chart.emptyChartText = @"The chart is empty.";
    
    [self.view addSubview:chart];
    
    [chart drawChart];
}

- (void)showBarChart2
{
    SPBarChart * chart = [[SPBarChart alloc] initWithFrame:CHART_FRAME];
    
    NSArray * colors = @[ Color1, Color2, Color3 ];
    
    [chart setDatas:@[
                      [SPBarChartData dataWithValues:@[ @94,  @21, @30 ] colors:colors description:@"GEN"],
                      [SPBarChartData dataWithValues:@[ @71,  @20, @10 ] colors:colors description:@"FEB"],
                      [SPBarChartData dataWithValues:@[ @44,  @0 , @50 ] colors:colors description:@"MAR"],
                      [SPBarChartData dataWithValues:@[ @127, @21, @8  ] colors:colors description:@"APR"],
                      [SPBarChartData dataWithValues:@[ @18,  @22, @0  ] colors:colors description:@"MAY"],
                      [SPBarChartData dataWithValues:@[ @163, @0 , @42 ] colors:colors description:@"JUN"],
                      [SPBarChartData dataWithValues:@[ @125, @9 , @20 ] colors:colors description:@"JUL"],
                      ]];
    
    // Set maximum value
    chart.maxDataValue = 210;
    
    // Show axis
    chart.showAxis = YES;
    // and section lines inside
    chart.showSectionLines = YES;
    
    // Show empty message, if the chart is empty
    chart.emptyChartText = @"The chart is empty.";
    
    [self.view addSubview:chart];
    
    [chart drawChart];
    
    chart.delegate = self;
    self.barChart2 = chart;
}

- (void)showPieChart1
{
    self.navigationItem.title = @"Pie Chart";
    
    SPPieChart * chart = [[SPPieChart alloc] initWithFrame:CHART_FRAME];
    
    [chart setDatas:@[
                      [SPPieChartData dataWithValue:10 color:Color1],
                      [SPPieChartData dataWithValue:20 color:Color2 description:@"WWDC"],
                      [SPPieChartData dataWithValue:40 color:Color3 description:@"GOOL I/O"],
                      ]];
    
    // Show empty message, if the chart is empty
    chart.emptyChartText = @"The chart is empty.";
    
    [self.view addSubview:chart];
    
    [chart drawChart];
    
    chart.delegate = self;
    self.pieChart1 = chart;
}

#pragma mark -
#pragma mark Popup

- (void)_dismissPopup
{
    if (self.popup) {
        [self.popup dismiss];
    }
}

#pragma mark -
#pragma mark SPChartDelegate

- (void)SPChartLineSelected:(NSInteger)lineIndex touchPoint:(CGPoint)point
{
    NSLog(@"Selected line %d", lineIndex);
    
    [self _dismissPopup];
}

- (void)SPChartLineKeyPointSelected:(NSInteger)pointIndex ofLine:(NSInteger)lineIndex keyPoint:(CGPoint)keyPoint touchPoint:(CGPoint)point
{
    NSLog(@"Selected key point %d in line %d", pointIndex, lineIndex);
    
    [self _dismissPopup];
    
    // Show a popup
    SPLineChartData * data = self.lineChart1.datas[lineIndex];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"%@ %@", data.values[pointIndex], (lineIndex == 0) ? @"visitors" : @"plays"];
    label.font = self.lineChart1.labelFont;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    SPChartPopup * popup = [[SPChartPopup alloc] initWithContentView:label];
    [popup setPopupColor:Color4];
    [popup sizeToFit];
    
    [popup showInView:self.lineChart1 withAnchorPoint:keyPoint];
    self.popup = popup;
}

- (void)SPChartBarSelected:(NSInteger)barIndex topPoint:(CGPoint)topPoint touchPoint:(CGPoint)touchPoint
{
    NSLog(@"Selected bar %d", barIndex);
    
    [self _dismissPopup];

    // Show a popup
    SPBarChartData * data = self.barChart2.datas[barIndex];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"%@ - %@ - %@", data.values[0], data.values[1], data.values[2]];
    label.font = self.barChart2.labelFont;
    label.textColor = [UIColor whiteColor];
    
    [label sizeToFit];
    
    SPChartPopup * popup = [[SPChartPopup alloc] initWithContentView:label];
    [popup setPopupColor:Color4];
    [popup sizeToFit];
    
    [popup showInView:self.barChart2 withAnchorPoint:topPoint];
    self.popup = popup;
}

- (void)SPChartPiePieceSelected:(NSInteger)pieceIndex
{
    NSLog(@"Selected piece %d", pieceIndex);
}

@end
