//
//  CurveObject.m
//  VectorMini
//
//  Created by Anton Grishuk on 29.07.2023.
//  Copyright © 2023 Anton Grishuk. All rights reserved.
//

#import "CurveObject.h"

@interface CurveObject ()
@property (nonatomic, strong) NSMutableArray *points;
@end

@implementation CurveObject

- (instancetype)initWithObjectId:(NSUUID *)objectId color:(CGColorRef)color
{
    self = [super initWithObjectId:objectId color:color];
    if (self) {
        self.points = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _points = [NSMutableArray arrayWithArray:[coder decodeObjectForKey:@"points"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.points forKey:@"points"];
}

- (UIBezierPath *)path {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSUInteger pointsCount = [self pointsCount];
    if (pointsCount == 0) {
        return nil;
    }
    [path moveToPoint:[self pointAtIndex:0]];
    
    for (NSUInteger i = 0; i < pointsCount; i++) {
        [path addLineToPoint:[self pointAtIndex:i]];
    }
    
    path.lineWidth = 2;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    return  path;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)add:(CGPoint) point {
    [self.points addObject:[NSValue valueWithCGPoint:point]];
}

- (NSUInteger)pointsCount {
    return self.points.count;
}

- (CGPoint)pointAtIndex:(NSUInteger)index {
    NSAssert(index < self.points.count, @"Index is out of range");
    return [[self.points objectAtIndex:index] CGPointValue];
}

@end
