//
//  Rectangle.m
//  Canvas
//
//  Created by Anton Grishuk on 9/2/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "Rectangle.h"
#import <UIColor+Hex.h>

@interface Rectangle () {
    NSUInteger _hexColor;
}

@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, assign) CGPoint finishPoint;
@property (nonatomic, assign, readwrite) NSUInteger hexColor;

@end

@implementation Rectangle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _finishPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        _anchorPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        _hexColor = arc4random() % 0xFFFFFF;
    }
    return self;
}

- (instancetype)init:(CGRect)rect hexColor:(NSUInteger)hexColor {
    self = [self init];
    if (self) {
        _anchorPoint = rect.origin;
        _finishPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        _hexColor = hexColor;
    }
    return self;
}

- (void)setHexColor:(NSUInteger)hexColor {
    _hexColor = hexColor;
}

- (NSUInteger)hexColor {
    return _hexColor;
}

#pragma mark - Public

- (void)addPoint:(CGPoint)point {
    if (self.anchorPoint.x == CGFLOAT_MAX) {
        self.anchorPoint = point;
    }
    
    self.finishPoint = point;
    
    CGRect rect = [self constructRect];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [self.delegate curvePathDidChange:path];
}

- (void)addLastPoint:(CGPoint)point {
    self.finishPoint = point;
    CGRect rect = [self constructRect];

     UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [self.delegate curvePathDidFinished:path];
}

- (UIBezierPath *)bezierPath {
    CGRect rect = [self constructRect];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    return path;
}

- (void)constructPathFromPoints:(NSArray *)points {
    
    if (points.count != 2) {
        return;
    }
    
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSValue.class]) {
            
            CGPoint point = [(NSValue *)obj CGPointValue];
            
            if (idx == 0) {
                self.anchorPoint = point;
            } else {
                self.finishPoint = point;
            }
        }
    }];
    
    UIBezierPath *p = [self bezierPath];;
    [self.delegate curvePathDidFinished:p];
}

- (UIColor *)color {
    return [UIColor colorWithHex: self.hexColor];
}

- (CGRect)getRect {
    return [self constructRect];
}

#pragma mark - Private

- (CGRect)constructRect {
    CGPoint startPoint = CGPointMake(MIN(self.anchorPoint.x, self.finishPoint.x),
                                  MIN(self.anchorPoint.y, self.finishPoint.y));
    
    CGPoint finishPoint = CGPointMake(MAX(self.anchorPoint.x, self.finishPoint.x),
                                   MAX(self.anchorPoint.y, self.finishPoint.y));
    
    return CGRectMake(startPoint.x, startPoint.y,
                      finishPoint.x - startPoint.x,
                      finishPoint.y - startPoint.y);
    
}

@end
