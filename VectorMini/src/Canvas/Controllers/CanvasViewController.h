//
//  CanvasViewController.h
//  TestCGContext
//
//  Created by Anton Grishuk on 9/1/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "CanvasModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface CanvasViewController : UIViewController

- (instancetype)initWithDrawObjects:(Project *)project;
- (void)selectTool:(ToolType)type;

@end



NS_ASSUME_NONNULL_END
