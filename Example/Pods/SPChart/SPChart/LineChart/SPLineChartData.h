//
//  SPLineChartData.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/14/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SPLineChartPointStyle)
{
    SPLineChartPointStyleNone,
    SPLineChartPointStyleCycle,
    SPLineChartPointStyleSquare
};

@interface SPLineChartData : NSObject

+ (instancetype)dataWithValues:(NSArray *)values color:(UIColor *)color;
+ (instancetype)dataWithValues:(NSArray *)values color:(UIColor *)color pointStyle:(SPLineChartPointStyle)pointStyle;

@property (nonatomic, strong, readonly) NSArray * values;
@property (nonatomic, copy) UIColor *color;
@property (nonatomic, assign) SPLineChartPointStyle pointStyle;

/**
 If pointStyle is cycle, pointWidth equals cycle's diameter.
 If pointStyle is square, that means the foundation is square with pointWidth long.
 */
@property (nonatomic, assign) CGFloat pointWidth;

@property (nonatomic, assign) CGFloat lineWidth;

- (BOOL)isEmpty;

- (NSInteger)maxValue;

@end
