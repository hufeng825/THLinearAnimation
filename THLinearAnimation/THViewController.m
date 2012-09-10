//
//  THViewController.m
//  CoreAnimationTest
//
//  Created by Huang Liang on 12-9-3.
//  Copyright (c) 2012年 iGrow. All rights reserved.
//

#import "THViewController.h"
#import "THBackgroundView.h"
#import "THLightView.h"

#define kRADIUS 10
#define kLightRedColor      [UIColor colorWithRed:1 green:0 blue:0 alpha:1]
#define kLightGreenColor    [UIColor colorWithRed:0 green:1 blue:0 alpha:1]
#define kLightYellowColor   [UIColor colorWithRed:1 green:238/255.0 blue:0 alpha:1]
#define kLightBlueColor     [UIColor colorWithRed:0 green:168/255.0 blue:1 alpha:1]

@interface THViewController ()

- (void)start;
- (void)update;
- (void)didTapGesture:(UITapGestureRecognizer *)gesture;
- (void)generateRandomLight;
- (void)createLightWithPoint:(CGPoint)point
                       color:(UIColor *)color
                   direction:(THLightViewDirection)direction;

- (void)updateLightsPoint;
- (void)removeOverflowLights;
- (void)updatePointWithLightView:(THLightView *)lightView;
- (void)removeOverflowLightView:(THLightView *)lightView;

- (NSInteger)randomWithMin:(NSInteger)min andMax:(NSInteger)max;
- (UIColor *)randomColor;
- (THLightViewDirection)randomDirection;
- (CGPoint)pointWithDirection:(THLightViewDirection)direction;

@end

@implementation THViewController

- (void)dealloc
{
    [animateTimer invalidate];
    [animateTimer release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setWantsFullScreenLayout:YES];
    [[self view] setFrame:[UIScreen mainScreen].bounds];
    
    THBackgroundView *backgroundView = [[THBackgroundView alloc] initWithFrame:self.view.bounds
                                                                     andRadius:kRADIUS];
    [self.view addSubview:backgroundView];
    [backgroundView release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(didTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    [self start];
    
//    [self createLightWithPoint:CGPointMake(0, 0) color:kLightBlueColor direction:kTHLightViewDirectionLeft];
//    [self createLightWithPoint:CGPointMake(180, 10) color:kLightGreenColor direction:kTHLightViewDirectionRight];
//    [self createLightWithPoint:CGPointMake(0, 20) color:kLightRedColor direction:kTHLightViewDirectionTop];
//    [self createLightWithPoint:CGPointMake(10, 200) color:kLightYellowColor direction:kTHLightViewDirectionButtom];
}

- (void)start
{
    animateTimer = [[NSTimer scheduledTimerWithTimeInterval:0.03
                                                     target:self
                                                   selector:@selector(update)
                                                   userInfo:nil
                                                    repeats:YES] retain];
}

- (void)update
{
    [self removeOverflowLights];
    [self updateLightsPoint];
    
    if (self.view.subviews.count < 5) {
        [self generateRandomLight];
    }
}

- (void)didTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [gesture locationInView:self.view];
        point.x = floor(point.x / kRADIUS) * kRADIUS;
        point.y = floor(point.y / kRADIUS) * kRADIUS;
        
        [self createLightWithPoint:point color:kLightBlueColor direction:kTHLightViewDirectionTop];
        [self createLightWithPoint:point color:kLightGreenColor direction:kTHLightViewDirectionButtom];
        [self createLightWithPoint:point color:kLightRedColor direction:kTHLightViewDirectionLeft];
        [self createLightWithPoint:point color:kLightYellowColor direction:kTHLightViewDirectionRight];
    }
}

- (void)generateRandomLight
{
    UIColor *color = [self randomColor];
    THLightViewDirection direction = [self randomDirection];
    CGPoint point = [self pointWithDirection:direction];
    
    [self createLightWithPoint:point color:color direction:direction];
}

- (void)createLightWithPoint:(CGPoint)point color:(UIColor *)color direction:(THLightViewDirection)direction
{
    THLightView *lightView = [[THLightView alloc] initWithPoint:point
                                                         radius:kRADIUS
                                                          color:color
                                                      direction:direction];
    [self.view addSubview:lightView];
    [lightView release];
    
}

- (void)updateLightsPoint
{
    NSArray *subviews = self.view.subviews;
    
    if (subviews.count > 1) {
        for (int i = 1; i < subviews.count; i++) {
            THLightView *lightView = (THLightView *)[subviews objectAtIndex:i];
            
            if ([lightView class] == [THLightView class]) {
                [self updatePointWithLightView:lightView];
            }
        }
    }
}

- (void)removeOverflowLights
{
    NSArray *subviews = self.view.subviews;
    
    if (subviews.count > 1) {
        for (int i = 1; i < subviews.count; i++) {
            THLightView *lightView = (THLightView *)[subviews objectAtIndex:i];
            
            if ([lightView class] == [THLightView class]) {
                [self removeOverflowLightView:lightView];
            }
        }
    }
}

- (void)updatePointWithLightView:(THLightView *)lightView
{
    CGPoint point = lightView.frame.origin;
    
    switch (lightView.direction) {
        case kTHLightViewDirectionTop:
            point.y -= kRADIUS;
            break;
        case kTHLightViewDirectionButtom:
            point.y += kRADIUS;
            break;
        case kTHLightViewDirectionLeft:
            point.x -= kRADIUS;
            break;
        case kTHLightViewDirectionRight:
            point.x += kRADIUS;
            break;
    }
    
    [lightView setPoint:point];
}

- (void)removeOverflowLightView:(THLightView *)lightView
{
    CGPoint point = lightView.frame.origin;
    CGSize size = lightView.frame.size;
    
    switch (lightView.direction) {
        case kTHLightViewDirectionTop:
            if (point.y <= -size.height) {
                [lightView removeFromSuperview];
            }
            break;
            
        case kTHLightViewDirectionButtom:
            if (point.y >= self.view.bounds.size.height+size.height) {
                [lightView removeFromSuperview];
            }
            break;
            
        case kTHLightViewDirectionLeft:
            if (point.x <= -size.width) {
                [lightView removeFromSuperview];
            }
            break;
            
        case kTHLightViewDirectionRight:
            if (point.x >= self.view.bounds.size.width+size.width) {
                [lightView removeFromSuperview];
            }
            break;
    }
}

- (NSInteger)randomWithMin:(NSInteger)min andMax:(NSInteger)max
{
    return arc4random()%(1+max-min)+min;
}

- (UIColor *)randomColor
{
    NSInteger number = [self randomWithMin:1 andMax:4];
    
    switch (number) {
        case 1:
            return kLightBlueColor;
        case 2:
            return kLightGreenColor;
        case 3:
            return kLightRedColor;
        case 4:
            return kLightYellowColor;
    }
    
    return nil;
}

- (THLightViewDirection)randomDirection
{
    NSInteger number = [self randomWithMin:1 andMax:4];
    
    switch (number) {
        case 1:
            return kTHLightViewDirectionTop;
        case 2:
            return kTHLightViewDirectionRight;
        case 3:
            return kTHLightViewDirectionLeft;
        case 4:
            return kTHLightViewDirectionButtom;
    }
    
    return kTHLightViewDirectionTop;
}

- (CGPoint)pointWithDirection:(THLightViewDirection)direction
{
    NSInteger lines = ceil(self.view.bounds.size.height / kRADIUS);
    NSInteger columns = ceil(self.view.bounds.size.width / kRADIUS);
    NSInteger temp;
    
    switch (direction) {
        case kTHLightViewDirectionTop:
            temp = [self randomWithMin:0 andMax:columns - 1];
            return CGPointMake(temp * kRADIUS, lines * kRADIUS);
            
        case kTHLightViewDirectionButtom:
            temp = [self randomWithMin:0 andMax:columns - 1];
            return CGPointMake(temp * kRADIUS, 0);
            
        case kTHLightViewDirectionLeft:
            temp = [self randomWithMin:0 andMax:lines - 1];
            return CGPointMake(columns * kRADIUS, temp * kRADIUS);
            
        case kTHLightViewDirectionRight:
            temp = [self randomWithMin:0 andMax:lines - 1];
            return CGPointMake(0, temp * kRADIUS);
    }
    
    return CGPointZero;
}

@end
