//
//  SPChartDelegate.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPLineChart, SPBarChart, SPPieChart;

@protocol SPChartDelegate <NSObject>

@optional

/**
 Triggered when user clicks on a chart line
 */
- (void)SPChart:(SPLineChart *)chart lineSelected:(NSInteger)lineIndex touchPoint:(CGPoint)point;

/**
 Triggered when user click on the chart line key point
 */
- (void)SPChart:(SPLineChart *)chart lineKeyPointSelected:(NSInteger)pointIndex ofLine:(NSInteger)lineIndex keyPoint:(CGPoint)keyPoint touchPoint:(CGPoint)point;

/**
 Triggered when user click on a chart bar
 */
- (void)SPChart:(SPBarChart *)chart barSelected:(NSInteger)barIndex barFrame:(CGRect)barFrame touchPoint:(CGPoint)touchPoint;

/**
 Triggered when user click on a pie chart piece
 */
- (void)SPChart:(SPPieChart *)chart piePieceSelected:(NSInteger)pieceIndex;

/**
 Triggered when user click on no line/bar/piece
 */
- (void)SPChartEmptySelection:(id)chart;

@end