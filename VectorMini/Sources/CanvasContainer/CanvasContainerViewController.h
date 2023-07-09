//
//  CanvasContainerViewController.h
//  VectorMini
//
//  Created by Anton Grishuk on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "DBController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CanvasContainerViewController : UIViewController
- (instancetype)initWithProject:(Project *)project dbController:(DBController *)dbController;
@end

NS_ASSUME_NONNULL_END
