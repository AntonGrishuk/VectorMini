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

@interface CanvasContainerViewController ()<CanvasViewControllerDelegate>
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
    
}

- (void)setSelectedProject:(Project *)project {
    self.project = project;
}

- (void)setupDataBaseController:(DBController *)dbController {
    self.dbController = dbController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [self.dbController addCurve:tmpCurve forProject:[self.project idNumber] completion:^(NSInteger curveId, BOOL result) {
        [(*curve) setupId:curveId];
    }];
}

- (void)didFinishDrawRectangle:(Rectangle **)rectangle {
}


@end
