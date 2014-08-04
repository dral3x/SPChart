//
//  SPPieChartData.m
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPPieChartData.h"

@interface SPPieChartData ()

@property (nonatomic, readwrite) NSInteger value;
@property (nonatomic, readwrite) UIColor * color;
@property (nonatomic, readwrite) NSString * dataDescription;

@end

@implementation SPPieChartData

+ (instancetype)dataWithValue:(NSInteger)value
                        color:(UIColor *)color
{
    return [self dataWithValue:value color:color description:nil];
}

+ (instancetype)dataWithValue:(NSInteger)value
                        color:(UIColor *)color
                  description:(NSString *)description
{
	SPPieChartData * data = [SPPieChartData new];
    data.value = value;
    data.color = color;
	data.dataDescription = description;
    
	return data;
}

@end
