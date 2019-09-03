//
//  CanvasModelController.h
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CurveType) {
    CurveTypeCurve = 1,
    CurveTypeRectangle
};

@protocol CanvasModelControllerDelegate <NSObject>

- (void)canvasModelDidChangePath:(CGPathRef)path;
- (void)canvasModelDidEndPath:(CGPathRef)path;

@end

@interface CanvasModelController : NSObject

@property (nonatomic, weak) id<CanvasModelControllerDelegate> delegate;

- (void)beginDrawingWith:(CGPoint)point;
- (void)continueDrawingWith:(CGPoint)point;
- (void)endDrawingWith:(CGPoint)point;
- (void)setCurveType:(CurveType)curveType;

@end

NS_ASSUME_NONNULL_END
