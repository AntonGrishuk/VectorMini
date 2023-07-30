//
//  ProjectsStorage.m
//  VectorMini
//
//  Created by Anton Grishuk on 30.07.2023.
//  Copyright © 2023 Anton Grishuk. All rights reserved.
//

#import "ProjectsStorage.h"
#import "CurveObject.h"

@implementation ProjectsStorage

- (NSArray<Project *> *)getProjects {
    NSMutableArray<Project *> *projects = [NSMutableArray array];
    NSString *path = [self projectsDirectoryPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSString *> *projectNames = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for (NSUInteger i = 0; i < projectNames.count; i++) {
        NSString *name = projectNames[i];
        NSString *projectPath = [path stringByAppendingPathComponent:name];
        NSData *data = [NSData dataWithContentsOfFile:projectPath];
        if (data) {
            NSError *error;
            NSSet *usingClassesSet = [NSSet setWithArray: @[
                Project.class,
                NSUUID.class,
                NSMutableArray.class,
                CurveObject.class,
                NSValue.class
            ]];
            Project *project = [NSKeyedUnarchiver unarchivedObjectOfClasses:usingClassesSet fromData:data error:&error];
            if (error) {
                NSLog(@"Error %@", [error localizedDescription]);
            } else {
                [projects addObject:project];
            }
        }
    }
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        Project *project = [NSKeyedUnarchiver unarchivedObjectOfClass:Project.class fromData:data error:nil];
        [projects addObject:project];
    }
    
    return projects;
}

- (void)saveProject:(Project *)project error:(NSError *__autoreleasing _Nullable * _Nullable)error {
    NSString *projectId = [[project projectId] UUIDString];
    NSString *projectsDir = [self projectsDirectoryPath];
    NSString *projectPath = [projectsDir stringByAppendingPathComponent:projectId];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: project requiringSecureCoding:YES error:error];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:projectsDir isDirectory: nil]) {
        [fileManager createDirectoryAtPath:projectsDir
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:error];
    }
    
    if ([fileManager fileExistsAtPath:projectPath]) {
        [fileManager removeItemAtPath:projectPath error:error];
    }
    
    NSAssert([fileManager createFileAtPath:projectPath contents:data attributes: nil], @"Error file creation");
}

- (void)deleteProject:(Project *)project error:(NSError *__autoreleasing _Nullable * _Nullable)error {
    NSString *projectId = [[project projectId] UUIDString];
    NSString *projectsDir = [self projectsDirectoryPath];
    NSString *projectPath = [projectsDir stringByAppendingPathComponent:projectId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:projectPath]) {
        [fileManager removeItemAtPath:projectPath error:error];
    }
}

- (NSString *)projectsDirectoryPath {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return  [documentsPath stringByAppendingPathComponent:@"Projects"];
}

@end
