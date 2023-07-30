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

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)addPoint:(CGPoint) point {
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
