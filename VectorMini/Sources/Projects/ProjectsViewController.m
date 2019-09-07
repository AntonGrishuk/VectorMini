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

@interface ProjectsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (nonatomic, strong) DBController *dbController;
@property (nonatomic, strong) NSMutableArray<Project *> *projects;
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation ProjectsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
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
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CanvasContainerSegue"]) {
        Project *project = [self.projects objectAtIndex:self.selectedRow];
        id canvasContainer = [segue destinationViewController];
        if ([canvasContainer isKindOfClass:[CanvasContainerViewController class]]) {
            [(CanvasContainerViewController *)canvasContainer setSelectedProject: project];
             [(CanvasContainerViewController *)canvasContainer setupDataBaseController:self.dbController];
        }
    }
}

- (IBAction)onAddProject:(UIBarButtonItem *)sender {
    __weak ProjectsViewController *weakSelf = self;
    [self.dbController addProject:^(Project * _Nullable project) {
        if (project) {
            [weakSelf.projects addObject:project];
            [weakSelf.tabelView reloadData];
        }
    }];
}

- (void)fetchProjects {
    __weak ProjectsViewController *weakSelf = self;
    [self.dbController fetchProjects:^(NSArray * _Nonnull results) {
        weakSelf.projects = [NSMutableArray arrayWithArray:results];
        [weakSelf.tabelView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectCell"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Project *p = [self.projects objectAtIndex:indexPath.row];
    cell.textLabel.text = p.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"CanvasContainerSegue" sender:self];
}

@end
