//
//  BaseCurve.h
//  VectorMini
//
//  Created by Grishuk Anton on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCurve : NSObject

@property (nonatomic, strong, readonly) NSDate *creationDate;
@property (nonatomic, assign, readonly) NSInteger iD;
@property (nonatomic, strong, readonly) UIColor *color;

- (instancetype)init:(UIColor *)color;

- (void)addPoint:(CGPoint)point;
- (UIBezierPath *)bezierPath;
- (void)setupId:(NSInteger)iD;
- (void)setupCreationDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
