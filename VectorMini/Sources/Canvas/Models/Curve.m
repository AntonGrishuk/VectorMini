//
//  Curve.m
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "Curve.h"
#import "UIBezierPath+Interpolation.h"

@interface Curve ()

@property (nonatomic, strong, readwrite) NSMutableArray *points;

@end

@implementation Curve

#pragma mark - Initalizations and dellocation

- (instancetype)init {
    self = [super init];
    if (self) {
        _points = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init:(NSArray *)points color:(UIColor *)color {
    self = [super init:color];
    if (self) {
        _points = [NSMutableArray arrayWithArray:points];
    }
    return self;
}

#pragma mark - Public

- (void)addPoint:(CGPoint)point {
    [self.points addObject:[NSValue valueWithCGPoint:point]];
}

- (UIBezierPath *)bezierPath {
    UIBezierPath *path =  [UIBezierPath interpolateCGPointsWithHermite:self.points closed:NO];
//    UIBezierPath *path =  [UIBezierPath interpolateCGPointsWithCatmullRom:self.points closed:NO alpha:1];
    return path;
}

@end
