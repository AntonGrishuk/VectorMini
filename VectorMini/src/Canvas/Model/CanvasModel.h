//
//  CanvasModel.h
//  VectorMini
//
//  Created by Anton Grishuk on 21.08.2023.
//  Copyright © 2023 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ToolType) {
    Curve,
    Rectangle
};

NS_ASSUME_NONNULL_BEGIN

@interface CanvasModel : NSObject

@end

NS_ASSUME_NONNULL_END
