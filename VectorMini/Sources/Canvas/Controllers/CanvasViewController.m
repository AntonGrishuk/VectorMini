//
//  CanvasViewController.m
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CanvasViewController.h"
#import "CanvasModelController.h"
#import "CAShapeLayer+Image.h"

#define LINE_WIDTH 5;

@interface CanvasViewController ()<CanvasModelControllerDelegate>

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CanvasModelController *modelController;
@property (nonatomic, strong) UIImage *canvasImage;

@end

@implementation CanvasViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _modelController = [CanvasModelController new];
        _canvasImage = [[UIImage alloc] init];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shapeLayer = [[CAShapeLayer alloc] init];
    [self.view.layer addSublayer:self.shapeLayer];
    
    self.modelController.delegate = self;
    [self.modelController setCurveType:CurveTypeCurve];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self configureShapeLayer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Public

- (void)selectCurveDrawTool {
    [self.modelController setCurveType:CurveTypeCurve];
}

- (void)selectRectangleDrawTool {
    [self.modelController setCurveType:CurveTypeRectangle];
}

#pragma mark - Touches handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.modelController beginDrawingWith:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.modelController continueDrawingWith:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.modelController endDrawingWith:point];
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

#pragma mark - CanvasModelControllerDelegate

- (void)canvasModelDidChangePath:(CGPathRef)path {
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"path"];
    [anim setDuration:0.2];
    anim.fromValue = (__bridge id)self.shapeLayer.path;
    anim.toValue =(__bridge id)path;
    [self.shapeLayer addAnimation:anim forKey:nil];
    self.shapeLayer.path = path;
}

- (void)canvasModelDidEndPath:(CGPathRef)path {
    self.shapeLayer.path = path;
    self.canvasImage = [self.shapeLayer imageWithBackground:self.canvasImage];
    self.shapeLayer.path = nil;
    self.view.layer.contents = (__bridge id _Nullable)(self.canvasImage.CGImage);
}
- (IBAction)onSwith:(UISwitch *)sender {
    CurveType curveType = CurveTypeCurve;
    if (sender.isOn) {
        curveType = CurveTypeRectangle;
    }
    [self.modelController setCurveType:curveType];
}

@end
