//
//  PNLineChart.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/14/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPChartView.h"
#import "SPChartCommon.h"
#import "SPLineChartData.h"


/**
 `SPLineChart` is a line chart (don't you say?).
 */
@interface SPLineChart : SPChartView

- (void)setDatas:(NSArray *)data forXValues:(NSArray *)xValues;

@property (nonatomic, strong, readonly) NSArray * datas;

@property (nonatomic, strong, readonly) NSArray * xValues;

/**
 Defines the max value visible in the chart. Assign a value *AFTER* `setDatas:forXValues:` is called.
 */
@property (nonatomic, assign) NSInteger yMaxValue;

/**
 Defines the min value visible in the chart. Assign a value *AFTER* `setDatas:forXValues:` is called.
 */
@property (nonatomic, assign) NSInteger yMinValue;


/// @name Customize axis

@property (nonatomic, assign) BOOL showXAxis;

@property (nonatomic, assign) BOOL showYAxis;

/*
 Color of the axis
 */
@property (nonatomic, copy) UIColor * axisColor;

/*
 showYLabels defines if labels on Y axis should be displayed of not
 */
@property (nonatomic, assign) BOOL showYLabels;

/*
 showXLabels defines if labels on X axis should be displayed of not
 */
@property (nonatomic, assign) BOOL showXLabels;

/*
 change the orientation of labels on X axis
 */
@property (nonatomic, assign) CGFloat xLabelsOrientationAngle;

/*
 yLabelCount defines how many labels to display on the left (y axis)
 */
@property (nonatomic, assign) NSInteger yLabelCount;

/*
 labelTextColor changes the bar label text color
 */
@property (nonatomic, copy) UIColor * labelTextColor;

/*
 labelFont changes the bar label font
 */
@property (nonatomic, strong) UIFont * labelFont;

/*
 yLabelFormatter will format labels text on the Y axis
 */
@property (nonatomic, copy) SPChartLabelFormatter yLabelFormatter;

/*
 showSectionLines enables the drawing of the dotted lines in the background
 */
@property (nonatomic, assign) BOOL showSectionLines;

/*
 Color of the dotted lines in the background of the chart
 */
@property (nonatomic, copy) UIColor * sectionLinesColor;

@end
