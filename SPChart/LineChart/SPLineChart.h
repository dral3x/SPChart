//
//  PNLineChart.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/14/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPChartCommon.h"
#import "SPChartDelegate.h"
#import "SPLineChartData.h"

@interface SPLineChart : UIView

/**
 * This method will call to draw the lines in animation
 */
- (void)drawChart;

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




/// @name Customization

/*
 When YES, the drawing of the chart will be animated. When NO, no animation will occure.
 Default YES
 */
@property (assign, nonatomic) BOOL animate;

/**
 Duration of the drawing animation. Default value is 1.0 second
 */
@property (nonatomic, assign) NSTimeInterval drawingDuration;

/**
 Margin between the canvas area and the full view.
 Axis are fitted inside left and bottom `chartMargin`.
 */
@property (nonatomic, assign) UIEdgeInsets chartMargin;




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




/// @name Empty chart

/**
 When the chart has no data to display (when `strokeChart`) is invoked, it will display this message (if not nil) in the center of the chart.
 @default nil
 */
@property (copy, nonatomic) NSString * emptyChartText;

- (BOOL)isEmpty;

/*
 emptyLabelFont will apply on the label that display `emptyChartText` message.
 Default nil, means the same as `labelFont`
 */
@property (nonatomic, strong) UIFont * emptyLabelFont;


/// @name Delegate

@property (nonatomic, weak) id<SPChartDelegate> delegate;


@end
