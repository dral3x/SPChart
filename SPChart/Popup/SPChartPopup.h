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

@property (strong, nonatomic, readonly) UIView * contentView;

@property (copy, nonatomic) UIColor * popupColor;
@property (copy, nonatomic) UIColor * shadowColor;

@property (assign, nonatomic) CGFloat xPadding; // space added on top and bottom sides
@property (assign, nonatomic) CGFloat yPadding; // space added on left and right sides

- (void)showInView:(UIView *)superview;
- (void)showInView:(UIView *)superview withBottomAnchorPoint:(CGPoint)anchor;
- (void)showInView:(UIView *)superview withBottomAnchorPoint:(CGPoint)anchor andGap:(CGFloat)anchorGap;
- (void)showInView:(UIView *)superview withTopAnchorPoint:(CGPoint)anchor;
- (void)showInView:(UIView *)superview withTopAnchorPoint:(CGPoint)anchor andGap:(CGFloat)anchorGap;

- (void)dismiss;

@end
