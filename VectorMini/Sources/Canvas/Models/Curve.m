//
//  Curve.m
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "Curve.h"
#import <UIColor+Hex.h>

@interface Curve () {
    NSUInteger _hexColor;
}

@property (nonatomic, assign) CGMutablePathRef path;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, assign, readwrite) NSUInteger hexColor;
@property (nonatomic, assign) BOOL begunDraw;

@end

@implementation Curve

#pragma mark - Initalizations and dellocation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _path = CGPathCreateMutable();
        _points = [NSMutableArray array];
        _hexColor = arc4random() % 0xFFFFFF;
    }
    return self;
}

- (instancetype)init:(NSArray *)points hexColor:(NSUInteger)hexColor {
    self = [self init];
    if (self) {
        _points = [NSMutableArray arrayWithArray:points];
        _hexColor = hexColor;
    }
    return self;
}

- (void)dealloc {
    CGPathRelease(_path);
}

- (void)setHexColor:(NSUInteger)hexColor {
    _hexColor = hexColor;
}

- (NSUInteger)hexColor {
    return _hexColor;
}

#pragma mark - Public

- (void)addPoint:(CGPoint)point {
    [self.points addObject:[NSValue valueWithCGPoint:point]];
    CGPathRef p = [self newPathWith:point];
    [self.delegate curvePathDidChange:p];
    CGPathRelease(p);
}

- (void)addLastPoint:(CGPoint)point {
    [self.points addObject:[NSValue valueWithCGPoint:point]];
    CGPathAddLineToPoint(self.path, nil, point.x, point.y);
    CGPathRef p = CGPathCreateCopy(self.path);
    [self.delegate curvePathDidFinished:p];
    CGPathRelease(p);
}

- (void)constructPathFromPoints:(NSArray *)points {
    self.begunDraw = NO;
    CGPathRelease(_path);
    self.path = CGPathCreateMutable();
    NSInteger count = points.count;
    CGMutablePathRef mutPath = CGPathCreateMutable();
    self.points = [NSMutableArray arrayWithArray:points];
    
    CGPoint firstPoint = [(NSValue *)points.firstObject CGPointValue];
    CGPathMoveToPoint(mutPath, nil, firstPoint.x, firstPoint.y);
    
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSValue.class]) {
            
            CGPoint point = [(NSValue *)obj CGPointValue];
            
            if (idx == count - 1) {
                CGPathAddLineToPoint(mutPath, nil, point.x, point.y);
            } else {
                CGPathRef p = [self newPathWith:point];
                CGPathAddPath(mutPath, nil, p);
                CGPathRelease(p);
            }
        }
    }];
    
    CGPathRef p = CGPathCreateCopy(mutPath);
    [self.delegate curvePathDidFinished:p];
    CGPathRelease(mutPath);
    CGPathRelease(p);

}

- (CGPathRef)newPath {
    [self constructPathFromPoints:self.points];
    return  CGPathCreateCopy(self.path);
}

- (NSArray *)getPoints {
    return  [NSArray arrayWithArray:self.points];
}

- (UIColor *)color {
    return [UIColor colorWithHex:self.hexColor];
}

#pragma mark - Private

- (CGPathRef)newPathWith:(CGPoint)point {
    
    if (self.begunDraw == NO) {
        CGPathMoveToPoint(self.path, nil, point.x, point.y);
        self.begunDraw = YES;
    }
    
    CGPathAddLineToPoint(self.path, nil, point.x, point.y);
    
    return CGPathCreateCopy(self.path);
}

@end
