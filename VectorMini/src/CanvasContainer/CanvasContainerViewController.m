//
//  CanvasContainerViewController.m
//  VectorMini
//
//  Created by Anton Grishuk on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CanvasContainerViewController.h"
#import "CanvasViewController.h"

@interface CanvasContainerViewController ()
@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) UIView *canvasContainer;
@property (nonatomic, strong) CanvasViewController *canvasViewController;
@end

@implementation CanvasContainerViewController

- (instancetype)initWithProject:(Project *)project {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.project = project;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canvasViewController = [[CanvasViewController alloc] initWithDrawObjects:self.project];
    self.canvasContainer = [UIView new];
    [self.view addSubview:self.canvasContainer];
    [self.canvasContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [self.canvasContainer.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.canvasContainer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.canvasContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.canvasContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    [self configureCanvas];
}

- (void)configureCanvas {
    [self addChildViewController:self.canvasViewController];
    [self.canvasContainer addSubview:self.canvasViewController.view];
    UIView *canvasView = self.canvasViewController.view;
    canvasView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [canvasView.topAnchor constraintEqualToAnchor:self.canvasContainer.topAnchor],
        [canvasView.bottomAnchor constraintEqualToAnchor:self.canvasContainer.bottomAnchor],
        [canvasView.leadingAnchor constraintEqualToAnchor:self.canvasContainer.leadingAnchor],
        [canvasView.trailingAnchor constraintEqualToAnchor:self.canvasContainer.trailingAnchor]
    ]];
      
    [self.canvasViewController didMoveToParentViewController:self];
}

@end
