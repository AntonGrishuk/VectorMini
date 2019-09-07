//
//  CanvasViewController.m
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CanvasViewController.h"
#import "CAShapeLayer+Image.h"
#import "BaseCurve.h"
#import "CanvasView.h"

#define LINE_WIDTH 5;

@interface CanvasViewController ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) BaseCurve *currentCurve;
@property (nonatomic, strong) NSMutableArray *curves;
@property (nonatomic, assign) CurveType currentCurveType;

@end

@implementation CanvasViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _curves = [NSMutableArray array];
        _currentCurveType = CurveTypeCurve;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shapeLayer = [[CAShapeLayer alloc] init];
    [self.view.layer addSublayer:self.shapeLayer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self configureShapeLayer];
}

#pragma mark - Public

- (void)selectCurveDrawTool {
    self.currentCurveType = CurveTypeCurve;
}

- (void)selectRectangleDrawTool {
    self.currentCurveType = CurveTypeRectangle;
}

- (void)addCurves:(NSArray *)curves {
    [curves enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BaseCurve class]]) {
            [self.curves addObject:obj];
            self.shapeLayer.strokeColor = [[(BaseCurve *)obj color] CGColor];
            [self updateView:[(BaseCurve *)obj bezierPath]];
        }
    }];
}

- (void)setupCurves:(NSArray <BaseCurve *>*)curves {
    self.curves = [NSMutableArray arrayWithArray:curves];
    [self redraw];
}

#pragma mark - Touches handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    switch (self.currentCurveType) {
        case CurveTypeCurve:
            self.currentCurve = [[Curve alloc] init];
            break;
            
        case CurveTypeRectangle:
            self.currentCurve = [[Rectangle alloc] init];
            break;
            
        default:
            break;
    }
    
    [self.currentCurve addPoint:point];
    
    self.shapeLayer.strokeColor = [[self.currentCurve color] CGColor];
    self.shapeLayer.path = [[self.currentCurve bezierPath] CGPath];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.currentCurve addPoint:point];
    self.shapeLayer.path = [[self.currentCurve bezierPath] CGPath];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self finishDrawing:point];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self finishDrawing:point];
}

#pragma mark - Private

- (void)finishDrawing:(CGPoint)point {
    [self.currentCurve addPoint:point];
    [self.curves addObject:self.currentCurve];
    
    if ([self.currentCurve isKindOfClass:[Curve class]]) {
        [self.delegate didFinishDrawCurve: (Curve **)&_currentCurve];
    } else if ([self.currentCurve isKindOfClass:[Rectangle class]]) {
        [self.delegate didFinishDrawRectangle: (Rectangle **)&_currentCurve];
    }
    
    self.shapeLayer.path = nil;
    [self updateView:[self.currentCurve bezierPath]];
}

- (void)configureShapeLayer {
    self.shapeLayer.frame = self.view.layer.bounds;
    self.shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineWidth = LINE_WIDTH;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineCap = kCALineCapRound;
}

- (void)redraw {
    [self cleanCanvas];
    
    [self.curves enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BaseCurve class]]) {
            self.shapeLayer.strokeColor = [[(BaseCurve *)obj color] CGColor];
            [self updateView:[(BaseCurve *)obj bezierPath]];
        }
    }];
}

- (void)cleanCanvas {
    self.currentCurve = nil;
    self.shapeLayer.path = nil;
    [(CanvasView *)self.view clean];
}

- (void)updateView:(UIBezierPath *)bezierPath {
    bezierPath.lineWidth = LINE_WIDTH;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    UIColor *color = [UIColor colorWithCGColor:self.shapeLayer.strokeColor];
    [(CanvasView *)self.view drawPath:bezierPath withColor:color];
    self.shapeLayer.path = nil;
}

@end
