//
//  Curve.m
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "Curve.h"
#import <UIColor+Hex.h>
#import "UIBezierPath+Interpolation.h"

@interface Curve () {
    NSUInteger _hexColor;
}

@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, assign, readwrite) NSUInteger hexColor;

@end

@implementation Curve

#pragma mark - Initalizations and dellocation

- (instancetype)init
{
    self = [super init];
    if (self) {
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

- (void)setHexColor:(NSUInteger)hexColor {
    _hexColor = hexColor;
}

- (NSUInteger)hexColor {
    return _hexColor;
}

#pragma mark - Public

- (void)addPoint:(CGPoint)point {
    [self.points addObject:[NSValue valueWithCGPoint:point]];
    [self.delegate curvePathDidChange:[self bezierPath]];
}

- (void)addLastPoint:(CGPoint)point {
    [self.points addObject:[NSValue valueWithCGPoint:point]];
    [self.delegate curvePathDidFinished:[self bezierPath]];
}

- (void)constructPathFromPoints:(NSArray *)points {
    self.points = [NSMutableArray arrayWithArray:points];
    [self.delegate curvePathDidFinished:[self bezierPath]];
}

- (UIBezierPath *)bezierPath {
    UIBezierPath *path =  [UIBezierPath interpolateCGPointsWithHermite:self.points closed:NO];
    return path;
}

- (NSArray *)getPoints {
    return  [NSArray arrayWithArray:self.points];
}

- (UIColor *)color {
    return [UIColor colorWithHex:self.hexColor];
}

@end
