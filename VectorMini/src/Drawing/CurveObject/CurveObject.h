//
//  CurveObject.h
//  VectorMini
//
//  Created by Anton Grishuk on 29.07.2023.
//  Copyright © 2023 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurveObject: DrawObject<NSSecureCoding>

- (NSUInteger)pointsCount;
- (CGPoint)pointAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
