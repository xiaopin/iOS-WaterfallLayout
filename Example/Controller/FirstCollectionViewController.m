//
//  FirstCollectionViewController.m
//  Example
//
//  Created by nhope on 2018/4/28.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "FirstCollectionViewController.h"
#import "CollectionViewCell.h"
#import "XPCollectionViewWaterfallFlowLayout.h"

@interface FirstCollectionViewController ()<XPCollectionViewWaterfallFlowLayoutDataSource>

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSNumber *> *> *datas;

@end

@implementation FirstCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datas = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        NSMutableArray<NSNumber *> *section = [NSMutableArray array];
        for (int j=0; j<20; j++) {
            CGFloat height = arc4random_uniform(100) + 30.0;
            [section addObject:@(height)];
        }
        [_datas addObject:section];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.datas objectAtIndex:section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"{%ld,%ld}", indexPath.section, indexPath.item];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark <XPCollectionViewWaterfallFlowLayoutDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout numberOfColumnInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout itemWidth:(CGFloat)width heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *number = self.datas[indexPath.section][indexPath.item];
    return [number floatValue];
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10.0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 10.0;
//}

@end
