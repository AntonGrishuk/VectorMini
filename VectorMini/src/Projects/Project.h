//
//  Project.h
//  VectorMini
//
//  Created by Anton Grishuk on 9/4/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Project: NSObject<NSSecureCoding>

@property (nonatomic, strong, readonly) NSUUID *projectId;
@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithId:(NSUUID *)projectId
                name:(NSString *)name
         drawObjects:(NSArray< DrawObject*> *)drawObjects;

- (void)addDrawObject:(DrawObject *)object;
- (NSArray *)drawObjects;
- (void)save;

@end

NS_ASSUME_NONNULL_END
