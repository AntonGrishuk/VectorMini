//
//  AGLayerDrawingView.h
//  TestCGContext
//
//  Created by Anton Grishuk on 8/31/17.
//  Copyright © 2017 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawObject.h"

@interface CanvasView : UIView

- (void)redrawWithObjects:(NSArray<DrawObject *> *)drawObjects;

@end
