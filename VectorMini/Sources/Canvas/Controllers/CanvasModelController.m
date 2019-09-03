//
//  CanvasModelController.m
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CanvasModelController.h"
#import "Curve.h"
#import "Rectangle.h"
#import "CurveProtocols.h"

@interface CanvasModelController ()<CurveDelegate>

@property (nonatomic, strong) id<CurveInterface> currentCurve;
@property (nonatomic, strong) NSMutableArray *curves;
@property (nonatomic, assign) CurveType currentCurveType;

@end

@implementation CanvasModelController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _curves = [NSMutableArray array];
    }
    return self;
}

- (void)beginDrawingWith:(CGPoint)point {
    self.currentCurve = [self curve:self.currentCurveType];
    [self.curves addObject:self.currentCurve];
    self.currentCurve.delegate = self;

    [self.currentCurve addPoint:point];
}

- (void)continueDrawingWith:(CGPoint)point {
    [self.currentCurve addPoint:point];
}

- (void)endDrawingWith:(CGPoint)point{
    [self.currentCurve addLastPoint:point];
}

- (void)setCurveType:(CurveType)curveType {
    if (curveType != self.currentCurveType) {
        self.currentCurveType = curveType;
    }
}

- (id<CurveInterface>)curve:(CurveType)curveType {
    id<CurveInterface> curve;
    
    switch (curveType) {
            
        case CurveTypeCurve:
            curve = [[Curve alloc] init];
            break;
            
        case CurveTypeRectangle:
            curve = [Rectangle new];
            break;
            
        default:
            break;
    }
    
    return curve;
}

#pragma mark - CurveDelegate

- (void)curvePathDidChange:(CGPathRef)path {
    [self.delegate canvasModelDidChangePath:path];
}

- (void)curvePathDidFinished:(nonnull CGPathRef)path {
    [self.delegate canvasModelDidEndPath:path];
}

@end
