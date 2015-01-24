//
//  SPChartView.h
//  SPChartDemo
//
//  Created by Alessandro Calzavara on 24/01/15.
//  Copyright (c) 2015 Alessandro Calzavara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPChartDelegate.h"

@interface SPChartView : UIView

- (void)_setup __attribute__((objc_requires_super));

/**
 Call this method to start drawing the chart, with the animation.
 */
- (void)drawChart;



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

/**
 Margin between the canvas area and the full view.
 Axis are fitted inside left and bottom `chartMargin`.
 */
@property (nonatomic, assign) UIEdgeInsets chartMargin;



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
