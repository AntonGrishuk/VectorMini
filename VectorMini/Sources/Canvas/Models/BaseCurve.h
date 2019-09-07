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

@protocol CurveDelegate <NSObject>

- (void)curvePathDidChange:(UIBezierPath *)path;
- (void)curvePathDidFinished:(UIBezierPath *)path;

@end

@interface BaseCurve : NSObject

@property (nonatomic, weak) id<CurveDelegate> delegate;
@property (nonatomic, assign, readonly) NSUInteger hexColor;

- (void)addPoint:(CGPoint)point;
- (void)addLastPoint:(CGPoint)point;
- (void)constructPathFromPoints:(NSArray *)points;
- (UIBezierPath *)bezierPath;
- (NSArray *)getPoints;
- (UIColor *)color;
- (void)setupId:(NSInteger)iD;
- (void)setupUnixDate:(NSTimeInterval)date;
- (NSTimeInterval)getSecondsSinceUnixEpoch;
- (NSInteger)getId;

@end

NS_ASSUME_NONNULL_END
