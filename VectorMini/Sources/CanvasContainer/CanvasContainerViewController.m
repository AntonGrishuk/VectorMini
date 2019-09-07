//
//  CanvasContainerViewController.m
//  VectorMini
//
//  Created by Anton Grishuk on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CanvasContainerViewController.h"
#import "CanvasViewController.h"
#import "CurvesListTableViewController.h"

@interface CanvasContainerViewController ()<CanvasViewControllerDelegate, CurvesListTableViewControllerDelegate>
@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) DBController *dbController;
@end

@implementation CanvasContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self canvasViewController] setDelegate:self];
    [[self curvesListViewController] setDelegate:self];
    [self fetchCurves];
}

- (void)setSelectedProject:(Project *)project {
    self.project = project;
}

- (void)setupDataBaseController:(DBController *)dbController {
    self.dbController = dbController;
}

- (void)fetchCurves {
    NSInteger projId = [self.project iD];
    
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *figures = [NSMutableArray array];
    
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
            CanvasViewController *canvasVC = [self canvasViewController];
            CurvesListTableViewController *curvesListVC = [self curvesListViewController];
            [canvasVC addCurves:figures];
            [curvesListVC addCurves:figures];
        });
    });
}

- (UISplitViewController *)canvasSplitViewController {
     return (UISplitViewController *)[[self childViewControllers] firstObject];
}

- (CanvasViewController *)canvasViewController {
    UISplitViewController *split = [self canvasSplitViewController];
    for (UIViewController *vc in [split viewControllers]) {
        if ([vc isKindOfClass:[CanvasViewController class]]) {
            return (CanvasViewController *)vc;
        }
    }
    
    return nil;
}

- (CurvesListTableViewController *)curvesListViewController {
    UISplitViewController *split = [self canvasSplitViewController];
    for (UIViewController *vc in [split viewControllers]) {
        if ([vc isKindOfClass:[CurvesListTableViewController class]]) {
            return (CurvesListTableViewController *)vc;
        }
    }
    
    return nil;
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
             
             CurvesListTableViewController *curvesListVC = [weakSelf curvesListViewController];
             [curvesListVC addCurve:(*curve)];
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
             
             CurvesListTableViewController *curvesListVC = [weakSelf curvesListViewController];
             [curvesListVC addCurve:(*rectangle)];
         }
     }];
}

#pragma mark - CurvesListTableViewControllerDelegate

- (void)didRemoveCurveFromCurvesList:(BaseCurve *)curve {
    [self.dbController removeCurve:curve projectId: [self.project iD]];
    [[self canvasViewController] removeCurve:curve];
}

@end
