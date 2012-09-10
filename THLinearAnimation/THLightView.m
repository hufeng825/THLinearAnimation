//
//  THLightView.m
//  CoreAnimationTest
//
//  Created by Huang Liang on 12-9-9.
//  Copyright (c) 2012年 iGrow. All rights reserved.
//

#import "THLightView.h"

#define kLIGHT_LENGTH 18

@interface THLightView ()

- (void)initPoint:(CGPoint)point;
- (void)drawHeadWithContext:(CGContextRef)ctx;
- (void)drawTailWithContext:(CGContextRef)ctx;
- (NSArray *)generateColors;
- (NSArray *)calculatePoints;
- (CGRect)calculateHeadRect;

@end

@implementation THLightView

@synthesize direction = _direction;

- (void)dealloc
{
    [_color release];
    [super dealloc];
}

- (id)initWithPoint:(CGPoint)point radius:(CGFloat)radius color:(UIColor *)color direction:(THLightViewDirection)direction
{
    self = [super init];
    if (self) {
        _direction = direction;
        _color = [color retain];
        _radius = radius;
        
        [self initPoint:point];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawTailWithContext:ctx];
    [self drawHeadWithContext:ctx];
}

- (void)setPoint:(CGPoint)point
{
    CGRect frame = self.frame;
    
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    
    [self setFrame:frame];
}

- (void)initPoint:(CGPoint)point
{
    CGRect frame = CGRectMake(point.x, point.y, _radius, _radius);
    
    switch (_direction) {
        case kTHLightViewDirectionTop:
            frame.size.height = _radius * kLIGHT_LENGTH;
            break;
            
        case kTHLightViewDirectionButtom:
            frame.size.height = _radius * kLIGHT_LENGTH;
            frame.origin.y -= frame.size.height;
            break;
            
        case kTHLightViewDirectionLeft:
            frame.size.width = _radius * kLIGHT_LENGTH;
            break;
            
        case kTHLightViewDirectionRight:
            frame.size.width = _radius * kLIGHT_LENGTH;
            frame.origin.x -= frame.size.width;
            break;
    }
    
    [self setFrame:frame];
}

- (void)drawHeadWithContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0,0), 10, _color.CGColor);
    CGContextSetFillColorWithColor(ctx, _color.CGColor);
    CGContextFillRect(ctx, [self calculateHeadRect]);
    CGContextRestoreGState(ctx);
}

- (void)drawTailWithContext:(CGContextRef)ctx
{
    NSArray *colors = [self generateColors];
    NSArray *points = [self calculatePoints];
    CGFloat location[] = {0,1};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, location);
    
    CGPoint startPoint = [[points objectAtIndex:0] CGPointValue];
    CGPoint endPoint = [[points objectAtIndex:1] CGPointValue];
    
    CGContextSaveGState(ctx);
    CGContextAddRect(ctx, self.bounds);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (NSArray *)generateColors
{
    const float *rgbs = CGColorGetComponents(_color.CGColor);
    
    UIColor *startColor = [UIColor colorWithRed:rgbs[0] green:rgbs[1] blue:rgbs[2] alpha:0.5];
    UIColor *endColor = [UIColor colorWithRed:rgbs[0] green:rgbs[1] blue:rgbs[2] alpha:0];
    
    return [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
}

- (NSArray *)calculatePoints
{
    CGPoint startPoint, endPoint;
    
    switch (_direction) {
        case kTHLightViewDirectionTop:
            startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
            endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
            break;
            
        case kTHLightViewDirectionButtom:
            startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
            endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
            break;
            
        case kTHLightViewDirectionLeft:
            startPoint = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds));
            endPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
            break;
            
        case kTHLightViewDirectionRight:
            startPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
            endPoint = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMidY(self.bounds));
            break;
    }
    
    return [NSArray arrayWithObjects:[NSValue valueWithCGPoint:startPoint],
                                     [NSValue valueWithCGPoint:endPoint], nil];
}

- (CGRect)calculateHeadRect
{
    CGRect frame = CGRectMake(0, 0, _radius, _radius);
    
    switch (_direction) {
        case kTHLightViewDirectionTop:
        case kTHLightViewDirectionLeft:
            break;
    
        case kTHLightViewDirectionButtom:
            frame.origin.y = self.frame.size.height - _radius;
            break;
            
        case kTHLightViewDirectionRight:
            frame.origin.x = self.frame.size.width - _radius;
            break;
    }
    
    return frame;
}


@end
