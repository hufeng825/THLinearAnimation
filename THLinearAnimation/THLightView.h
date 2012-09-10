//
//  THLightView.h
//  CoreAnimationTest
//
//  Created by Huang Liang on 12-9-9.
//  Copyright (c) 2012年 iGrow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kTHLightViewDirectionLeft = 1,
    kTHLightViewDirectionRight,
    kTHLightViewDirectionTop,
    kTHLightViewDirectionButtom
} THLightViewDirection;

@interface THLightView : UIView
{
    UIColor *_color;
    CGFloat _radius;
}

- (id)initWithPoint:(CGPoint)point
             radius:(CGFloat)radius
              color:(UIColor *)color
          direction:(THLightViewDirection)direction;

@property (assign, nonatomic, readonly) THLightViewDirection direction;

- (void)setPoint:(CGPoint)point;

@end
