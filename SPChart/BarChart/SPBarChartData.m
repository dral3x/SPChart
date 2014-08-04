//
//  SPBarData.m
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPBarChartData.h"

@interface SPBarChartData ()

@property (nonatomic, strong, readwrite) NSArray * values;
@property (nonatomic, strong, readwrite) NSArray * colors;
@property (nonatomic, strong, readwrite) NSString * dataDescription;

@end

@implementation SPBarChartData

+ (instancetype)dataWithValue:(NSInteger)value
                        color:(UIColor *)color
                  description:(NSString *)description
{
    return [self dataWithValues:@[ @(value) ] colors:@[ color ] description:description];
}

+ (instancetype)dataWithValues:(NSArray *)values
                        colors:(NSArray *)colors
                   description:(NSString *)description
{
    NSAssert(values.count == colors.count, @"values and colors count must be the same");
    
    SPBarChartData * data = [SPBarChartData new];
    
    data.values = values;
    data.colors = colors;
    data.dataDescription = description;
    
    return data;
}

- (NSInteger)cumulatedValue
{
    return [[self.values valueForKeyPath:@"@sum.integerValue"] integerValue];
}

@end
