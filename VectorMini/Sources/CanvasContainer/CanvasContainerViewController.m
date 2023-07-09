//
//  CanvasContainerViewController.m
//  VectorMini
//
//  Created by Anton Grishuk on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CanvasContainerViewController.h"
#import "CanvasViewController.h"

@interface CanvasContainerViewController ()<CanvasViewControllerDelegate>
@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) DBController *dbController;
@property (nonatomic, strong) UIView *canvasContainer;
@property (nonatomic, strong) CanvasViewController *canvasViewController;
@end

@implementation CanvasContainerViewController

- (instancetype)initWithProject:(Project *)project
                   dbController:(DBController *)dbController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.dbController = dbController;
        self.project = project;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canvasViewController = [[CanvasViewController alloc] init];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [self.project name];
    [self fetchCurves:^(NSArray<BaseCurve *> *figures) {
        [self.canvasViewController setupCurves:figures];
    }];
}

- (void)fetchCurves:(void(^)(NSArray<BaseCurve *>* figures))completion {
    NSInteger projId = [self.project iD];
    
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray <BaseCurve *>*figures = [NSMutableArray array];
    
    dispatch_group_enter(group);
    [self.dbController fetchCurves:projId completion:^(NSArray * _Nonnull curves) {
        [figures addObjectsFromArray:curves];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self.dbController fetchRectangles:projId completion:^(NSArray * _Nonnull rects) {
        [figures addObjectsFromArray:rects];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [figures sortUsingComparator:^NSComparisonResult(BaseCurve *  _Nonnull obj1, BaseCurve *  _Nonnull obj2) {
            
            return [[obj1 creationDate] compare:[obj2 creationDate]];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(figures);
        });
    });
}

- (UISplitViewController *)canvasSplitViewController {
     return (UISplitViewController *)[[self childViewControllers] firstObject];
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
    
    [[self canvasViewController] setDelegate:self];
}

- (IBAction)onChangeValue:(UISegmentedControl *)sender {

    CanvasViewController *canvas = [self canvasViewController];
    switch (sender.selectedSegmentIndex) {
        case 0:
            [canvas selectCurveDrawTool];
            break;
            
        case 1:
            [canvas selectRectangleDrawTool];
            break;
            
        default:
            break;
    }
}

#pragma mark - CanvasViewControllerDelegate

- (void)didFinishDrawCurve:(Curve *__strong*)curve {
    Curve *tmpCurve = *curve;
    __weak CanvasContainerViewController *weakSelf = self;
    
    [self.dbController addCurve:tmpCurve forProject:[self.project iD]
                     completion:^(NSInteger curveId, BOOL result)
     {
         if (result) {
             [(*curve) setupId:curveId];
         }
     }];
}

- (void)didFinishDrawRectangle:(Rectangle *__strong*)rectangle {
    Rectangle *tmpRect = *rectangle;
    __weak CanvasContainerViewController *weakSelf = self;
    
    [self.dbController addRectangle:tmpRect forProject:[self.project iD]
                         completion:^(NSInteger curveId, BOOL result)
     {
         if (result) {
             [(*rectangle) setupId:curveId];
         }
     }];
}

@end
