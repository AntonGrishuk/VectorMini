//
//  CurvesListTableViewController.h
//  VectorMini
//
//  Created by Anton Grishuk on 9/5/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCurve.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurvesListTableViewController : UITableViewController
- (void)addCurves:(NSArray *)curves;
- (void)addCurve:(BaseCurve *)curve;
@end

NS_ASSUME_NONNULL_END
