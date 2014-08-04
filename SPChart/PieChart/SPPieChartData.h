//
//  SPPieChartData.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPieChartData : NSObject

+ (instancetype)dataWithValue:(NSInteger)value
                        color:(UIColor *)color;

+ (instancetype)dataWithValue:(NSInteger)value
                        color:(UIColor *)color
                  description:(NSString *)description;

@property (nonatomic, assign, readonly) NSInteger value;
@property (nonatomic, copy, readonly) UIColor * color;
@property (nonatomic, copy, readonly) NSString * dataDescription;

@end
