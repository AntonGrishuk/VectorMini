//
//  DrawObject.m
//  VectorMini
//
//  Created by Anton Grishuk on 29.07.2023.
//  Copyright © 2023 Anton Grishuk. All rights reserved.
//

#import "DrawObject.h"

@implementation DrawObject

- (instancetype)initWithObjectId:(NSUUID *)objectId color:(CGColorRef)color {
    self = [super init];
    if (self) {
        self.objectId = objectId;
        self.color = color;
    }
    
    return self;
}

@end
