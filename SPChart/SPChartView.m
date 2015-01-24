//
//  SPChartView.m
//  SPChartDemo
//
//  Created by Alessandro Calzavara on 24/01/15.
//  Copyright (c) 2015 Alessandro Calzavara. All rights reserved.
//

#import "SPChartView.h"

@implementation SPChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    
    self.chartMargin = UIEdgeInsetsMake(40, 40, 40, 40);
    self.drawingDuration = 1.0;
    self.animate = YES;
}

- (void)drawChart
{
    // Subclasses should override this method.
}

- (BOOL)isEmpty
{
    // Subclass should override this method.
    return NO;
}

#pragma mark -
#pragma mark Resize detection

- (void)setBounds:(CGRect)newBounds
{
    BOOL isResize = !CGSizeEqualToSize(newBounds.size, self.bounds.size);
    
    [super setBounds:newBounds];
    
    if (isResize) {
        [self drawChart];
    }
}

@end
