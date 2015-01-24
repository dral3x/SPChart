//
//  SPBar.m
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//


#import "SPBar.h"

@implementation SPBar
{
    NSMutableArray * _barLayers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    _barLayers = [NSMutableArray new];
    _upsideDown = NO;
    _animate = YES;
    
    self.clipsToBounds = YES;
    self.barRadius = 2.0f;
}

- (CAShapeLayer *)_createShapeLayer
{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.lineCap = kCALineCapButt;
    layer.fillColor = [[UIColor whiteColor] CGColor];
    layer.lineWidth = self.frame.size.width;
    layer.strokeEnd = 0.0;
    
    return layer;
}

- (void)setBarRadius:(CGFloat)barRadius
{
    _barRadius = barRadius;
    
    self.layer.cornerRadius = _barRadius;
}

- (void)_clearSublayers
{
    for (CAShapeLayer * layer in _barLayers) {
        [layer removeFromSuperlayer];
    }
    
    [_barLayers removeAllObjects];
}

- (void)strokeBar
{
    [self _clearSublayers];
    
    CGFloat gradeSum = 1.0;
    
    // Add lines (one above the other)
    for (NSUInteger index=0; index<self.grades.count; index++) {
        
        NSNumber * grade = self.grades[index];
        UIColor * color = self.barColors[index];
        
        gradeSum -= [grade doubleValue];
        
        UIBezierPath * segmentLine = [UIBezierPath bezierPath];
        [segmentLine setLineWidth:1.0];
        [segmentLine setLineCapStyle:kCGLineCapSquare];
        
        CGPoint topPoint = CGPointMake(self.frame.size.width / 2.0, gradeSum * self.frame.size.height);
        CGPoint bottomPoint = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height);
        
        [segmentLine moveToPoint:(self.upsideDown) ? topPoint : bottomPoint];
        [segmentLine addLineToPoint:(self.upsideDown) ? bottomPoint : topPoint];
        [segmentLine closePath];
        
        CAShapeLayer * layer = [self _createShapeLayer];
        layer.path = segmentLine.CGPath;
        layer.strokeColor = color.CGColor;
        
        if (self.animate) {
            CABasicAnimation * pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = self.drawingDuration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = @0.0f;
            pathAnimation.toValue = @1.0f;
            [layer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        }
        
        layer.strokeEnd = 1.0;
        
        [_barLayers addObject:layer];
        [self.layer insertSublayer:layer atIndex:0];
    }
}

- (void)layoutSubviews
{
    [self strokeBar];
}

@end
