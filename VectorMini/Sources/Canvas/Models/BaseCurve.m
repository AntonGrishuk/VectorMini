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
@property (nonatomic, assign) CGFloat unixDate;

@end

@implementation BaseCurve

- (void)addPoint:(CGPoint)point{}
- (void)addLastPoint:(CGPoint)point{}
- (void)constructPathFromPoints:(NSArray *)points{}
- (CGPathRef)newPath{return CGPathCreateMutable();}
- (NSArray *)getPoints{return nil;}
- (UIColor *)color{return nil;}

- (void)setupId:(NSInteger)iD {
    self.iD = iD;
}

- (NSInteger)getId {
    return self.iD;
}

- (CGFloat)getUnixDate {
    return self.unixDate;
}

- (void)setupUnixDate:(NSTimeInterval)date {
    self.unixDate = date;
}

- (NSTimeInterval)getSecondsSinceUnixEpoch {
    return self.unixDate;
}

@end
