//
//  Project.h
//  VectorMini
//
//  Created by Anton Grishuk on 9/4/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Project : NSObject

@property (nonatomic, assign, readonly) NSInteger iD;
@property (nonatomic, strong, readonly) NSString *name;

- (instancetype)init:(NSInteger)iD name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
