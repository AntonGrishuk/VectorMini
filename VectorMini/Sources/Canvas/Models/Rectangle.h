//
//  Rectangle.h
//  Canvas
//
//  Created by Anton Grishuk on 9/2/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CurveProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface Rectangle : NSObject<CurveInterface>

@property (nonatomic, weak) id<CurveDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
