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

#define LINE_WIDTH 5;

@interface CanvasViewController ()<CurveDelegate>

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIImage *canvasImage;
@property (nonatomic, strong) BaseCurve *currentCurve;
@property (nonatomic, strong) NSMutableArray *curves;
@property (nonatomic, assign) CurveType currentCurveType;

@end

@implementation CanvasViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _canvasImage = [[UIImage alloc] init];
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
    
    [self.curves addObject:self.currentCurve];
    self.currentCurve.delegate = self;
    [self.currentCurve addPoint:point];
    
    self.shapeLayer.strokeColor = [[self.currentCurve color] CGColor];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.currentCurve addPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.currentCurve addLastPoint:point];
    
    switch (self.currentCurveType) {
            
        case CurveTypeCurve:
            
            [self.delegate didFinishDrawCurve: &_currentCurve];
            break;
            
        case CurveTypeRectangle:
            [self.delegate didFinishDrawRectangle: &_currentCurve];
            break;
            
        default:
            break;
    }
}

#pragma mark - Private

- (void)configureShapeLayer {
    self.shapeLayer.frame = self.view.layer.bounds;
    self.shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineWidth = LINE_WIDTH;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineCap = kCALineCapRound;
}

#pragma mark - CurveDelegate

- (void)curvePathDidChange:(CGPathRef)path {
    self.shapeLayer.path = path;
}

- (void)curvePathDidFinished:(nonnull CGPathRef)path {
    self.shapeLayer.path = path;
    self.canvasImage = [self.shapeLayer imageWithBackground:self.canvasImage];
    self.shapeLayer.path = nil;
    self.view.layer.contents = (__bridge id _Nullable)(self.canvasImage.CGImage);
}

@end
