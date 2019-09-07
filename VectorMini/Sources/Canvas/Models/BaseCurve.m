//
//  BaseCurve.m
//  VectorMini
//
//  Created by Grishuk Anton on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "BaseCurve.h"
#import <UIColor+Hex.h>

@interface BaseCurve ()

@property (nonatomic, assign, readwrite) NSInteger iD;
@property (nonatomic, strong, readwrite) NSDate *creationDate;
@property (nonatomic, strong, readwrite) UIColor *color;

@end

@implementation BaseCurve

- (instancetype)init {
    self = [super init];
    if (self) {
        _creationDate = [NSDate date];
        NSInteger hexColor = arc4random() % 0xFFFFFF;
        _color = [UIColor colorWithHex:hexColor];

    }
    return self;
}

- (instancetype)init:(UIColor *)color {
    self = [self init];
    if (self) {
        _color = color;
    }

    return self;
}

- (void)addPoint:(CGPoint)point{}
- (UIBezierPath *)bezierPath{  return [UIBezierPath bezierPath]; }
- (void)setupId:(NSInteger)iD { self.iD = iD; }
- (void)setupCreationDate:(NSDate *)date { self.creationDate = date;}

@end
