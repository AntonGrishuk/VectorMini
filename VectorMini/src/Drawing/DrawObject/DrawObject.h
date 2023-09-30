//
//  DrawObject.h
//  VectorMini
//
//  Created by Anton Grishuk on 29.07.2023.
//  Copyright © 2023 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawObject : NSObject
@property (nonatomic, strong) NSUUID *objectId;
@property (nonatomic, assign) CGColorRef color;

- (instancetype)initWithObjectId:(NSUUID *)objectId color:(CGColorRef)color;
- (void)add:(CGPoint)point;
- (UIBezierPath *)path;
@end

NS_ASSUME_NONNULL_END
