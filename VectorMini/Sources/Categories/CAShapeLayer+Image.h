//
//  CAShapeLayer+Image.h
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAShapeLayer (Image)

- (UIImage *)imageWithBackground:(UIImage *)backgroundImage;

@end

NS_ASSUME_NONNULL_END
