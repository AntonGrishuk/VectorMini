//
//  CurveListTableViewCell.h
//  VectorMini
//
//  Created by Anton Grishuk on 9/6/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCurve.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurveListTableViewCell : UITableViewCell

- (void)setupCurve:(BaseCurve *)curve;

@end

NS_ASSUME_NONNULL_END
