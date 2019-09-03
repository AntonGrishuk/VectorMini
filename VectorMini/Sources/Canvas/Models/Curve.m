//
//  Curve.m
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "Curve.h"
#import <UIKit/UIGeometry.h>

@interface Curve () {
    CGPoint smoothingPoints[5];
    NSUInteger smoothingPointsCounter;
}

@property (nonatomic, assign) CGMutablePathRef path;
@property (nonatomic, strong) NSMutableArray *points;

@end

@implementation Curve

#pragma mark - Initalizations and dellocation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _path = CGPathCreateMutable();
        _points = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init:(NSArray *)points {
    self = [self init];
    if (self) {
        _points = [NSMutableArray arrayWithArray:points];
    }
    return self;
}

- (void)dealloc {
    CGPathRelease(_path);
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
    NSInteger count = points.count;
    CGMutablePathRef mutPath = CGPathCreateMutable();
    self.points = [NSMutableArray arrayWithArray:points];
    
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
    return  CGPathCreateCopy(self.path);
}

- (NSArray *)getPoints {
    return  [NSArray arrayWithArray:self.points];
}

#pragma mark - Private

- (CGPathRef)newPathWith:(CGPoint)point {
    smoothingPoints[smoothingPointsCounter] = point;
    
    if (smoothingPointsCounter == 0) {
        
        CGPoint point = smoothingPoints[0];
        CGPathMoveToPoint(self.path, nil, point.x, point.y);
        CGPathAddLineToPoint(self.path, nil, point.x, point.y);
        smoothingPointsCounter++;
        
    } else if (smoothingPointsCounter == 1) {
        
        CGPoint point = smoothingPoints[smoothingPointsCounter];
        CGMutablePathRef tmpPath = CGPathCreateMutableCopy(self.path);
        CGPathAddLineToPoint(tmpPath, nil, point.x, point.y);
        [self.delegate curvePathDidChange:tmpPath];
        smoothingPointsCounter++;
        return tmpPath;
        
    } else if (smoothingPointsCounter == 2) {

        CGMutablePathRef tmpPath = CGPathCreateMutableCopy(self.path);
        CGPoint p2 = CGPointMake((smoothingPoints[0].x + smoothingPoints[2].x)/2.0, (smoothingPoints[0].y + smoothingPoints[2].y)/2.0);
        CGPathAddQuadCurveToPoint(tmpPath, nil, smoothingPoints[1].x, smoothingPoints[1].y,
                                  p2.x, p2.y);
        smoothingPointsCounter++;
        return tmpPath;
        
    } else if (smoothingPointsCounter == 3) {
        
        CGMutablePathRef tmpPath = CGPathCreateMutableCopy(self.path);
        CGPoint p2 = CGPointMake((smoothingPoints[1].x + smoothingPoints[3].x)/2.0, (smoothingPoints[1].y + smoothingPoints[3].y)/2.0);
        CGPathAddQuadCurveToPoint(tmpPath, nil, smoothingPoints[1].x, smoothingPoints[1].y,
                                  p2.x, p2.y);

        smoothingPointsCounter++;
        return tmpPath;
        
    } else if (smoothingPointsCounter == 4) {
        
        smoothingPoints[3] = CGPointMake((smoothingPoints[2].x + smoothingPoints[4].x)/2.0, (smoothingPoints[2].y + smoothingPoints[4].y)/2.0);
        CGPathMoveToPoint(self.path, nil, smoothingPoints[0].x, smoothingPoints[0].y);
        
        CGPathAddCurveToPoint(self.path, nil, smoothingPoints[1].x, smoothingPoints[1].y, smoothingPoints[2].x, smoothingPoints[2].y,
                              smoothingPoints[3].x, smoothingPoints[3].y );
        smoothingPoints[0] = smoothingPoints[3];
        smoothingPoints[1] = smoothingPoints[4];
        smoothingPointsCounter = 1;
    }
    
    return CGPathCreateCopy(self.path);
}

@end
