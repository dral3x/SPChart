//
//  SPChartUtil.h
//  SPChartDemo
//
//  Created by Alessandro Calzavara on 14/06/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPChartUtil : NSObject

+ (CGFloat)heightOfLabelWithFont:(UIFont *)font;

+ (void)layersCleanupWithCollection:(NSMutableArray *)array;
+ (void)viewsCleanupWithCollection:(NSMutableArray *)array;

@end
