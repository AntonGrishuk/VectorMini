//
//  CanvasViewController.m
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CanvasViewController.h"
#import "CanvasView.h"
#import "CurveObject.h"
#import "DrawObject.h"

#define LINE_WIDTH 5;

@interface CanvasViewController ()

@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) CanvasView *view;

@end

@implementation CanvasViewController

@dynamic view;

- (instancetype)initWithDrawObjects:(Project *)project {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.project = project;
    }
    return self;
}

#pragma mark - View life cycle

- (void)loadView {
    self.view = [[CanvasView alloc] initWithFrame: CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view redrawWithObjects:[self.project drawObjects]];
}

#pragma mark - Public

#pragma mark - Touches handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    CurveObject *curve = [[CurveObject alloc] initWithObjectId:[NSUUID UUID] color:[[UIColor blackColor] CGColor]];
    [curve addPoint:point];
    [self.project addDrawObject:curve];
    
    [self.view redrawWithObjects:self.project.drawObjects];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    DrawObject *lastDrawObject = self.project.drawObjects.lastObject;
    if ([lastDrawObject isMemberOfClass:CurveObject.class]) {
        CurveObject *curve = (CurveObject *)lastDrawObject;
        [curve addPoint:point];
    }
    
    [self.view redrawWithObjects:self.project.drawObjects];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    DrawObject *lastDrawObject = self.project.drawObjects.lastObject;
    if ([lastDrawObject isMemberOfClass:CurveObject.class]) {
        CurveObject *curve = (CurveObject *)lastDrawObject;
        [curve addPoint:point];
    }
    
    [self.view redrawWithObjects:self.project.drawObjects];
    [self.project save];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    DrawObject *lastDrawObject = self.project.drawObjects.lastObject;
    if ([lastDrawObject isMemberOfClass:CurveObject.class]) {
        CurveObject *curve = (CurveObject *)lastDrawObject;
        [curve addPoint:point];
    }
    
    [self.view redrawWithObjects:self.project.drawObjects];
}

#pragma mark - Private

@end
