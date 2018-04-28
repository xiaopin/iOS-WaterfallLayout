//
//  CollectionReusableView.m
//  Example
//
//  Created by nhope on 2018/4/28.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0
                                               green:arc4random_uniform(256)/255.0
                                                blue:arc4random_uniform(256)/255.0
                                               alpha:1.0];
        _textLabel = [[UILabel alloc] init];
        [self addSubview:_textLabel];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_textLabel.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_textLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [_textLabel.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_textLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    }
    return self;
}

@end
