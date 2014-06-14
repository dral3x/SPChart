//
//  SPChartPopup.m
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/14/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "SPChartPopup.h"

const CGFloat yGapOverAnchorPoint = 2.0f;
const NSTimeInterval visibilityAnimationDuration = 0.25f;

@implementation SPChartPopup
{
    CGFloat _triangleXOffset;
}

- (instancetype)initWithContentView:(UIView *)contentView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _contentView = contentView;
        
        // Applyes defaults
        _popupColor = ([self respondsToSelector:@selector(tintColor)]) ? self.tintColor : [UIColor lightGrayColor];
        _shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f]; // black with opacity to 25%
        _triangleXOffset = 0;
        _xPadding = 20.0f;
        _yPadding = 8.0f;
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;

        [self addSubview:contentView];
    }
    return self;
}

/*
 Renders the background of the popup, corners and the triangle
 */
- (void)drawRect:(CGRect)rect
{
#define EMPTY_SPACE_AROUND 2.0f
#define CORNERS_RADIUS 4.0f
#define TRIANGLE_HEIGHT 6.0f
#define TRIANGLE_WIDTH 8.0f
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.popupColor.CGColor);
    
    // Draw "rounded" background, with shadow
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, self.shadowColor.CGColor);
    UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x+EMPTY_SPACE_AROUND, rect.origin.y+EMPTY_SPACE_AROUND, rect.size.width-EMPTY_SPACE_AROUND*2, rect.size.height-TRIANGLE_HEIGHT-EMPTY_SPACE_AROUND*2)
                                                           cornerRadius:CORNERS_RADIUS];
    [roundedRect fill];
    
    
    // Draw triangle
    CGFloat triangleXPosition = CGRectGetMidX(rect) + _triangleXOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, triangleXPosition-TRIANGLE_WIDTH/2, CGRectGetMaxY(rect)-TRIANGLE_HEIGHT-EMPTY_SPACE_AROUND);
    CGContextAddLineToPoint(context, triangleXPosition, CGRectGetMaxY(rect)-EMPTY_SPACE_AROUND);
    CGContextAddLineToPoint(context, triangleXPosition+TRIANGLE_WIDTH/2, CGRectGetMaxY(rect)-TRIANGLE_HEIGHT-EMPTY_SPACE_AROUND);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // contentView has to be in the center of the popup (not precisely centered anyway)
    self.contentView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - TRIANGLE_HEIGHT/2);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    CGSize contentSize = [self.contentView intrinsicContentSize];
    return [self _popupSize:contentSize];
}

- (CGSize)_popupSize:(CGSize)contentSize
{
    CGSize size = contentSize;
    
    size.width += 2*self.xPadding;
    size.height += 2*self.yPadding + TRIANGLE_HEIGHT;
    
    return size;
}

- (void)setAnchorPoint:(CGPoint)anchor
{
    [self setAnchorPoint:anchor withGap:yGapOverAnchorPoint];
}

- (void)setAnchorPoint:(CGPoint)anchor withGap:(CGFloat)gap
{
    CGPoint p = anchor;
    CGRect popupRect = self.bounds;
    CGRect containerRect = self.superview.bounds;
    
    p.y -= CGRectGetMidY(popupRect) + gap;
    
    if (p.x - CGRectGetMidX(popupRect) < 0) {
        p.x = CGRectGetMidX(popupRect);
    } else if (p.x + CGRectGetMidX(popupRect) > CGRectGetMaxX(containerRect)) {
        p.x = CGRectGetMaxX(containerRect) - CGRectGetMidX(popupRect);
    }
    
    _triangleXOffset = anchor.x - p.x;
    self.center = p;
}

- (void)showInView:(UIView *)superview
{
    [self showInView:superview withAnchorPoint:superview.center];
}

- (void)showInView:(UIView *)superview withAnchorPoint:(CGPoint)anchor
{
    [self showInView:superview withAnchorPoint:anchor andGap:yGapOverAnchorPoint];
}

- (void)showInView:(UIView *)superview withAnchorPoint:(CGPoint)anchor andGap:(CGFloat)anchorGap
{
    [self setAlpha:0.0f];
    [superview addSubview:self];
    [self setAnchorPoint:anchor withGap:anchorGap];
    
    // Animation
    [self setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
    [UIView animateWithDuration:visibilityAnimationDuration animations:^{
        [self setAlpha:1.0f];
        [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    }];
}

- (void)dismiss
{
    // Animation
    [UIView animateWithDuration:visibilityAnimationDuration animations:^{
        [self setAlpha:0.0f];
        [self setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
