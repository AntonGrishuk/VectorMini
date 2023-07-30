//
//  ProjectsViewController.m
//  VectorMini
//
//  Created by Anton Grishuk on 9/4/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//
#import "ProjectsViewController.h"
#import "CanvasContainerViewController.h"
#import "Project.h"
#import "ProjectCell.h"
#import "ProjectsStorage.h"

@interface ProjectsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<Project *> *projects;
@property (nonatomic, strong) ProjectsStorage *storage;

@end

@implementation ProjectsViewController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _storage = [[ProjectsStorage alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchProjects];
}


#pragma mark - Navigation

- (void)onAddProject:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create new project" message:@"Enter project name" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler: nil];
    __weak ProjectsViewController *weakSelf = self;

    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Create"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        NSString *name = alert.textFields.firstObject.text;
        Project *project = [[Project alloc] initWithId:[NSUUID UUID]
                                                  name:name
                                           drawObjects:@[]];
        [weakSelf.projects addObject:project];
        NSError *error;
        [weakSelf.storage saveProject:project error:&error];
        NSAssert1(error == nil, @"Error: %@", [error debugDescription]);
        [weakSelf.tableView reloadData];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)fetchProjects {
    self.projects = [NSMutableArray arrayWithArray:[self.storage getProjects]];
    [self.tableView reloadData];
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

    CanvasContainerViewController *canvasContainer = [[CanvasContainerViewController alloc] initWithProject: project];
    [self.navigationController pushViewController:canvasContainer animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    Project *p = [self.projects objectAtIndex:indexPath.row];
    NSError *error;
    [self.storage deleteProject:p error:&error];
    
    NSAssert1(!error, @"Error: %@", [error userInfo]);
    
    [self.projects removeObject:p];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
