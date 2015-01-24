//
//  SPBarChart.m
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPBarChart.h"
#import "SPBarChartData.h"

#import "SPChartUtil.h"

const CGFloat spBarChartXLabelMargin = 15.0;
const CGFloat spBarChartYLabelMargin = 8.0;

@implementation SPBarChart
{
    NSMutableArray * _labels;
    NSMutableArray * _bars;
    NSMutableArray * _lines;
    
    //
    CGFloat _barXSpace;
}

- (void)_setup
{
    [super _setup];
    
    self.yLabelFormatter = ^NSString *(NSInteger dataValue) {
        return [NSString stringWithFormat:@"%ld", (long)dataValue];
    };
    self.barValueFormatter = ^NSString *(NSInteger dataValue) {
        return [NSString stringWithFormat:@"%ld", (long)dataValue];
    };
    
    _datas = [NSArray new];
    _maxDataValue = 10;
    
    // Labels
    _labels = [NSMutableArray new];
    _barBackgroundColor = [UIColor clearColor];
    _labelTextColor = [UIColor grayColor];
    _labelFont = [UIFont systemFontOfSize:11.0f];
    self.xLabelSkip = 1;
    self.yLabelCount = 4;
    self.showXLabels = YES;
    self.showYLabels = YES;
    
    // Bars
    _bars = [NSMutableArray new];
    _barRadius = 2.0f;
    
    // Axis lines
    _lines = [NSMutableArray new];
    self.axisColor = [UIColor lightGrayColor];
    self.showAxis = NO;
    
    // Section lines
    self.sectionLinesColor = [UIColor lightGrayColor];
    self.showSectionLines = NO;
}

- (CAShapeLayer *)_createShapeLayer
{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.lineCap = kCALineCapButt;
    layer.fillColor = [[UIColor whiteColor] CGColor];
    layer.lineWidth = 1.0;
    layer.strokeEnd = 0.0;
    
    return layer;
}

- (void)setDatas:(NSArray *)datas
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    for (id data in datas) {
        NSAssert([data isKindOfClass:[SPBarChartData class]], @"Invalid data object. Array must contain only SPBarChartData instances");
    }
#pragma clang diagnostic pop
    
    _datas = datas;
    
    // Update maxDataValue
    for (SPBarChartData * data in datas) {
        self.maxDataValue = MAX(self.maxDataValue, data.cumulatedValue);
    }
}

- (void)drawChart
{
    // Cleanup
    [SPChartUtil viewsCleanupWithCollection:_labels];
    [SPChartUtil viewsCleanupWithCollection:_bars];
    [SPChartUtil layersCleanupWithCollection:_lines];
    
    // Recalculate some data
    _barXSpace = (self.frame.size.width - self.chartMargin.left - self.chartMargin.right) / [self.datas count];
    
    // Add Labels
    if (self.showXLabels) {
        [self _strokeXLabels];
    }
    if (self.showYLabels) {
        [self _strokeYLabels];
    }
    
    BOOL isChartEmpty = [self isEmpty] && self.emptyChartText != nil;
    
    // Add background lines
    if (self.showSectionLines && !isChartEmpty) {
        [self _strokeSectionLines];
    }
    
    // Add bars
    if (isChartEmpty) {
        [self _strokeEmptyLabel];
    } else {
        [self _strokeBars];
    }
    
    // Add chart border lines
    if (self.showAxis) {
        [self _strokeAxis];
    }
}

- (void)_strokeXLabels
{
    CGFloat yCenter = (!self.upsideDown) ? CGRectGetHeight(self.frame) - self.chartMargin.bottom/2.0 : self.chartMargin.top/2.0;
    
    int labelAddCount = 0;
    for (int index = 0; index < self.datas.count; index++) {
        labelAddCount += 1;
        
        if (labelAddCount == _xLabelSkip) {
            SPBarChartData * data = self.datas[index];
            NSString * labelText = data.dataDescription;
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setFont:_labelFont];
            [label setTextColor:_labelTextColor];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:labelText];
            [label sizeToFit];
            
            CGFloat labelXPosition  = (index *  _barXSpace + self.chartMargin.left + _barXSpace /2.0 );
            
            label.center = CGPointMake(
                                       labelXPosition,
                                       yCenter
                                       );
            labelAddCount = 0;
            
            [_labels addObject:label];
            [self addSubview:label];
        }
    }
}

- (void)_strokeYLabels
{
    CGFloat yLabelSectionHeight = (self.frame.size.height - self.chartMargin.top - self.chartMargin.bottom) / self.yLabelCount;
    CGFloat yLabelHeight = ceilf([SPChartUtil heightOfLabelWithFont:self.labelFont]);
    
    for (NSInteger index = 0; index < self.yLabelCount; index++) {
        
        NSInteger labelIndex = (!self.upsideDown) ? (self.yLabelCount - index) : index + 1;
        NSString * labelText = _yLabelFormatter((float)self.maxDataValue * ( labelIndex / (float)self.yLabelCount ));
        CGFloat y = (!self.upsideDown) ? yLabelSectionHeight * index + self.chartMargin.top - yLabelHeight/2.0 :
                                         yLabelSectionHeight * (index + 1) + self.chartMargin.top - yLabelHeight/2.0;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    spBarChartYLabelMargin,
                                                                    y,
                                                                    self.chartMargin.left - spBarChartYLabelMargin*2,
                                                                    yLabelHeight
                                                                    )];
        [label setFont:self.labelFont];
        [label setTextColor:self.labelTextColor];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:labelText];
        
        [_labels addObject:label];
        [self addSubview:label];
        
    }
}

- (void)_strokeSectionLines
{
    // Horizontal lines, aligned with Y labels
    
    float yLabelSectionHeight = (self.frame.size.height - self.chartMargin.top - self.chartMargin.bottom) / self.yLabelCount;
    
    for (int index = 0; index < self.yLabelCount; index++) {
        
        CAShapeLayer * lineLayer = [self _createShapeLayer];
        lineLayer.opacity = 0.85;
        
        UIBezierPath * linePath = [UIBezierPath bezierPath];
        
        CGFloat y = (!self.upsideDown) ? yLabelSectionHeight * index + self.chartMargin.top : yLabelSectionHeight * (index + 1) + self.chartMargin.bottom;
        [linePath moveToPoint:CGPointMake(self.chartMargin.left, y)];
        [linePath addLineToPoint:CGPointMake(self.frame.size.width - self.chartMargin.right, y)];
        
        [linePath setLineWidth:1.0];
        [linePath setLineCapStyle:kCGLineCapSquare];
        
        lineLayer.path = linePath.CGPath;
        lineLayer.strokeColor = self.sectionLinesColor.CGColor;
        lineLayer.lineJoin = kCALineJoinMiter;
        lineLayer.lineDashPattern = @[ @4, @2 ];
        lineLayer.lineDashPhase = 4.0f;
        
        // Animate
        if (self.animate) {
            CABasicAnimation * pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = self.drawingDuration/2.0;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = @0.0f;
            pathAnimation.toValue = @1.0f;
            [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        }
        
        lineLayer.strokeEnd = 1.0;
        
        [_lines addObject:lineLayer];
        [self.layer addSublayer:lineLayer];
    }
}

- (void)_strokeBars
{
    CGFloat chartCavanHeight = self.frame.size.height - self.chartMargin.top - self.chartMargin.bottom;
    
    [self.datas enumerateObjectsUsingBlock:^(SPBarChartData * data, NSUInteger index, BOOL *stop) {
        
        CGFloat barHeightScale = [self _scaleFactorOfBarWithData:data maxValue:self.maxDataValue]; // 0 .. 1
        
        CGFloat barWidth = (self.barWidth > 0) ? self.barWidth : _barXSpace * 0.75; // fixed width : dynamic width
        CGFloat barHeight = chartCavanHeight * barHeightScale;
        
        CGFloat barXPosition = barXPosition = self.chartMargin.left + index * _barXSpace + (_barXSpace - barWidth)/2.0;
        CGFloat barYPosition = self.chartMargin.top + (!self.upsideDown ? chartCavanHeight * (1.0f - barHeightScale) : 0.0);
        
        
        SPBar * bar = [[SPBar alloc] initWithFrame:CGRectMake(barXPosition, barYPosition, barWidth, barHeight)];
        
        // Set generic style info for the bar
        bar.barRadius = self.barRadius;
        bar.backgroundColor = self.barBackgroundColor;
        
        // Set data and colors
        bar.grades = [self _scaleData:data];
        bar.barColors = data.colors;
        
        // Set animation options
        bar.upsideDown = self.upsideDown;
        bar.animate = self.animate;
        bar.drawingDuration = self.drawingDuration;
        
        // For click index, set the tag id
        bar.tag = index;
        
        [_bars addObject:bar];
        [self addSubview:bar];
        
        // Bar labels
        if (self.showBarValues) {
            
            NSString * labelText = self.barValueFormatter((float)[data cumulatedValue]);
            CGSize labelSize = [SPChartUtil sizeOfLabelWithText:labelText font:self.labelFont];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                        CGRectGetMinX(bar.frame) + (barWidth - labelSize.width)/2.0,
                                                                        (self.upsideDown) ? CGRectGetMaxY(bar.frame) : CGRectGetMinY(bar.frame) - labelSize.height,
                                                                        labelSize.width,
                                                                        labelSize.height
                                                                        )];
            [label setFont:self.labelFont];
            [label setTextColor:(self.barValueTextColor) ? : self.labelTextColor];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:labelText];
            
            [_labels addObject:label];
            [self addSubview:label];
        }
        
    }];
}

- (void)_strokeAxis
{
    CAShapeLayer * bottomLine = [self _createShapeLayer];
    
    UIBezierPath * progressline = [UIBezierPath bezierPath];
    
    CGFloat bottomY = (!self.upsideDown) ? self.frame.size.height - self.chartMargin.bottom : self.chartMargin.top;
    
    [progressline moveToPoint:CGPointMake(self.chartMargin.left, bottomY)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width - self.chartMargin.right, bottomY)];
    
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    
    bottomLine.path = progressline.CGPath;
    bottomLine.strokeColor = self.axisColor.CGColor;
    
    if (self.animate) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.drawingDuration/2.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [bottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
    
    bottomLine.strokeEnd = 1.0;
    
    [_lines addObject:bottomLine];
    [self.layer addSublayer:bottomLine];
    
    
    // Add left Chart Line
    
    CAShapeLayer * leftLine = [self _createShapeLayer];
    
    UIBezierPath * progressLeftline = [UIBezierPath bezierPath];
    
    CGFloat leftStartY = (!self.upsideDown) ? self.frame.size.height - self.chartMargin.bottom : self.chartMargin.top;
    CGFloat leftEndY = (!self.upsideDown) ? self.chartMargin.top/2 : self.frame.size.height - self.chartMargin.bottom/2.0;
    
    [progressLeftline moveToPoint:CGPointMake(self.chartMargin.left, leftStartY)];
    [progressLeftline addLineToPoint:CGPointMake(self.chartMargin.left, leftEndY)];
    
    [progressLeftline setLineWidth:1.0];
    [progressLeftline setLineCapStyle:kCGLineCapSquare];
    
    leftLine.path = progressLeftline.CGPath;
    leftLine.strokeColor = self.axisColor.CGColor;
    
    if (self.animate) {
        CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathLeftAnimation.duration = self.drawingDuration/2.0;
        pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathLeftAnimation.fromValue = @0.0f;
        pathLeftAnimation.toValue = @1.0f;
        [leftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];
    }
    
    leftLine.strokeEnd = 1.0;
    
    [_lines addObject:leftLine];
    [self.layer addSublayer:leftLine];
}

- (NSArray *)_scaleData:(SPBarChartData *)data
{
    CGFloat max = (data.cumulatedValue > 0) ? data.cumulatedValue : 1.0f; // Avoid NaN issue on `scaled` number
    
    NSMutableArray * scaledData = [NSMutableArray new];
    
    for (NSNumber * singleValue in data.values) {
        NSNumber * scaled = @( [singleValue floatValue] / max );
        [scaledData addObject:scaled];
    }
    
    return scaledData;
}

- (CGFloat)_scaleFactorOfBarWithData:(SPBarChartData *)data maxValue:(NSInteger)maxValue
{
    return (float)data.cumulatedValue / (float)maxValue;
}

#pragma mark -
#pragma mark Emptyness

- (BOOL)isEmpty
{
    __block BOOL empty = YES;
    
    [self.datas enumerateObjectsUsingBlock:^(SPBarChartData * data, NSUInteger idx, BOOL *stop) {
        
        empty = (data.cumulatedValue == 0);
        *stop = !empty;
        
    }];
    
    return empty;
}

- (void)_strokeEmptyLabel
{
    if (self.emptyChartText == nil) {
        return;
    }
    
    const CGFloat gap = 10.0f;
    
    CGFloat labelWidth = CGRectGetWidth(self.frame) - self.chartMargin.left - self.chartMargin.right - 2*gap;
    CGFloat labelHeight = CGRectGetHeight(self.frame) - self.chartMargin.top - self.chartMargin.bottom - 2*gap;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                self.chartMargin.left + gap,
                                                                self.chartMargin.top + gap,
                                                                labelWidth,
                                                                labelHeight
                                                                )];
    [label setFont:(self.emptyLabelFont) ? : self.labelFont];
    [label setTextColor:self.labelTextColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:0];
    [label setText:self.emptyChartText];
    
    [_labels addObject:label];
    [self addSubview:label];
}

#pragma mark -
#pragma mark Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Get the point user touched
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView * subview = [self hitTest:touchPoint withEvent:nil];
    
    if ([subview isKindOfClass:[SPBar class]]) {
        if ([self.delegate respondsToSelector:@selector(SPChart:barSelected:barFrame:touchPoint:)]) {
            [self.delegate SPChart:self barSelected:subview.tag barFrame:subview.frame touchPoint:touchPoint];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(SPChartEmptySelection:)]) {
            [self.delegate SPChartEmptySelection:self];
        }
    }
}

@end
