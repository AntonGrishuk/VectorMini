//
//  RectangleObject.m
//  VectorMini
//
//  Created by Anton Grishuk on 21.09.2023.
//  Copyright © 2023 Anton Grishuk. All rights reserved.
//

#import "RectangleObject.h"
#import <UIKit/UIKit.h>

@interface RectangleObject ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation RectangleObject

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithObjectId:(NSUUID *)objectId color:(CGColorRef)color {
    self = [super initWithObjectId:objectId color:color];
    if (self) {
        self.startPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
        self.endPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.startPoint = [coder decodeCGPointForKey:@"startPoint"];
        self.endPoint = [coder decodeCGPointForKey:@"endPoint"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeCGPoint:_startPoint forKey:@"startPoint"];
    [coder encodeCGPoint:_endPoint forKey:@"endPoint"];
}

- (void)add:(CGPoint) point {
    if (self.startPoint.x == CGFLOAT_MIN) {
        self.startPoint = point;
    } else {
        self.endPoint = point;
    }
}

- (UIBezierPath *)path {
    if (self.startPoint.x == CGFLOAT_MIN || self.endPoint.x == CGFLOAT_MIN) {
        return [UIBezierPath new];
    }

    CGFloat width = ABS(_startPoint.x - _endPoint.x);
    CGFloat height = ABS(_startPoint.y - _endPoint.y);
    CGPoint origin = CGPointMake(MIN(_startPoint.x, _endPoint.x), MIN(_startPoint.y, _endPoint.y));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(origin.x,
                                                                     origin.y,
                                                                     width,
                                                                     height)];
    path.lineWidth = 2;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    return path;
}

@end
