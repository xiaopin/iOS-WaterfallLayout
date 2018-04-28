//
//  SecondCollectionViewController.m
//  Example
//
//  Created by nhope on 2018/4/28.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "SecondCollectionViewController.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"
#import "XPCollectionViewWaterfallFlowLayout.h"

@interface SecondCollectionViewController ()

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSNumber *> *> *datas;

@end

@implementation SecondCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const headerReuseIdentifier = @"Header";
static NSString * const footerReuseIdentifier = @"Footer";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier];
    [self.collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseIdentifier];
    
    _datas = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        NSMutableArray<NSNumber *> *section = [NSMutableArray array];
        for (int j=0; j<10; j++) {
            CGFloat height = arc4random_uniform(100) + 30.0;
            [section addObject:@(height)];
        }
        [_datas addObject:section];
    }
    
    // 头部视图悬停
    XPCollectionViewWaterfallFlowLayout *layout = (XPCollectionViewWaterfallFlowLayout *)self.collectionView.collectionViewLayout;
    layout.sectionHeadersPinToVisibleBounds = YES;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = (kind==UICollectionElementKindSectionHeader) ? headerReuseIdentifier : footerReuseIdentifier;
    CollectionReusableView *view = (CollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    view.textLabel.text = [NSString stringWithFormat:@"%@ %ld", kind, indexPath.section];
    return view;
}

#pragma mark <XPCollectionViewWaterfallFlowLayoutDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout numberOfColumnInSection:(NSInteger)section {
    return  MIN(section+1, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout itemWidth:(CGFloat)width heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *number = self.datas[indexPath.section][indexPath.item];
    return [number floatValue];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout referenceHeightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout referenceHeightForFooterInSection:(NSInteger)section {
    return 40.0;
}

@end
