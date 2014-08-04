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
    
    //
    CGFloat _barXSpace;
}

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

    self.chartMargin = UIEdgeInsetsMake(40, 40, 40, 40);
    
    self.yLabelFormatter = ^NSString *(NSInteger dataValue) {
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
    for (id data in datas) {
        NSAssert([data isKindOfClass:[SPBarChartData class]], @"Invalid data object. Array must contain only SPBarChartData instances");
    }
    
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
    
    // Recalculate some data
    _barXSpace = (self.frame.size.width - _chartMargin.left - _chartMargin.right) / [self.datas count];
    
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
    int labelAddCount = 0;
    for (int index = 0; index < self.datas.count; index++) {
        labelAddCount += 1;
        
        if (labelAddCount == _xLabelSkip) {
            SPBarChartData * data = self.datas[index];
            NSString * labelText = data.dataDescription;
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = _labelFont;
            label.textColor = _labelTextColor;
            [label setBackgroundColor:[UIColor clearColor]];
            label.text = labelText;
            [label sizeToFit];
            
            CGFloat labelXPosition  = (index *  _barXSpace + _chartMargin.left + _barXSpace /2.0 );
            
            label.center = CGPointMake(
                                       labelXPosition,
                                       self.frame.size.height - _chartMargin.bottom/2
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
    
    for (int index = 0; index < self.yLabelCount; index++) {
        
        NSString * labelText = _yLabelFormatter((float)self.maxDataValue * ( (self.yLabelCount - index) / (float)self.yLabelCount ));
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    spBarChartYLabelMargin,
                                                                    yLabelSectionHeight * index + _chartMargin.top - yLabelHeight/2.0,
                                                                    _chartMargin.left - spBarChartYLabelMargin*2,
                                                                    yLabelHeight
                                                                    )];
        label.font = _labelFont;
        label.textColor = _labelTextColor;
        [label setTextAlignment:NSTextAlignmentRight];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = labelText;
        
        [_labels addObject:label];
        [self addSubview:label];
        
    }
}

- (void)_strokeSectionLines
{
    // Horizontal lines, aligned with Y labels
    
    float yLabelSectionHeight = (self.frame.size.height - _chartMargin.top - _chartMargin.bottom) / self.yLabelCount;
    
    for (int index = 0; index < self.yLabelCount; index++) {
        
        CAShapeLayer * lineLayer = [self _createShapeLayer];
        lineLayer.opacity       = 0.85;
        
        UIBezierPath * linePath = [UIBezierPath bezierPath];
        
        CGFloat y = yLabelSectionHeight * index + _chartMargin.top;
        [linePath moveToPoint:CGPointMake(_chartMargin.left, y)];
        [linePath addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin.right, y)];
        
        [linePath setLineWidth:1.0];
        [linePath setLineCapStyle:kCGLineCapSquare];
        
        lineLayer.path = linePath.CGPath;
        lineLayer.strokeColor = self.sectionLinesColor.CGColor;
        lineLayer.lineJoin = kCALineJoinMiter;
        lineLayer.lineDashPattern = @[ @4, @2 ];
        lineLayer.lineDashPhase = 4.0f;
        
        // Animate
        CABasicAnimation * pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        lineLayer.strokeEnd = 1.0;
        
        [self.layer addSublayer:lineLayer];
    }
}

- (void)_strokeBars
{
    CGFloat chartCavanHeight = self.frame.size.height - _chartMargin.top - _chartMargin.bottom;
    
    [self.datas enumerateObjectsUsingBlock:^(SPBarChartData * data, NSUInteger index, BOOL *stop) {

        CGFloat barHeightScale = [self _scaleFactorOfBarWithData:data maxValue:self.maxDataValue]; // 0 .. 1
        
        CGFloat barWidth = (self.barWidth > 0) ? self.barWidth : _barXSpace * 0.75; // fixed width : dynamic width
        CGFloat barHeight = chartCavanHeight * barHeightScale;
        
        CGFloat barXPosition = barXPosition = _chartMargin.left + index * _barXSpace + (_barXSpace - barWidth)/2.0;
        CGFloat barYPosition = _chartMargin.top + chartCavanHeight * (1.0f - barHeightScale);
        
        
        SPBar * bar = [[SPBar alloc] initWithFrame:CGRectMake(barXPosition, barYPosition, barWidth, barHeight)];
        
        // Set generic style info for the bar
        bar.barRadius = self.barRadius;
        bar.backgroundColor = self.barBackgroundColor;
        
        // Set data and colors
        bar.grades = [self _scaleData:data];
        bar.barColors = data.colors;
        
        // For click index, set the tag id
        bar.tag = index;
        
        [_bars addObject:bar];
        [self addSubview:bar];
        
    }];
}

- (void)_strokeAxis
{
    CAShapeLayer * bottomLine = [self _createShapeLayer];
    
    UIBezierPath * progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(_chartMargin.left, self.frame.size.height - _chartMargin.bottom)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin.right, self.frame.size.height - _chartMargin.bottom)];

    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    
    bottomLine.path = progressline.CGPath;
    bottomLine.strokeColor = self.axisColor.CGColor;
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @1.0f;
    [bottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    bottomLine.strokeEnd = 1.0;
    
    [self.layer addSublayer:bottomLine];
    
    
    // Add left Chart Line
    
    CAShapeLayer * leftLine = [self _createShapeLayer];
    
    UIBezierPath * progressLeftline = [UIBezierPath bezierPath];
    
    [progressLeftline moveToPoint:CGPointMake(_chartMargin.left, self.frame.size.height - _chartMargin.bottom)];
    [progressLeftline addLineToPoint:CGPointMake(_chartMargin.left,  _chartMargin.top/2)];
    
    [progressLeftline setLineWidth:1.0];
    [progressLeftline setLineCapStyle:kCGLineCapSquare];

    leftLine.path = progressLeftline.CGPath;
    leftLine.strokeColor = self.axisColor.CGColor;
    
    
    CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathLeftAnimation.duration = 0.5;
    pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathLeftAnimation.fromValue = @0.0f;
    pathLeftAnimation.toValue = @1.0f;
    [leftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];
    
    leftLine.strokeEnd = 1.0;
    
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
    
    CGFloat labelWidth = self.frame.size.width - _chartMargin.left - _chartMargin.right - 2*gap;
    CGFloat labelHeight = self.frame.size.height - _chartMargin.top - _chartMargin.bottom - 2*gap;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                _chartMargin.left + gap,
                                                                _chartMargin.top + gap,
                                                                labelWidth,
                                                                labelHeight
                                                                )];
    label.font = _labelFont;
    label.textColor = _labelTextColor;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    label.numberOfLines = 0;
    label.text = self.emptyChartText;
    
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
    
    if ([subview isKindOfClass:[SPBar class]] && [self.delegate respondsToSelector:@selector(SPChartBarSelected:topPoint:touchPoint:)]) {
        [self.delegate SPChartBarSelected:subview.tag topPoint:CGPointMake(CGRectGetMidX(subview.frame), CGRectGetMinY(subview.frame)) touchPoint:touchPoint];
    }
}

@end
