//
//  THBackgroundView.m
//  CoreAnimationTest
//
//  Created by Huang Liang on 12-9-9.
//  Copyright (c) 2012年 iGrow. All rights reserved.
//

#import "THBackgroundView.h"

#define kBackgroundColor [UIColor colorWithRed:47/255.0 green:54/255.0 blue:47/255.0 alpha:1]
#define kTopFillColor    [UIColor colorWithRed:93/255.0 green:101/255.0 blue:91/255.0 alpha:1]
#define kButtomFillColor [UIColor colorWithRed:33/255.0 green:39/255.0 blue:34/255.0 alpha:1]

@interface THBackgroundView ()

- (void)drawCellsWithContext:(CGContextRef)ctx;
- (void)drawCellWithContext:(CGContextRef)ctx startPoint:(CGPoint)point;
- (void)drawCellTopWithContext:(CGContextRef)ctx startPoint:(CGPoint)point;
- (void)drawCellButtomWithContext:(CGContextRef)ctx startPoint:(CGPoint)point;

@end

@implementation THBackgroundView

- (id)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius
{
    self = [super initWithFrame:frame];
    if (self) {
        _radius = radius;
        [self setBackgroundColor:kBackgroundColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawCellsWithContext:UIGraphicsGetCurrentContext()];
}

- (void)drawCellsWithContext:(CGContextRef)ctx
{
    int lines = ceil(self.bounds.size.height / _radius);
    int columns = ceil(self.bounds.size.width / _radius);
    
    for (int i = 0, l = lines * columns; i < l; i++) {
        [self drawCellWithContext:ctx startPoint:CGPointMake((i%columns)*_radius, (i/columns)*_radius)];
    }
}

- (void)drawCellWithContext:(CGContextRef)ctx startPoint:(CGPoint)point
{
    [self drawCellTopWithContext:ctx startPoint:point];
    [self drawCellButtomWithContext:ctx startPoint:point];
}

- (void)drawCellTopWithContext:(CGContextRef)ctx startPoint:(CGPoint)point
{
    CGContextSetFillColorWithColor(ctx, kTopFillColor.CGColor);
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextAddLineToPoint(ctx, point.x+_radius/2, point.y+_radius/2);
    CGContextAddLineToPoint(ctx, point.x+_radius, point.y);
    CGContextFillPath(ctx);
}

- (void)drawCellButtomWithContext:(CGContextRef)ctx startPoint:(CGPoint)point
{
    CGContextSetFillColorWithColor(ctx, kButtomFillColor.CGColor);
    CGContextMoveToPoint(ctx, point.x, point.y+_radius);
    CGContextAddLineToPoint(ctx, point.x+_radius/2, point.y+_radius/2);
    CGContextAddLineToPoint(ctx, point.x+_radius, point.y+_radius);
    CGContextFillPath(ctx);
}


@end
