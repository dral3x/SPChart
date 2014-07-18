//
//  PNLineChart.m
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/14/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPLineChart.h"
#import "SPLineChartData.h"
#import "SPChartUtil.h"

const CGFloat spLineChartXLabelMargin = 15.0;
const CGFloat spLineChartYLabelMargin = 8.0;

@interface SPLineChart ()

@property (nonatomic, strong) NSMutableArray * labels;

@property (nonatomic, strong) NSMutableArray * chartLineArray;  // Array[CAShapeLayer]
@property (nonatomic, strong) NSMutableArray * chartPointArray; // Array[CAShapeLayer] save the point layer

@property (nonatomic, strong) NSMutableArray * linesPath;       // Array of line path, one for each line.
@property (nonatomic, strong) NSMutableArray * pointsPath;       // Array of point path, one for each line

@property (nonatomic, strong) NSMutableArray * touchablePoints;

@property (nonatomic, assign) CGFloat canvasHeight;
@property (nonatomic, assign) CGFloat canvasWidth;

@end


@implementation SPLineChart
{
    CGFloat _xLabelWidth;
}

#pragma mark initialization

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _setup];
    }
    return self;
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
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    
    self.chartLineArray = [NSMutableArray new];
    self.chartPointArray = [NSMutableArray new];
    self.linesPath = [NSMutableArray new];
    self.pointsPath = [NSMutableArray new];
    self.touchablePoints = [NSMutableArray new];
    
    self.labels = [NSMutableArray new];
    
    // Default customize properties
    
    self.yLabelFormatter = ^NSString *(NSInteger dataValue) {
        return [NSString stringWithFormat:@"%ld", (long)dataValue];
    };

    self.chartMargin = UIEdgeInsetsMake(40, 40, 40, 40);
    
    self.drawingDuration = 1.0f;
    
    // Axis lines
    self.showXAxis = YES;
    self.showYAxis = YES;
    self.axisColor = [UIColor lightGrayColor];
    
    self.showXLabels = YES;
    self.showYLabels = YES;
    self.labelTextColor = [UIColor grayColor];
    self.labelFont = [UIFont systemFontOfSize:11.0f];
    self.yLabelCount = 4;

    
    // Section lines
    self.sectionLinesColor = [UIColor lightGrayColor];
    self.showSectionLines = NO;
}

- (void)setDatas:(NSArray *)datas forXValues:(NSArray *)xValues
{
    [datas enumerateObjectsUsingBlock:^(SPLineChartData * data, NSUInteger idx, BOOL *stop) {
        NSAssert(data.values.count <= xValues.count, @"There is not enough labels compared to the data");
    }];
    
    _datas = datas;
    _xValues = xValues;
    
    // Calculate some data
    self.yMaxValue = 1;
    self.yMinValue = 0;
    [datas enumerateObjectsUsingBlock:^(SPLineChartData * data, NSUInteger idx, BOOL *stop) {
        self.yMaxValue = MAX(self.yMaxValue, data.maxValue);
    }];

    _xLabelWidth = floorf((CGRectGetWidth(self.frame) - self.chartMargin.left - self.chartMargin.right) / [xValues count]);
}

- (void)drawChart
{
    [self _recalculateCanvas];
    
    BOOL isChartEmpty = [self isEmpty] && self.emptyChartText != nil;
    
    // Add axis and labels
    if (self.showXAxis) {
        [self _strokeXAxis];
    }
    if (self.showXLabels) {
        [self _strokeXLabels];
    }
    if (self.showYAxis) {
        [self _strokeYAxis];
    }
    if (self.showYLabels) {
        [self _strokeYLabels];
    }
    
    // Add background lines
    if (self.showSectionLines && !isChartEmpty) {
        [self _strokeSectionLines];
    }
    
    // Add data lines
    if (isChartEmpty) {
        [self _strokeEmptyChartLabel];
    } else {
        for (SPLineChartData * data in self.datas) {
            [self _strokeLineAndPointsWithData:data];
        }
    }
}

- (BOOL)isEmpty
{
    __block BOOL empty = YES;
    
    [self.datas enumerateObjectsUsingBlock:^(SPLineChartData * data, NSUInteger idx, BOOL *stop) {
       
        empty = [data isEmpty];
        *stop = !empty;
        
    }];
    
    return empty;
}

- (void)_strokeEmptyChartLabel
{
    if (self.emptyChartText == nil) {
        return;
    }
    
    const CGFloat gap = 10.0f;
    
    CGFloat labelWidth = self.frame.size.width - _chartMargin.left - _chartMargin.right - 2*gap;
    CGFloat labelHeight = self.frame.size.height - _chartMargin.top - _chartMargin.bottom - 2*gap;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               _chartMargin.left + gap, // left
                                                               _chartMargin.top + gap, // top
                                                               labelWidth, // width
                                                               labelHeight // height
                                                               )];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:self.labelFont];
    [label setTextColor:self.labelTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setAccessibilityElementsHidden:YES];
    [label setText:self.emptyChartText];
    
    [self addSubview:label];
}

- (void)_strokeLineAndPointsWithData:(SPLineChartData *)chartData
{
    // Draw line
    CAShapeLayer * lineLayer = [self _createLineLayerWithLineWidth:chartData.lineWidth];
    [self.chartLineArray addObject:lineLayer];
    
    UIBezierPath * linePath = [UIBezierPath bezierPath];
    [linePath setLineWidth:chartData.lineWidth];
    [linePath setLineCapStyle:kCGLineCapRound];
    [linePath setLineJoinStyle:kCGLineJoinRound];
    [self.linesPath addObject:linePath];

    
    // Draw points
    CAShapeLayer * pointLayer = [self _createPointLayerWithLineWidth:chartData.lineWidth];
    [self.chartPointArray addObject:pointLayer];
    
    UIBezierPath * pointPath = [UIBezierPath bezierPath];
    [pointPath setLineWidth:chartData.lineWidth];
    [self.pointsPath addObject:pointPath];
    
    
    
    
    

    NSInteger yValue;
    CGFloat innerGrade;
    
    NSMutableArray *linePointsArray = [[NSMutableArray alloc] init];
    
    CGFloat last_x = 0;
    CGFloat last_y = 0;
    CGFloat inflexionWidth = chartData.pointWidth;
    
    for (NSUInteger i = 0; i < chartData.values.count; i++) {
        
        yValue = [chartData.values[i] integerValue];
        
        innerGrade = (CGFloat)(yValue - self.yMinValue) / (CGFloat)(self.yMaxValue - self.yMinValue);
        
        CGFloat x = self.chartMargin.left +  (i * _xLabelWidth) + _xLabelWidth/2;
        CGFloat y = self.chartMargin.top + self.canvasHeight - (innerGrade * self.canvasHeight);
        
        // cycle style point
        if (chartData.pointStyle == SPLineChartPointStyleCycle) {
            
            CGRect circleRect = CGRectMake(x-inflexionWidth/2, y-inflexionWidth/2, inflexionWidth,inflexionWidth);
            CGPoint circleCenter = CGPointMake(circleRect.origin.x + (circleRect.size.width / 2), circleRect.origin.y + (circleRect.size.height / 2));
            
            [pointPath moveToPoint:CGPointMake(circleCenter.x + (inflexionWidth/2), circleCenter.y)];
            [pointPath addArcWithCenter:circleCenter radius:inflexionWidth/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
            
            if ( i != 0 ) {
                
                // calculate the point for line
                float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
                float last_x1 = last_x + (inflexionWidth/2) / distance * (x-last_x);
                float last_y1 = last_y + (inflexionWidth/2) / distance * (y-last_y);
                float x1 = x - (inflexionWidth/2) / distance * (x-last_x);
                float y1 = y - (inflexionWidth/2) / distance * (y-last_y);
                
                [linePath moveToPoint:CGPointMake(last_x1, last_y1)];
                [linePath addLineToPoint:CGPointMake(x1, y1)];
            }
            
            last_x = x;
            last_y = y;
        }
        // Square style point
        else if (chartData.pointStyle == SPLineChartPointStyleSquare) {
            
            CGRect squareRect = CGRectMake(x-inflexionWidth/2, y-inflexionWidth/2, inflexionWidth,inflexionWidth);
            CGPoint squareCenter = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y + (squareRect.size.height / 2));
            
            [pointPath moveToPoint:CGPointMake(squareCenter.x - (inflexionWidth/2), squareCenter.y - (inflexionWidth/2))];
            [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth/2), squareCenter.y - (inflexionWidth/2))];
            [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth/2), squareCenter.y + (inflexionWidth/2))];
            [pointPath addLineToPoint:CGPointMake(squareCenter.x - (inflexionWidth/2), squareCenter.y + (inflexionWidth/2))];
            [pointPath closePath];
            
            if ( i != 0 ) {
                
                // calculate the point for line
                float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
                float last_x1 = last_x + (inflexionWidth/2);
                float last_y1 = last_y + (inflexionWidth/2) / distance * (y-last_y);
                float x1 = x - (inflexionWidth/2);
                float y1 = y - (inflexionWidth/2) / distance * (y-last_y);
                
                [linePath moveToPoint:CGPointMake(last_x1, last_y1)];
                [linePath addLineToPoint:CGPointMake(x1, y1)];
            }
            
            last_x = x;
            last_y = y;
        } else {
            
            if ( i != 0 ) {
                [linePath addLineToPoint:CGPointMake(x, y)];
            }
            
            [linePath moveToPoint:CGPointMake(x, y)];
        }
        
        [linePointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    
    [self.touchablePoints addObject:[linePointsArray copy]];
    

    lineLayer.path = linePath.CGPath;
    pointLayer.path = pointPath.CGPath;

    // setup the color of the chart line
    lineLayer.strokeColor = chartData.color.CGColor;
    pointLayer.strokeColor = chartData.color.CGColor;
    
    // Animates the drawing
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = self.drawingDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    animation.removedOnCompletion = YES;
    
    [lineLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    lineLayer.strokeEnd = 1.0;
    
    if (chartData.pointStyle != SPLineChartPointStyleNone) {
        [pointLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    }
    pointLayer.strokeEnd = 1.0;

    [self.layer addSublayer:pointLayer];
    [self.layer addSublayer:lineLayer];
}

- (CAShapeLayer *)_createLineLayerWithLineWidth:(CGFloat)lineWidth
{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.lineCap = kCALineCapButt;
    layer.lineJoin = kCALineJoinMiter;
    layer.fillColor = [[UIColor whiteColor] CGColor];
    layer.lineWidth = lineWidth;
    layer.strokeEnd = 0.0;
    
    return layer;
}

- (CAShapeLayer *)_createPointLayerWithLineWidth:(CGFloat)lineWidth
{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinBevel;
    layer.fillColor = nil;
    layer.lineWidth = lineWidth;
    layer.strokeEnd = 0.0;
    
    return layer;
}

- (void)_strokeXLabels
{
    [self.xValues enumerateObjectsUsingBlock:^(NSString * xValue, NSUInteger i, BOOL *stop) {
       
        CGFloat centerX = self.chartMargin.left + (i * _xLabelWidth) + _xLabelWidth/2;
        CGFloat centerY = self.frame.size.height - self.chartMargin.bottom/2;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setFont:self.labelFont];
        [label setTextColor:self.labelTextColor];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:xValue];
        [label sizeToFit];
        
        label.center = CGPointMake(centerX, centerY);
        
        [self.labels addObject:label];
        [self addSubview:label];
        
    }];
}

- (void)_strokeYLabels
{
    CGFloat yLabelSectionHeight = (self.frame.size.height - self.chartMargin.top - self.chartMargin.bottom) / self.yLabelCount;
    CGFloat yLabelHeight = ceilf([SPChartUtil heightOfLabelWithFont:self.labelFont]);
    
    for (int index = 0; index < self.yLabelCount; index++) {
        
        NSString * labelText = self.yLabelFormatter(ceilf((float)self.yMaxValue * (float)((self.yLabelCount - index) / (float)self.yLabelCount )));
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    spLineChartYLabelMargin,
                                                                    yLabelSectionHeight * index + self.chartMargin.top - yLabelHeight/2.0,
                                                                    self.chartMargin.left - spLineChartYLabelMargin*2,
                                                                    yLabelHeight
                                                                    )];
        label.font = _labelFont;
        label.textColor = _labelTextColor;
        [label setTextAlignment:NSTextAlignmentRight];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = labelText;
        
        [self.labels addObject:label];
        [self addSubview:label];
        
    }
}

- (void)_strokeSectionLines
{
    // Horizontal lines, aligned with Y labels
    
    float yLabelSectionHeight = (self.frame.size.height - self.chartMargin.top - self.chartMargin.bottom) / self.yLabelCount;
    
    for (int index = 0; index < self.yLabelCount; index++) {
        
        CAShapeLayer * lineLayer = [self _createLineLayerWithLineWidth:1.0f];
        lineLayer.opacity = 0.85;
        
        UIBezierPath * linePath = [UIBezierPath bezierPath];
        
        CGFloat y = yLabelSectionHeight * index + self.chartMargin.top;
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

- (void)_strokeXAxis
{
    CAShapeLayer * bottomLine = [self _createLineLayerWithLineWidth:1.0f];

    UIBezierPath * progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.chartMargin.left, self.frame.size.height - self.chartMargin.bottom)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin.right, self.frame.size.height - self.chartMargin.bottom)];
    
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    
    bottomLine.path = progressline.CGPath;
    bottomLine.strokeColor = self.axisColor.CGColor;
    
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    animation.removedOnCompletion = YES;
    [bottomLine addAnimation:animation forKey:@"strokeEndAnimation"];
    
    bottomLine.strokeEnd = 1.0;
    
    [self.layer addSublayer:bottomLine];
}

- (void)_strokeYAxis
{
    CAShapeLayer * leftLine = [self _createLineLayerWithLineWidth:1.0f];
    
    UIBezierPath * progressLeftline = [UIBezierPath bezierPath];
    
    [progressLeftline moveToPoint:CGPointMake(self.chartMargin.left, self.frame.size.height - self.chartMargin.bottom)];
    [progressLeftline addLineToPoint:CGPointMake(self.chartMargin.left,  self.chartMargin.top/2)];
    
    [progressLeftline setLineWidth:1.0];
    [progressLeftline setLineCapStyle:kCGLineCapSquare];
    
    leftLine.path = progressLeftline.CGPath;
    leftLine.strokeColor = self.axisColor.CGColor;
    
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    animation.removedOnCompletion = YES;
    [leftLine addAnimation:animation forKey:@"strokeEndAnimation"];
    
    leftLine.strokeEnd = 1.0;
    
    [self.layer addSublayer:leftLine];
}

- (void)_recalculateCanvas
{
    self.canvasWidth = self.frame.size.width - _chartMargin.left - _chartMargin.right;
    self.canvasHeight = self.frame.size.height - _chartMargin.top - _chartMargin.bottom;
}

#pragma mark -
#pragma mark Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Get the point user touched
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (NSInteger p = self.touchablePoints.count - 1; p >= 0; p--) {
        NSArray *linePointsArray = self.touchablePoints[p];
        
        for (int i = 0; i < linePointsArray.count - 1; i += 1) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];
            
            // Closest distance from point to line
            float distance = fabsf(((p2.x - p1.x) * (touchPoint.y - p1.y)) - ((p1.x - touchPoint.x) * (p1.y - p2.y)));
            distance /= hypot(p2.x - p1.x, p1.y - p2.y);
            
            if (distance <= 5.0) {
                // Conform to delegate parameters, figure out what bezier path this CGPoint belongs to.
                for (UIBezierPath *path in _linesPath) {
                    BOOL pointContainsPath = CGPathContainsPoint(path.CGPath, NULL, p1, NO);
                    
                    if (pointContainsPath) {
                        if ([self.delegate respondsToSelector:@selector(SPChartLineSelected:touchPoint:)]) {
                            [self.delegate SPChartLineSelected:[_linesPath indexOfObject:path] touchPoint:touchPoint];
                        }
                        return;
                    }
                }
            }
        }
    }
}

- (void)touchKeyPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (NSInteger p = self.touchablePoints.count - 1; p >= 0; p--) {
        NSArray *linePointsArray = self.touchablePoints[p];
        
        for (int i = 0; i < linePointsArray.count - 1; i += 1) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];
            
            float distanceToP1 = fabsf(hypot(touchPoint.x - p1.x, touchPoint.y - p1.y));
            float distanceToP2 = hypot(touchPoint.x - p2.x, touchPoint.y - p2.y);
            
            float distance = MIN(distanceToP1, distanceToP2);
            
            if (distance <= 22.0) { // magic number? it's half of 44, the min size Apple suggests for touchable areas
                if ([self.delegate respondsToSelector:@selector(SPChartLineKeyPointSelected:ofLine:keyPoint:touchPoint:)]) {
                    [self.delegate SPChartLineKeyPointSelected:(distance == distanceToP2 ? i + 1 : i)
                                                        ofLine:p
                                                      keyPoint:(distance == distanceToP2 ? p2 : p1)
                                                    touchPoint:touchPoint];
                }
                return;
            }
        }
    }
}

@end
