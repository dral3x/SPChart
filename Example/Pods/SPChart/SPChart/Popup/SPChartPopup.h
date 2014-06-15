//
//  SPChartPopup.h
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/14/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 It always stay inside the bounds of its superview (left and right side, at least!).
 */
@interface SPChartPopup : UIView

- (instancetype)initWithContentView:(UIView *)contentView;

@property (nonatomic, strong, readonly) UIView * contentView;

@property (nonatomic, copy) UIColor * popupColor;
@property (nonatomic, copy) UIColor * shadowColor;

@property (nonatomic, assign) CGFloat xPadding; // space added on top and bottom sides
@property (nonatomic, assign) CGFloat yPadding; // space added on left and right sides

- (void)setAnchorPoint:(CGPoint)point;
- (void)setAnchorPoint:(CGPoint)point withGap:(CGFloat)gap;

- (void)showInView:(UIView *)superview;
- (void)showInView:(UIView *)superview withAnchorPoint:(CGPoint)anchor;
- (void)showInView:(UIView *)superview withAnchorPoint:(CGPoint)anchor andGap:(CGFloat)anchorGap;

- (void)dismiss;

@end
