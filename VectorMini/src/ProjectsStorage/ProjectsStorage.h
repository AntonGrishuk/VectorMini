//
//  ProjectsStorage.h
//  VectorMini
//
//  Created by Anton Grishuk on 30.07.2023.
//  Copyright © 2023 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProjectsStorage : NSObject

- (NSArray<Project *> *)getProjects;
- (void)saveProject:(Project *)project error:(NSError *__autoreleasing _Nullable * _Nullable)error;
- (void)deleteProject:(Project *)project error:(NSError *__autoreleasing _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
