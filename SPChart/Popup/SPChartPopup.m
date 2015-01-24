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
    BOOL _bottomAnchor;
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
        _bottomAnchor = YES;
        
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
    
    CGContextSaveGState(context);
    
    if (_bottomAnchor) {
        [self _drawSquareInRect:rect context:context];
        [self _drawTriangleInRect:rect context:context];
    }
    else {
        [self _drawTriangleInRect:rect context:context];
        [self _drawSquareInRect:rect context:context];
    }

    CGContextRestoreGState(context);
}

- (void)_drawTriangleInRect:(CGRect)rect context:(CGContextRef)context
{
    // Draw triangle
    CGFloat triangleXPosition = CGRectGetMidX(rect) + _triangleXOffset;
    CGFloat triangleYBasePosition = (_bottomAnchor) ? CGRectGetMaxY(rect) - TRIANGLE_HEIGHT - EMPTY_SPACE_AROUND : TRIANGLE_HEIGHT + EMPTY_SPACE_AROUND;
    CGFloat triangleYPeakPosition = (_bottomAnchor) ? CGRectGetMaxY(rect) - EMPTY_SPACE_AROUND : EMPTY_SPACE_AROUND;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, triangleXPosition-TRIANGLE_WIDTH/2, triangleYBasePosition);
    CGContextAddLineToPoint(context, triangleXPosition, triangleYPeakPosition);
    CGContextAddLineToPoint(context, triangleXPosition+TRIANGLE_WIDTH/2, triangleYBasePosition);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)_drawSquareInRect:(CGRect)rect context:(CGContextRef)context
{
    CGFloat topGap = (_bottomAnchor) ? 0.0 : TRIANGLE_HEIGHT;
    CGFloat bottomGap = (_bottomAnchor) ? TRIANGLE_HEIGHT : 0.0;
    
    // Draw "rounded" background, with shadow
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, self.shadowColor.CGColor);
    UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x+EMPTY_SPACE_AROUND,
                                                                                    rect.origin.y+EMPTY_SPACE_AROUND+topGap,
                                                                                    rect.size.width-EMPTY_SPACE_AROUND*2,
                                                                                    rect.size.height-EMPTY_SPACE_AROUND*2-topGap-bottomGap)
                                                            cornerRadius:CORNERS_RADIUS];
    [roundedRect fill];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // contentView has to be in the center of the popup (not precisely centered anyway)
    CGFloat shift = (_bottomAnchor) ? - TRIANGLE_HEIGHT/2.0 : TRIANGLE_HEIGHT/2.0;
    self.contentView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) + shift);
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

- (void)_setAnchorPoint:(CGPoint)anchor bottomAnchor:(BOOL)bottomAnchor withGap:(CGFloat)gap
{
    CGPoint p = anchor;
    CGRect popupRect = self.bounds;
    CGRect containerRect = self.superview.bounds;
    
    // Keep popup inside container
    // Bound Y
    if (bottomAnchor) {
        if (p.y - CGRectGetHeight(popupRect) - gap < 0) {
            p.y = CGRectGetMidY(popupRect);
        }
        else {
            p.y -= CGRectGetMidY(popupRect) + gap;
        }
    }
    else {
        if (p.y + gap + CGRectGetHeight(popupRect) > CGRectGetHeight(containerRect)) {
            p.y = CGRectGetHeight(containerRect) - CGRectGetMidY(popupRect);
        }
        else {
            p.y += CGRectGetMidY(popupRect) + gap;
        }
    }
    
    // Bound X
    if (p.x - CGRectGetMidX(popupRect) < 0) {
        p.x = CGRectGetMidX(popupRect);
    }
    else if (p.x + CGRectGetMidX(popupRect) > CGRectGetMaxX(containerRect)) {
        p.x = CGRectGetMaxX(containerRect) - CGRectGetMidX(popupRect);
    }
    
    _triangleXOffset = anchor.x - p.x;
    _bottomAnchor = bottomAnchor;
    self.center = p;
}

- (void)showInView:(UIView *)superview
{
    [self showInView:superview withTopAnchorPoint:superview.center];
}

- (void)showInView:(UIView *)superview withTopAnchorPoint:(CGPoint)anchor
{
    [self showInView:superview withTopAnchorPoint:anchor andGap:yGapOverAnchorPoint];
}

- (void)showInView:(UIView *)superview withTopAnchorPoint:(CGPoint)anchor andGap:(CGFloat)anchorGap
{
    [self _showInView:superview withAnchorPoint:anchor andGap:anchorGap bottomAnchor:NO];
}

- (void)showInView:(UIView *)superview withBottomAnchorPoint:(CGPoint)anchor
{
    [self showInView:superview withBottomAnchorPoint:anchor andGap:yGapOverAnchorPoint];
}

- (void)showInView:(UIView *)superview withBottomAnchorPoint:(CGPoint)anchor andGap:(CGFloat)anchorGap
{
    [self _showInView:superview withAnchorPoint:anchor andGap:anchorGap bottomAnchor:YES];
}

- (void)_showInView:(UIView *)superview withAnchorPoint:(CGPoint)anchor andGap:(CGFloat)anchorGap bottomAnchor:(BOOL)bottomAnchor
{
    [self setAlpha:0.0f];
    [superview addSubview:self];
    [self _setAnchorPoint:anchor bottomAnchor:bottomAnchor withGap:anchorGap];
    
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
