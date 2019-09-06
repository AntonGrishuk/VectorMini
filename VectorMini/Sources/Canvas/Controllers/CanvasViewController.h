//
//  CanvasViewController.h
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Curve.h"
#import "Rectangle.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CurveType) {
    CurveTypeCurve = 1,
    CurveTypeRectangle
};

@protocol CanvasViewControllerDelegate <NSObject>

- (void)didFinishDrawCurve:(Curve *__strong*)curve;
- (void)didFinishDrawRectangle:(Rectangle *__strong*)rectangle;

@end

@interface CanvasViewController : UIViewController

@property (nonatomic, weak) id<CanvasViewControllerDelegate> delegate;

- (void)selectCurveDrawTool;
- (void)selectRectangleDrawTool;
- (void)addCurves:(NSArray *)curves;

@end

NS_ASSUME_NONNULL_END
