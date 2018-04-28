//
//  XPCollectionViewWaterfallFlowLayout.h
//  https://github.com/xiaopin/iOS-WaterfallLayout.git
//
//  Created by nhope on 2018/4/28.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPCollectionViewWaterfallFlowLayout;
@protocol XPCollectionViewWaterfallFlowLayoutDataSource;


#pragma mark -

@interface XPCollectionViewWaterfallFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) IBOutlet id<XPCollectionViewWaterfallFlowLayoutDataSource> dataSource;

@property (nonatomic, assign) CGFloat minimumLineSpacing; // default 0.0
@property (nonatomic, assign) CGFloat minimumInteritemSpacing; // default 0.0
@property (nonatomic, assign) IBInspectable BOOL sectionHeadersPinToVisibleBounds; // default NO
//@property (nonatomic, assign) IBInspectable BOOL sectionFootersPinToVisibleBounds;

@end


#pragma mark -

@protocol XPCollectionViewWaterfallFlowLayoutDataSource<NSObject>

@required
/// Return per section's column number(must be greater than 0).
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout numberOfColumnInSection:(NSInteger)section;
/// Return per item's height
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout itemWidth:(CGFloat)width
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/// Column spacing between columns
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
/// The spacing between rows and rows
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
///
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout insetForSectionAtIndex:(NSInteger)section;
/// Return per section header view height.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout referenceHeightForHeaderInSection:(NSInteger)section;
/// Return per section footer view height.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout referenceHeightForFooterInSection:(NSInteger)section;

@end
