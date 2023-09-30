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
@property (nonatomic, strong) UIToolbar *toolbar;
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
    
    [self configureToolbad];
    [self configureCanvas];
}

- (void)configureToolbad {
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolbar.frame = CGRectMake(0, 60, self.view.frame.size.width, 60);
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Tools" menu:[self toolsMenu]]];
    [self.toolbar setItems:items animated:NO];
    [self.view addSubview:self.toolbar];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.toolbar.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.toolbar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.toolbar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.toolbar.heightAnchor constraintEqualToConstant:60]
    ]];
}

- (void)configureCanvas {
    self.view.backgroundColor = [UIColor whiteColor];
    self.canvasViewController = [[CanvasViewController alloc] initWithDrawObjects:self.project];
    self.canvasContainer = [UIView new];
    [self.view addSubview:self.canvasContainer];
    [self.canvasContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [self.canvasContainer.topAnchor constraintEqualToAnchor:self.toolbar.bottomAnchor],
        [self.canvasContainer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.canvasContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.canvasContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
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

- (UIMenu *) toolsMenu {
    __weak CanvasContainerViewController *weakSelf = self;
    UIAction *curveItem = [UIAction actionWithTitle:@"curve" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf.canvasViewController selectTool: Curve];
    }];
    UIAction *rectangleItem = [UIAction actionWithTitle:@"rectangle" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf.canvasViewController selectTool: Rectangle];
    }];
    UIMenu *menu = [UIMenu menuWithChildren:@[curveItem, rectangleItem]];
    return menu;
}


@end
