//
//  DBController.h
//  FMDBTest
//
//  Created by Anton Grishuk on 9/2/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBController : NSObject

- (void)start;
- (void)fetchProjects:(void(^)(NSArray *))completion;
- (void)addProject:(void(^)(NSString *))completion;

@end

NS_ASSUME_NONNULL_END
