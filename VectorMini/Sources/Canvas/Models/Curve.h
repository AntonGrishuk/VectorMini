//
//  Curve.h
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCurve.h"

NS_ASSUME_NONNULL_BEGIN

@interface Curve : BaseCurve

@property (nonatomic, strong, readonly) NSMutableArray *points;

- (instancetype)init:(NSArray *)points color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
