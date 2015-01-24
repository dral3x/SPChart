//
//  SPPieChart.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPChartView.h"


/**
 `SPPieChart` is, as the name could suggest, a pie chart.
 
 You can eather instanciate a new `SPPieChart` using `initWithFrame:` or
 prepare it in xib/storyboard files.
 
 Typically, you should create an array of `SPPieChartData` and set it in `items`.
 Than you can adjust any properties you like and, at the end, call `drawChart`
 to see the chart appears with a nice animation.
 
 ## Empty chart
 If the chart is empty, `emptyChartText` will be display in the middle of it.
 */
@interface SPPieChart : SPChartView

/**
 Contains all the `SPPieChartData` objects used for drawing the chart.
 */
@property (nonatomic, strong) NSArray * datas;



/// @name Customization

/**
 Minimum empty space between the pie and the edges of the view.
 Default is 40.0f
 */
@property (nonatomic, assign) CGFloat outerMargin;

/**
 Radius of the hole in the center of the chart.
 Default is 0.0f
 */
@property (nonatomic, assign) CGFloat innerMargin;

/**
 Font used for all labels in the chart
 */
@property (nonatomic, copy) UIFont * descriptionTextFont;

/**
 Color used for all labels text in the chart.
 */
@property (nonatomic, copy) UIColor * descriptionTextColor;

/**
 Offset from the chart outer border.
 Positive value will put labels outside, negative will put them inside the chart.
 */
@property (nonatomic, assign) CGFloat descriptionLabelOffset;

/**
 Use description from `SPPieChartData` object, when possible.
 Default is NO
 */
@property (nonatomic, assign) BOOL preferDataDescription;

/**
 Prevent the drawing of text around the chart.
 Default NO
 */
@property (nonatomic, assign) BOOL hideDescriptionTexts;

/**
 Set the drawing start angle, in radiant. If `randomInitialAngle` is YES, this property is ignored.
 Default M_PI_2
 */
@property (nonatomic, assign) CGFloat initialAngle;

/**
 Turns on or off the random starting angle feature.
 Default YES
 */
@property (nonatomic, assign) BOOL randomInitialAngle;



/// @name Highlighting a piece of the pie

/**
 When set, that piece of the chart will be highlighted.
 */
@property (nonatomic, assign) NSInteger hightlightedItem;

/**
 Reset the highlighted state of the chart. No piece will be highlighted.
 */
- (void)resetHightlightedItem;

@end
