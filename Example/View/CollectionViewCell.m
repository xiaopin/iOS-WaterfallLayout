//
//  CollectionViewCell.m
//  Example
//
//  Created by nhope on 2018/4/28.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0
                                           green:arc4random_uniform(256)/255.0
                                            blue:arc4random_uniform(256)/255.0
                                           alpha:1.0];
    
    _textLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_textLabel];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_textLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [_textLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
}

@end
