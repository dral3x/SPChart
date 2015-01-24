//
//  SPBarChart.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPChartCommon.h"
#import "SPChartDelegate.h"
#import "SPBar.h"


/**
 `SPBarChart` is a bar chart (don't you say?).
 
 
 */
@interface SPBarChart : UIView

/**
 Call this method to start drawing the chart, with the animation.
 */
- (void)drawChart;

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
 When YES, the drawing of the chart will be animated. When NO, no animation will occure.
 Default YES
 */
@property (assign, nonatomic) BOOL animate;

/**
 Duration of the drawing animation. Default value is 1.0 second
 */
@property (nonatomic, assign) NSTimeInterval drawingDuration;

/*
 yLabelFormatter will format labels text on the Y axis
 */
@property (nonatomic, copy) SPChartLabelFormatter yLabelFormatter;

/*
 barValueFormatter will format labels text on the bars
 */
@property (nonatomic, copy) SPChartLabelFormatter barValueFormatter;

/**
 Margin between the canvas area and the full view.
 Axis are fitted inside left and bottom `chartMargin`.
 */
@property (nonatomic, assign) UIEdgeInsets chartMargin;

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




/// @name Empty chart

/**
 Returns YES if the sum of all the items are zero.
 */
- (BOOL)isEmpty;

/**
 When the chart has no data to display (when `drawChart`) is invoked, it will display this message (if not nil) in the center of the chart.
 Default is `nil`.
 */
@property (nonatomic, copy) NSString * emptyChartText;

/*
 emptyLabelFont will apply on the label that display `emptyChartText` message.
 Default nil, means the same as `labelFont`
 */
@property (nonatomic, strong) UIFont * emptyLabelFont;


/// @name Delegate

@property (nonatomic, weak) id<SPChartDelegate> delegate;


@end
