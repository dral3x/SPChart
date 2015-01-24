//
//  SPBarChart.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPChartView.h"
#import "SPChartCommon.h"
#import "SPBar.h"


/**
 `SPBarChart` is a bar chart (don't you say?).
 */
@interface SPBarChart : SPChartView

/**
 Contains all the `SPBarChartData` objects used for drawing the chart.
 It will also recalculate `maxDataValue`.
 */
@property (nonatomic, strong) NSArray * datas;

/**
 Defines the max value visible in the chart. Assign a value *AFTER* `setDatas:` is called.
 */
@property (nonatomic, assign) NSInteger maxDataValue;



/// @name Customize

/*
 yLabelFormatter will format labels text on the Y axis
 */
@property (nonatomic, copy) SPChartLabelFormatter yLabelFormatter;

/*
 barValueFormatter will format labels text on the bars
 */
@property (nonatomic, copy) SPChartLabelFormatter barValueFormatter;


/**
 If YES, chart will be draw upside down.
 */
@property (assign, nonatomic) BOOL upsideDown;



/// @name Customize bars

/*
 barWidth changes the width of the bar. If <= 0, the width will be automatically calculated
 */
@property (nonatomic, assign) CGFloat barWidth;

/*
 barRadius changes the bar corner radius
 */
@property (nonatomic, assign) CGFloat barRadius;

/*
 barBackgroundColor changes the bar background color
 */
@property (nonatomic, copy) UIColor * barBackgroundColor;

/*
 showBarValues defines if labels on top/bottom of each bar should be displayed of not
 */
@property (assign, nonatomic) BOOL showBarValues;

/*
 barValueTextColor changes the bar value text color.
 Default value is nil, meaning same as `labelTextColor`.
 */
@property (nonatomic, copy) UIColor * barValueTextColor;


/// @name Customize axis

/*
 yLabelCount defines how many labels to display on the left (y axis)
 */
@property (nonatomic, assign) NSInteger yLabelCount;

/*
 showYLabels defines if labels on Y axis should be displayed of not
 */
@property (nonatomic, assign) BOOL showYLabels;

/*
 showXLabels defines if labels on X axis should be displayed of not
 */
@property (nonatomic, assign) BOOL showXLabels;

/**
 xLabelSkip define the label skip number.
 1 means show all labels; 2 means no-yes-no-yes; 3 means no-no-yes-no-no-yes
 */
@property (nonatomic, assign) NSInteger xLabelSkip;

/*
 labelTextColor changes the bar label text color
 */
@property (nonatomic, copy) UIColor * labelTextColor;

/*
 labelFont changes the bar label font
 */
@property (nonatomic, strong) UIFont * labelFont;

/*
 showAxis enables the drawing of X and Y axis lines
 */
@property (nonatomic, assign) BOOL showAxis;

/*
 Color of the axis
 */
@property (nonatomic, copy) UIColor * axisColor;

/*
 showSectionLines enables the drawing of the dotted lines in the background
 */
@property (nonatomic, assign) BOOL showSectionLines;

/*
 Color of the dotted lines in the background of the chart
 */
@property (nonatomic, copy) UIColor * sectionLinesColor;

@end
