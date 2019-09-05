//
//  Rectangle.h
//  Canvas
//
//  Created by Anton Grishuk on 9/2/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCurve.h"

NS_ASSUME_NONNULL_BEGIN

@interface Rectangle : BaseCurve

- (CGRect)getRect;

@end

NS_ASSUME_NONNULL_END
