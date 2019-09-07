//
//  Rectangle.m
//  Canvas
//
//  Created by Anton Grishuk on 9/2/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "Rectangle.h"

@interface Rectangle ()

@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, assign) CGPoint finishPoint;

@end

@implementation Rectangle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _finishPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        _anchorPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    return self;
}

- (instancetype)init:(CGRect)rect color:(UIColor *)color {
    self =  [super init:color];
    if (self) {
        _anchorPoint = rect.origin;
        _finishPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    }
    return self;
}

#pragma mark - Public

- (void)addPoint:(CGPoint)point {
    if (self.anchorPoint.x == CGFLOAT_MAX) {
        self.anchorPoint = point;
    }
    
    self.finishPoint = point;
}

- (UIBezierPath *)bezierPath {
    CGRect rect = [self frame];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    return path;
}

- (CGRect)frame {
    CGPoint startPoint = CGPointMake(MIN(self.anchorPoint.x, self.finishPoint.x),
                                  MIN(self.anchorPoint.y, self.finishPoint.y));
    
    CGPoint finishPoint = CGPointMake(MAX(self.anchorPoint.x, self.finishPoint.x),
                                   MAX(self.anchorPoint.y, self.finishPoint.y));
    
    return CGRectMake(startPoint.x, startPoint.y,
                      finishPoint.x - startPoint.x,
                      finishPoint.y - startPoint.y);
    
}

@end
