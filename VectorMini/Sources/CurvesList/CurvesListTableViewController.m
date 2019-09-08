//
//  CurvesListTableViewController.m
//  VectorMini
//
//  Created by Anton Grishuk on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CurvesListTableViewController.h"
#import "CurveListTableViewCell.h"

static NSInteger cellHeight = 80;

@interface CurvesListTableViewController ()

@property (nonatomic, strong) NSMutableArray *curves;

@end

@implementation CurvesListTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _curves = [NSMutableArray array];
    }
    return self;
}

- (void)addCurves:(NSArray *)curves {
    [self.curves addObjectsFromArray:curves];
    [self.tableView reloadData];
    
}

- (void)addCurve:(BaseCurve *)curve {
    [self.curves addObject:curve];
    [self.tableView reloadData];
}

- (void)setupCurves:(NSArray <BaseCurve *>*)curves {
    self.curves = [NSMutableArray arrayWithArray:curves];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.curves count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurveCell" forIndexPath:indexPath];
    
    BaseCurve *curve = [self.curves objectAtIndex:indexPath.row];
    [(CurveListTableViewCell *)cell setupCurve:curve];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BaseCurve *curve = [self.curves objectAtIndex:indexPath.row];
        [self.curves removeObjectAtIndex:indexPath.row];
        [self.delegate didRemoveCurveFromCurvesList:curve];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
