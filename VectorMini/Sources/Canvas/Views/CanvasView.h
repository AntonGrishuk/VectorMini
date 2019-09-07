//
//  AGLayerDrawingView.h
//  TestCGContext
//
//  Created by Anton Grishuk on 8/31/17.
//  Copyright © 2017 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanvasView : UIView

- (void)drawPath:(UIBezierPath *)path withColor:(UIColor *)color;
- (void)clean;

@end
