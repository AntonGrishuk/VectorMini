//
//  Project.m
//  VectorMini
//
//  Created by Anton Grishuk on 9/4/19.
//  Copyright © 2019 Anton Grishuk. All rights reserved.
//

#import "Project.h"

@interface Project ()
@property (nonatomic, assign, readwrite) NSInteger idNumber;
@property (nonatomic, strong, readwrite) NSString *name;

@end

@implementation Project

- (instancetype)init:(NSInteger)idNumber :(NSString *)name {
    self = [super init];
    if (self) {
        _idNumber = idNumber;
        _name = [name copy];
    }
    return self;
}


@end
