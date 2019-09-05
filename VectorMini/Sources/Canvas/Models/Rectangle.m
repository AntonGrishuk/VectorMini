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

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, assign) CGPoint finishPoint;
@property (nonatomic, assign, readwrite) NSUInteger hexColor;

@end

@implementation Rectangle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _startPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        _finishPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        _anchorPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        _hexColor = arc4random() % 0xFFFFFF;
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
    if (self.startPoint.x == CGFLOAT_MAX) {
        self.startPoint = point;
        self.anchorPoint = point;
    }
    
    self.finishPoint = point;
    
    CGRect rect = [self constructRect];
    CGPathRef path = CGPathCreateWithRect(rect, nil);
    [self.delegate curvePathDidChange:path];
    CGPathRelease(path);
}

- (void)addLastPoint:(CGPoint)point {
    self.finishPoint = point;
    CGRect rect = [self constructRect];
    CGPathRef path = CGPathCreateWithRect(rect, nil);
    [self.delegate curvePathDidFinished:path];
    CGPathRelease(path);
}

- (CGPathRef)newPath {
    CGRect rect = [self constructRect];
    CGPathRef path = CGPathCreateWithRect(rect, nil);
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
                self.startPoint = point;
                self.anchorPoint = point;
            } else {
                self.finishPoint = point;
            }
        }
    }];
    
    CGPathRef p = [self newPath];;
    [self.delegate curvePathDidFinished:p];
    CGPathRelease(p);
    
}

- (UIColor *)color {
    return [UIColor colorWithHex: self.hexColor];
}

- (CGRect)getRect {
    return [self constructRect];
}

#pragma mark - Private

- (CGRect)constructRect {
    self.startPoint = CGPointMake(MIN(self.anchorPoint.x, self.finishPoint.x),
                                  MIN(self.anchorPoint.y, self.finishPoint.y));
    
    self.finishPoint = CGPointMake(MAX(self.anchorPoint.x, self.finishPoint.x),
                                   MAX(self.anchorPoint.y, self.finishPoint.y));
    
    return CGRectMake(self.startPoint.x, self.startPoint.y,
                      self.finishPoint.x - self.startPoint.x,
                      self.finishPoint.y - self.startPoint.y);
    
}

@end
