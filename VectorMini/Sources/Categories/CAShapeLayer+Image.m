//
//  CAShapeLayer+Image.m
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CAShapeLayer+Image.h"

@implementation CAShapeLayer (Image)

- (UIImage *)imageWithBackground:(UIImage *)backgroundImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
    [backgroundImage drawInRect:CGRectApplyAffineTransform(self.frame, CGAffineTransformMakeScale(1, 1))];
    [self renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
