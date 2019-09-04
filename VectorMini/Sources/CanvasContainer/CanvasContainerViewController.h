//
//  CanvasContainerViewController.h
//  VectorMini
//
//  Created by Anton Grishuk on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

NS_ASSUME_NONNULL_BEGIN

@interface CanvasContainerViewController : UIViewController

- (void)setSelectedProject:(Project *)project;

@end

NS_ASSUME_NONNULL_END
