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
            UIBezierPath *path = [self pathFromDrawObject:drawObject];
            UIColor *color = [UIColor colorWithCGColor:drawObject.color];
            [color setStroke];
            [path stroke];
        }
    }
}

- (void)redrawWithObjects:(NSArray<DrawObject *> *)drawObjects {
    self.drawObjects = drawObjects;
    [self setNeedsDisplay];
}

- (UIBezierPath *)pathFromDrawObject:(DrawObject *)drawObject {
    if ([drawObject isMemberOfClass:CurveObject.class]) {
        CurveObject *curve = (CurveObject *)drawObject;
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        NSUInteger pointsCount = [curve pointsCount];
        if (pointsCount == 0) {
            return nil;
        }
        [path moveToPoint:[curve pointAtIndex:0]];
        
        for (NSUInteger i = 0; i < pointsCount; i++) {
            [path addLineToPoint:[curve pointAtIndex:i]];
        }
        
        path.lineWidth = 2;
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        
        return path;
    }
    
    return nil;
}

@end
