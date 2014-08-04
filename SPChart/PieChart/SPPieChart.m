//
//  SPPieChart.m
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/13/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPPieChart.h"
#import "SPPieChartData.h"

@interface SPPieChart ()

@property (nonatomic) CGFloat total;
@property (nonatomic) CGFloat currentTotal;
@property (nonatomic) CGFloat initialRotation; // in radiant

@property (nonatomic) CGFloat outterCircleRadius;
@property (nonatomic) CGFloat innerCircleRadius;

@property (nonatomic) UIView  * contentView;
@property (nonatomic, strong) CAShapeLayer * pieLayer;
@property (nonatomic, strong) NSMutableArray * descriptionLabels;
@property (nonatomic, strong) NSMutableArray * piecesLayers;

- (UILabel *)descriptionLabelForItemAtIndex:(NSUInteger)index;
- (SPPieChartData *)dataItemForIndex:(NSUInteger)index;

- (CAShapeLayer *)_createCircleLayerWithRadius:(CGFloat)radius
                                   borderWidth:(CGFloat)borderWidth
                                     fillColor:(UIColor *)fillColor
                                   borderColor:(UIColor *)borderColor
                               startPercentage:(CGFloat)startPercentage
                                 endPercentage:(CGFloat)endPercentage;

@end


@implementation SPPieChart

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        [self _setup];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    
    self.datas = [NSArray new]; // empty for the moment
    
    _outerMargin = 40.0f;
    _innerMargin = 0.0f;
    self.descriptionLabelOffset = -20.0f;
    
    self.descriptionTextColor = [UIColor darkGrayColor];
    self.descriptionTextFont = [UIFont systemFontOfSize:12.0];
    self.preferDataDescription = NO;
    self.hideDescriptionTexts = NO;
    
    self.drawingDuration = 1.0;
    
    self.initialAngle = 0.0;
    self.randomInitialAngle = YES;
    
    _hightlightedItem = -1;
    
    [self _recalculateRadius];
    [self _loadDefault];
}

- (void)_loadDefault
{
#define ARC4RANDOM_MAX      0x100000000
    
	_currentTotal = 0;
	_total = 0;
    
    /*
     The chart starts drawing from a random angle. Just for improve the looks of it
     */
    self.initialRotation = (self.randomInitialAngle) ? ((double)arc4random() / ARC4RANDOM_MAX) * M_PI * 2 : self.initialAngle;
	
	[_contentView removeFromSuperview];
	_contentView = [[UIView alloc] initWithFrame:self.bounds];
	[self addSubview:_contentView];
    [_descriptionLabels removeAllObjects];
	_descriptionLabels = [NSMutableArray new];
	
    [_piecesLayers removeAllObjects];
    _piecesLayers = [NSMutableArray new];
    
	_pieLayer = [CAShapeLayer layer];
	[_contentView.layer addSublayer:_pieLayer];
}

- (void)setInnerMargin:(CGFloat)innerMargin
{
    _innerMargin = innerMargin;
    
    [self _recalculateRadius];
}

- (void)setOuterMargin:(CGFloat)outerMargin
{
    _outerMargin = outerMargin;
    
    [self _recalculateRadius];
}

- (void)_recalculateRadius
{
    _outterCircleRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2 - self.outerMargin;
    _innerCircleRadius  = _innerMargin;
    
    _descriptionLabelOffset = -(_outterCircleRadius-_innerCircleRadius)/2.0f + 10.0f;
}

#pragma mark -

- (void)drawChart
{
	[self _recalculateDefaults];
	
    if (![self isEmpty]) {
        [self _drawSlices];
        [self _drawLabels];

    } else {
        [self _drawEmptyLabel];
    }
}

- (void)_drawSlices
{
	SPPieChartData * currentItem;
	CGFloat currentValue = 0;
	for (NSUInteger i = 0; i < self.datas.count; i++) {
		currentItem = [self dataItemForIndex:i];
		
		
		CGFloat start = currentValue / _total;
		CGFloat end = (currentValue + currentItem.value) / _total;
		
		CAShapeLayer * currentPieLayer = [self _createCircleLayerWithRadius:_innerCircleRadius + (_outterCircleRadius - _innerCircleRadius)/2
                                                                borderWidth:_outterCircleRadius - _innerCircleRadius
                                                                  fillColor:[UIColor clearColor]
                                                                borderColor:currentItem.color
                                                            startPercentage:start
                                                              endPercentage:end];
		[_pieLayer addSublayer:currentPieLayer];
        [self.piecesLayers addObject:currentPieLayer];
		
		currentValue += currentItem.value;
	}
	
	[self maskChart];
}

- (void)_drawLabels
{
    if (self.hideDescriptionTexts) {
        return;
    }
    
    SPPieChartData * currentItem;
	CGFloat currentValue = 0;
    
    for (int i = 0; i < self.datas.count; i++) {
		currentItem = [self dataItemForIndex:i];
		UILabel * descriptionLabel = [self descriptionLabelForItemAtIndex:i];
		[_contentView addSubview:descriptionLabel];
		currentValue += currentItem.value;
        [_descriptionLabels addObject:descriptionLabel];
	}
}

- (void)_drawEmptyLabel
{
    if (self.emptyChartText == nil) {
        return;
    }
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_outerMargin, _outerMargin, CGRectGetWidth(self.bounds) - 2*_outerMargin, CGRectGetHeight(self.bounds) - 2*_outerMargin)];
    [label setText:self.emptyChartText];
    [label setFont:self.descriptionTextFont];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:self.descriptionTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:0];
    
    [_contentView addSubview:label];
    [_descriptionLabels addObject:label];
}

- (void)_recalculateDefaults
{
    [self _loadDefault];
	
	[self.datas enumerateObjectsUsingBlock:^(SPPieChartData * data, NSUInteger idx, BOOL *stop) {
		_total += data.value;
	}];
}

- (BOOL)isEmpty
{
    __block BOOL empty = YES;
    [self.datas enumerateObjectsUsingBlock:^(SPPieChartData * data, NSUInteger idx, BOOL *stop) {
		empty = data.value < 0.0001;
        *stop = !empty;
	}];
    
    return empty;
}

- (UILabel *)descriptionLabelForItemAtIndex:(NSUInteger)index
{
	SPPieChartData * currentDataItem = [self dataItemForIndex:index];
    CGFloat distance = _outterCircleRadius + self.descriptionLabelOffset; // from the center of the chart
    CGFloat centerPercentage = (_currentTotal + currentDataItem.value / 2 ) / _total;
    CGFloat angle = centerPercentage * 2 * M_PI + self.initialRotation; // in radiant
    
	_currentTotal += currentDataItem.value;
	
    NSString * titleText = [NSString stringWithFormat:@"%.0f%%", currentDataItem.value / _total * 100];
    if (self.preferDataDescription && currentDataItem.description) {
        titleText = currentDataItem.dataDescription;
    }
    
    CGPoint center = CGPointMake(
                                 CGRectGetMidX(self.bounds) + distance * sin(angle),
                                 CGRectGetMidY(self.bounds) - distance * cos(angle)
                                 );
    
    UILabel * descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [descriptionLabel setText:titleText];
    [descriptionLabel setFont:self.descriptionTextFont];
    [descriptionLabel setTextColor:self.descriptionTextColor];
    [descriptionLabel setAlpha:0];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    
    [descriptionLabel sizeToFit];
    [descriptionLabel setCenter:center];
    [descriptionLabel setIsAccessibilityElement:NO];

	return descriptionLabel;
}

- (SPPieChartData *)dataItemForIndex:(NSUInteger)index
{
	return self.datas[index];
}

#pragma mark private methods

- (CAShapeLayer *)_createCircleLayerWithRadius:(CGFloat)radius
                                   borderWidth:(CGFloat)borderWidth
                                     fillColor:(UIColor *)fillColor
                                   borderColor:(UIColor *)borderColor
                               startPercentage:(CGFloat)startPercentage
                                 endPercentage:(CGFloat)endPercentage
{
	CAShapeLayer * circle = [CAShapeLayer layer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:radius
                                                     startAngle:-M_PI_2 + self.initialRotation
                                                       endAngle:M_PI_2 * 3 + self.initialRotation
                                                      clockwise:YES];
    
    circle.fillColor    = fillColor.CGColor;
    circle.strokeColor  = borderColor.CGColor;
    circle.strokeStart  = startPercentage;
    circle.strokeEnd    = endPercentage;
    circle.lineWidth    = borderWidth;
    circle.path         = path.CGPath;
    
	return circle;
}

/**
 Creates a layer mask for uncover the chart with an animation
 */
- (void)maskChart
{
	CAShapeLayer * maskLayer = [self _createCircleLayerWithRadius:_innerCircleRadius + (_outterCircleRadius - _innerCircleRadius)/2
                                                      borderWidth:_outterCircleRadius - _innerCircleRadius
                                                        fillColor:[UIColor clearColor]
                                                      borderColor:[UIColor blackColor]
                                                  startPercentage:0
                                                    endPercentage:1];
	_pieLayer.mask = maskLayer;
    
    // Animate the mask
	CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	animation.duration = self.drawingDuration;
	animation.fromValue = @0;
	animation.toValue = @1;
    animation.delegate = self; // to show labels at the end of this animation
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.removedOnCompletion = YES;
	[maskLayer addAnimation:animation forKey:@"circleAnimation"];
    
    // NOTE: At the end of this animation, labels will be shown
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // Remove mask used for presenting the chart (it's not need anymore)
    _pieLayer.mask = nil;
    
    // Show labels
    [self.descriptionLabels enumerateObjectsUsingBlock:^(UIView * label, NSUInteger idx, BOOL *stop) {
        
        [UIView animateWithDuration:0.2 animations:^{
            [label setAlpha:1];
        }];
        
    }];
}

- (void)setHightlightedItem:(NSInteger)itemIndex
{
    // Check for avoiding useless animation
    if (_hightlightedItem == itemIndex || [self isEmpty]) {
        return;
    }
    
    // Prepare animations
    const float fadeInOpacity = 1.0f;
    const float fadeOutOpacity = 0.20f;
    
    CABasicAnimation * fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.toValue = @(fadeInOpacity);
    fadeInAnimation.duration = 0.1;
    fadeInAnimation.removedOnCompletion = YES;
    
    CABasicAnimation * fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.toValue = @(fadeOutOpacity);
    fadeOutAnimation.duration = 0.3;
    fadeOutAnimation.removedOnCompletion = YES;
    
    // Apply the appropriate animation on every piece
    for (NSUInteger index=0; index<self.datas.count; index++) {
        
        CABasicAnimation * animation = (itemIndex < 0) ? fadeInAnimation : (index == itemIndex) ? fadeInAnimation : fadeOutAnimation;
        float finalOpacity = (itemIndex < 0) ? fadeInOpacity : (index == itemIndex) ? fadeInOpacity : fadeOutOpacity;
        
        CALayer * pieceLayer = self.piecesLayers[index];
        [pieceLayer addAnimation:animation forKey:@"opacityAnimation"];
        [pieceLayer setOpacity:finalOpacity];
        
        CALayer * labelLayer = [self.descriptionLabels[index] layer];
        [labelLayer addAnimation:animation forKey:@"opacityAnimation"];
        [labelLayer setOpacity:finalOpacity];
    }
    
    _hightlightedItem = itemIndex;
}

- (void)resetHightlightedItem
{
    // Check for avoid useless animation
    if ([self isEmpty]) {
        return;
    }
    
    self.hightlightedItem = -1;
}

#pragma mark -
#pragma mark Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    // IT DOES NOT WORK!
    /*
    // Get the point user touched
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"%@", NSStringFromCGPoint(touchPoint));
    
    [self.piecesLayers enumerateObjectsUsingBlock:^(CAShapeLayer * layer, NSUInteger idx, BOOL *stop) {
    
        if (CGPathContainsPoint(layer.path, NULL, touchPoint, NO)) {
            if ([self.delegate respondsToSelector:@selector(SPChartPiePieceSelected:)]) {
                [self.delegate SPChartPiePieceSelected:idx];
            }
            *stop = YES;
        }
        
    }];
    */
}

@end
