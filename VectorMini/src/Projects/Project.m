//
//  Project.m
//  VectorMini
//
//  Created by Anton Grishuk on 9/4/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "Project.h"
#import "ProjectsStorage.h"

@interface Project ()
@property (nonatomic, strong) NSMutableArray<DrawObject *> *mutableDrawObjects;
@property (nonatomic, strong) ProjectsStorage *storage;

@end

@implementation Project

- (nonnull instancetype)initWithId:(NSUUID *)projectId
                        name:(nonnull NSString *)name
                 drawObjects:(nonnull NSArray<DrawObject *> *)drawObjects
{
    self = [super init];
    if (self) {
        _projectId = projectId;
        _name = [name copy];
        _storage = [[ProjectsStorage alloc] init];
        self.mutableDrawObjects = [NSMutableArray arrayWithArray:drawObjects];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        _projectId = [coder decodeObjectForKey:@"project_id"];
        _mutableDrawObjects = [NSMutableArray arrayWithArray:[coder decodeObjectForKey:@"draw_objects"]];
        _storage = [[ProjectsStorage alloc] init];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.projectId forKey:@"project_id"];
    [coder encodeObject:self.mutableDrawObjects forKey:@"draw_objects"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)addDrawObject:(DrawObject *)object {
    [self.mutableDrawObjects addObject:object];
}

- (NSArray *)drawObjects {
    return  [NSArray arrayWithArray:self.mutableDrawObjects];
}

- (void)save {
    NSError *error;
    [self.storage saveProject:self error:&error];
    
    NSAssert1(error == nil, @"Error: %@", [error debugDescription]);
}

@end
