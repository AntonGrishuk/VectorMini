//
//  ProjectsViewController.m
//  VectorMini
//
//  Created by Anton Grishuk on 9/4/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//
#import "ProjectsViewController.h"
#import "CanvasContainerViewController.h"
#import "DBController.h"
#import "Project.h"
#import "ProjectCell.h"

@interface ProjectsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBController *dbController;
@property (nonatomic, strong) NSMutableArray<Project *> *projects;

@end

@implementation ProjectsViewController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _projects = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbController = [DBController new];
    [self.dbController start];
    [self fetchProjects];
    
    self.tableView = [UITableView new];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[ProjectCell class]
           forCellReuseIdentifier:[ProjectCell cellID]];
    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints: @[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.title = @"Projects";
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(onAddProject:)];
    [self.navigationItem setRightBarButtonItem:plusButton];
}


#pragma mark - Navigation

- (void)onAddProject:(UIBarButtonItem *)sender {
    __weak ProjectsViewController *weakSelf = self;
    [self.dbController addProject:^(Project * _Nullable project) {
        if (project) {
            [weakSelf.projects addObject:project];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)fetchProjects {
    __weak ProjectsViewController *weakSelf = self;
    [self.dbController fetchProjects:^(NSArray * _Nonnull results) {
        weakSelf.projects = [NSMutableArray arrayWithArray:results];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:[ProjectCell cellID]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Project *p = [self.projects objectAtIndex:indexPath.row];
    cell.textLabel.text = p.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Project *project = [self.projects objectAtIndex:indexPath.row];

    CanvasContainerViewController *canvasContainer = [[CanvasContainerViewController alloc] initWithProject: project dbController:self.dbController];
    [self.navigationController pushViewController:canvasContainer animated:YES];
}

@end
