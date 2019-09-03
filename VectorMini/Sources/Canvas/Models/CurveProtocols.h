//
//  CurveProtocols.h
//  Canvas
//
//  Created by Anton Grishuk on 9/2/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#ifndef CurveProtocols_h
#define CurveProtocols_h

@protocol CurveDelegate <NSObject>

- (void)curvePathDidChange:(CGPathRef)path;
- (void)curvePathDidFinished:(CGPathRef)path;

@end

@protocol CurveInterface <NSObject>

@property (nonatomic, weak) id<CurveDelegate> delegate;

- (void)addPoint:(CGPoint)point;
- (void)addLastPoint:(CGPoint)point;
- (void)constructPathFromPoints:(NSArray *)points;
- (CGPathRef)newPath;
- (NSArray *)getPoints;

@end


#endif /* CurveProtocols_h */
