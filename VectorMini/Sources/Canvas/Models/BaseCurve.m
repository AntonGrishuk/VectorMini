//
//  BaseCurve.m
//  VectorMini
//
//  Created by Grishuk Anton on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "BaseCurve.h"

@interface BaseCurve ()

@property (nonatomic, assign) NSInteger iD;

@end

@implementation BaseCurve

- (void)addPoint:(CGPoint)point{}
- (void)addLastPoint:(CGPoint)point{}
- (void)constructPathFromPoints:(NSArray *)points{}
- (CGPathRef)newPath{return CGPathCreateMutable();}
- (NSArray *)getPoints{return nil;}
- (UIColor *)color{return nil;}

- (void)setupId:(NSUInteger)iD {
    self.iD = iD;
}

- (NSUInteger)getId {
    return self.iD;
}

@end
