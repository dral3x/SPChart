//
//  SPChartDelegate.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPChartDelegate <NSObject>

@optional

/**
 Triggered when user clicks on a chart line
 */
- (void)SPChartLineSelected:(NSInteger)lineIndex touchPoint:(CGPoint)point;

/**
 Triggered when user click on the chart line key point
 */
- (void)SPChartLineKeyPointSelected:(NSInteger)pointIndex ofLine:(NSInteger)lineIndex keyPoint:(CGPoint)keyPoint touchPoint:(CGPoint)point;

/**
 Triggered when user click on a chart bar
 */
- (void)SPChartBarSelected:(NSInteger)barIndex topPoint:(CGPoint)topPoint touchPoint:(CGPoint)touchPoint;

/**
 Triggered when user click on a pie chart piece
 */
- (void)SPChartPiePieceSelected:(NSInteger)pieceIndex;

@end