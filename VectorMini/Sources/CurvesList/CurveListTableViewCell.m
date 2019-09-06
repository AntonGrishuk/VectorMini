//
//  CurveListTableViewCell.m
//  VectorMini
//
//  Created by Anton Grishuk on 9/6/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "CurveListTableViewCell.h"
#import "Curve.h"
#import "Rectangle.h"

@interface CurveListTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation CurveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dateFormatter =  [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm:ss:SSS"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCurve:(BaseCurve *)curve {
    self.colorView.backgroundColor = [curve color];
    self.dateLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[curve getSecondsSinceUnixEpoch]]];
    
    if ([curve isKindOfClass:[Curve class]]) {
        self.nameLabel.text = @"Curve";
    } else if ([curve isKindOfClass:[Rectangle class]]) {
        self.nameLabel.text = @"Rectangle";
    }
}

@end
