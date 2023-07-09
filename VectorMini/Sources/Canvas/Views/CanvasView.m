//
//  AGLayerDrawingView.m
//  TestCGContext
//
//  Created by Anton Grishuk on 8/31/17.
//  Copyright © 2017 Anton Grishuk. All rights reserved.
//

#import "CanvasView.h"

@interface CanvasView()
@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *drawingPaths;
@property (nonatomic, strong) NSMutableArray<UIColor *> *pathsColors;
@end

@implementation CanvasView



- (void)awakeFromNib {
    [super awakeFromNib];
    self.drawingPaths = [NSMutableArray array];
    self.pathsColors = [NSMutableArray array];
}

- (void)drawRect:(CGRect)rect {
    for (NSInteger i = 0; i < MIN(self.drawingPaths.count, self.pathsColors.count); i++ ) {
        @autoreleasepool {
            UIBezierPath *path = [self.drawingPaths objectAtIndex:i];
            UIColor *color = [self.pathsColors objectAtIndex:i];
            [color setStroke];
            [path stroke];
        }
    }
}

- (void)drawPath:(UIBezierPath *)path withColor:(UIColor *)color {
    if (path && color) {
        [self.drawingPaths addObject:path];
        [self.pathsColors addObject:color];
        [self setNeedsDisplay];
    }
}

- (void)clean {
    [self.drawingPaths removeAllObjects];
    [self.pathsColors removeAllObjects];
    [self setNeedsDisplay];
}

@end
