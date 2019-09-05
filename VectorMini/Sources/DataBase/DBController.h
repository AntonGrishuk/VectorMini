//
//  DBController.h
//  FMDBTest
//
//  Created by Anton Grishuk on 9/2/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"
#import "Curve.h"
#import "Rectangle.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBController : NSObject

- (void)start;
- (void)fetchProjects:(void(^)(NSArray *))completion;
- (void)addProject:(void(^)(Project * _Nullable))completion;
//- (void)lastInserRowId;
- (void)addCurve:(Curve *)curve forProject:(NSInteger)projectId
      completion:(void(^)(NSInteger curveId, BOOL result))completion;

- (void)addRectangle:(Rectangle *)rectangle forProject:(NSInteger)projectId
          completion:(void(^)(NSInteger curveId, BOOL result))completion;

@end

NS_ASSUME_NONNULL_END
