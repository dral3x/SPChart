//
//  SPChartUtil.m
//  SPChartDemo
//
//  Created by Alessandro Calzavara on 14/06/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPChartUtil.h"

@implementation SPChartUtil

+ (CGFloat)heightOfLabelWithFont:(UIFont *)font
{
    NSString * testString = @"Sample";
    if ([testString respondsToSelector:@selector(sizeWithAttributes:)]) {
        return [testString sizeWithAttributes:@{ NSFontAttributeName : font }].height;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // Fallback
    return [testString sizeWithFont:font].height;
#pragma clang diagnostic pop
}

+ (void)layersCleanupWithCollection:(NSMutableArray *)array
{
    [array makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [array removeAllObjects];
}

+ (void)viewsCleanupWithCollection:(NSMutableArray *)array
{
    [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [array removeAllObjects];
}

@end
