//
//  SPBarData.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPBarChartData : NSObject

+ (instancetype)dataWithValue:(NSInteger)value
                        color:(UIColor *)color
                  description:(NSString *)description;

+ (instancetype)dataWithValues:(NSArray *)values
                        colors:(NSArray *)colors
                   description:(NSString *)description;

@property (nonatomic, strong, readonly) NSArray * values;
@property (nonatomic, strong, readonly) NSArray * colors;
@property (nonatomic, strong, readonly) NSString * dataDescription;

- (NSInteger)cumulatedValue;

@end
