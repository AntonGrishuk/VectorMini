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
#import "RectangleObject.h"
#import "DrawObject.h"

#define LINE_WIDTH 5;

@interface CanvasViewController ()

@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) CanvasView *view;
@property (nonatomic, assign) ToolType selectedToolType;

@end

@implementation CanvasViewController

@dynamic view;

- (instancetype)initWithDrawObjects:(Project *)project {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.project = project;
        self.selectedToolType = Curve;
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

- (void)selectTool:(ToolType)type {
    self.selectedToolType = type;
}

#pragma mark - Touches handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    DrawObject *drawObject;
    switch (self.selectedToolType) {
        case Curve:
            drawObject = [[CurveObject alloc] initWithObjectId:[NSUUID UUID] 
                                                         color:[[UIColor blackColor] CGColor]];
            break;
            
        case Rectangle:
            drawObject = [[RectangleObject alloc] initWithObjectId:[NSUUID UUID]
                                                             color:[[UIColor blackColor] CGColor]];
            break;
    }
    
    [drawObject add:point];
    [self.project addDrawObject:drawObject];
    
    [self.view redrawWithObjects:self.project.drawObjects];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    DrawObject *drawObject = self.project.drawObjects.lastObject;
    [drawObject add:point];
    
    [self.view redrawWithObjects:self.project.drawObjects];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    DrawObject *drawObject = self.project.drawObjects.lastObject;
    [drawObject add:point];
    
    [self.view redrawWithObjects:self.project.drawObjects];
    [self.project save];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    DrawObject *drawObject = self.project.drawObjects.lastObject;
    [drawObject add:point];
    
    [self.view redrawWithObjects:self.project.drawObjects];
}

#pragma mark - Private

@end
