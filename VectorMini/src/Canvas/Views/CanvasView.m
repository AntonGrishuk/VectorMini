//
//  AGLayerDrawingView.m
//  TestCGContext
//
//  Created by Anton Grishuk on 8/31/17.
//  Copyright © 2017 Anton Grishuk. All rights reserved.
//

#import "CanvasView.h"
#import "CurveObject.h"

@interface CanvasView ()

@property (nonatomic, strong) NSArray<DrawObject *> *drawObjects;

@end

@implementation CanvasView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    for (NSInteger i = 0; i < self.drawObjects.count; i++ ) {
        @autoreleasepool {
            DrawObject *drawObject = self.drawObjects[i];
            UIColor *color = [UIColor colorWithCGColor:drawObject.color];
            [color setStroke];
            [[drawObject path] stroke];
        }
    }
}

- (void)redrawWithObjects:(NSArray<DrawObject *> *)drawObjects {
    self.drawObjects = drawObjects;
    [self setNeedsDisplay];
}

@end
