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

@protocol CurvesListTableViewControllerDelegate <NSObject>

- (void)didRemoveCurveFromCurvesList:(BaseCurve *)curve;

@end


@interface CurvesListTableViewController : UITableViewController

@property(weak, nonatomic) id<CurvesListTableViewControllerDelegate> delegate;

- (void)addCurves:(NSArray *)curves;
- (void)addCurve:(BaseCurve *)curve;
@end

NS_ASSUME_NONNULL_END
