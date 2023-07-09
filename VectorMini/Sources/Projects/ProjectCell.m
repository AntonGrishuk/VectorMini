//
//  ProjectCell.m
//  VectorMini
//
//  Created by Anton Grishuk on 08.07.2023.
//  Copyright © 2023 Anton Grishuk. All rights reserved.
//

#import "ProjectCell.h"

@implementation ProjectCell

+ (NSString *)cellID {
    return  @"ProjectCell";
}

+ (void)setCellID:(NSString *)cellID { }

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
