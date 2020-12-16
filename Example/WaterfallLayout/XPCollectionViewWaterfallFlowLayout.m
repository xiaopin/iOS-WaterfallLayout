//
//  XPCollectionViewWaterfallFlowLayout.m
//  https://github.com/xiaopin/iOS-WaterfallLayout.git
//
//  Created by nhope on 2018/4/28.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPCollectionViewWaterfallFlowLayout.h"

@interface XPCollectionViewWaterfallFlowLayout ()

@property (nonatomic, strong) NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *itemLayoutAttributes;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *headerLayoutAttributes;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *footerLayoutAttributes;
/// Per section heights.
@property (nonatomic, strong) NSMutableArray<NSNumber *> *heightOfSections;
/// UICollectionView content height.
@property (nonatomic, assign) CGFloat contentHeight;

@end


@implementation XPCollectionViewWaterfallFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    NSAssert(self.dataSource != nil, @"XPCollectionViewWaterfallFlowLayout.dataSource cann't be nil.");
    if (self.collectionView.isDecelerating || self.collectionView.isDragging) {
        return;
    }
    
    _contentHeight = 0.0;
    _itemLayoutAttributes = [NSMutableArray array];
    _headerLayoutAttributes = [NSMutableArray array];
    _footerLayoutAttributes = [NSMutableArray array];
    _heightOfSections = [NSMutableArray array];
    
    UICollectionView *collectionView = self.collectionView;
    NSInteger const numberOfSections = collectionView.numberOfSections;
    UIEdgeInsets const contentInset = collectionView.contentInset;
    CGFloat const contentWidth = collectionView.bounds.size.width - contentInset.left - contentInset.right;
    
    for (NSInteger section=0; section < numberOfSections; section++) {
        NSInteger const columnOfSection = [self.dataSource collectionView:collectionView layout:self numberOfColumnInSection:section];
        NSAssert(columnOfSection > 0, @"[XPCollectionViewWaterfallFlowLayout collectionView:layout:numberOfColumnInSection:] must be greater than 0.");
        UIEdgeInsets const contentInsetOfSection = [self contentInsetForSection:section];
        CGFloat const minimumLineSpacing = [self minimumLineSpacingForSection:section];
        CGFloat const minimumInteritemSpacing = [self minimumInteritemSpacingForSection:section];
        CGFloat const contentWidthOfSection = contentWidth - contentInsetOfSection.left - contentInsetOfSection.right;
        CGFloat const itemWidth = (contentWidthOfSection-(columnOfSection-1)*minimumInteritemSpacing) / columnOfSection;
        NSInteger const numberOfItems = [collectionView numberOfItemsInSection:section];
        
        // Per section header
        CGFloat headerHeight = 0.0;
        if ([self.dataSource respondsToSelector:@selector(collectionView:layout:referenceHeightForHeaderInSection:)]) {
            headerHeight = [self.dataSource collectionView:collectionView layout:self referenceHeightForHeaderInSection:section];
            UICollectionViewLayoutAttributes *headerLayoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            headerLayoutAttribute.frame = CGRectMake(0.0, _contentHeight, contentWidth, headerHeight);
            [_headerLayoutAttributes addObject:headerLayoutAttribute];
        }
        
        // The current section's offset for per column.
        CGFloat offsetOfColumns[columnOfSection];
        for (NSInteger i=0; i<columnOfSection; i++) {
            offsetOfColumns[i] = headerHeight + contentInsetOfSection.top;
        }
        
        NSMutableArray *layoutAttributeOfSection = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (NSInteger item=0; item<numberOfItems; item++) {
            // Find minimum offset and fill to it.
            NSInteger currentColumn = 0;
            for (NSInteger i=1; i<columnOfSection; i++) {
                if (offsetOfColumns[currentColumn] > offsetOfColumns[i]) {
                    currentColumn = i;
                }
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGFloat itemHeight = [self.dataSource collectionView:collectionView layout:self itemWidth:itemWidth heightForItemAtIndexPath:indexPath];
            CGFloat x = contentInsetOfSection.left + itemWidth*currentColumn + minimumInteritemSpacing*currentColumn;
            CGFloat y = offsetOfColumns[currentColumn] + (item>=columnOfSection ? minimumLineSpacing : 0.0);
            
            UICollectionViewLayoutAttributes *layoutAttbiture = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            layoutAttbiture.frame = CGRectMake(x, y+_contentHeight, itemWidth, itemHeight);
            [layoutAttributeOfSection addObject:layoutAttbiture];
            
            // Update y offset in current column
            offsetOfColumns[currentColumn] = (y + itemHeight);
        }
        [_itemLayoutAttributes addObject:layoutAttributeOfSection];
        
        // Get current section height from offset record.
        CGFloat maxOffsetValue = offsetOfColumns[0];
        for (int i=1; i<columnOfSection; i++) {
            if (offsetOfColumns[i] > maxOffsetValue) {
                maxOffsetValue = offsetOfColumns[i];
            }
        }
        maxOffsetValue += contentInsetOfSection.bottom;
        
        // Per section footer
        CGFloat footerHeader = 0.0;
        if ([self.dataSource respondsToSelector:@selector(collectionView:layout:referenceHeightForFooterInSection:)]) {
            footerHeader = [self.dataSource collectionView:collectionView layout:self referenceHeightForFooterInSection:section];
            UICollectionViewLayoutAttributes *footerLayoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            footerLayoutAttribute.frame = CGRectMake(0.0, _contentHeight+maxOffsetValue, contentWidth, footerHeader);
            [_footerLayoutAttributes addObject:footerLayoutAttribute];
        }
        
        /**
         Update UICollectionView content height.
         Section height contain from the top of the headerView to the bottom of the footerView.
         */
        CGFloat currentSectionHeight = maxOffsetValue + footerHeader;
        [_heightOfSections addObject:@(currentSectionHeight)];
        
        _contentHeight += currentSectionHeight;
    }
}

- (CGSize)collectionViewContentSize {
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    CGFloat width = CGRectGetWidth(self.collectionView.bounds) - contentInset.left - contentInset.right;
    CGFloat height = MAX(CGRectGetHeight(self.collectionView.bounds), _contentHeight);
    return CGSizeMake(width, height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *result = [NSMutableArray array];
    [_itemLayoutAttributes enumerateObjectsUsingBlock:^(NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributeOfSection, NSUInteger idx, BOOL *stop) {
        [layoutAttributeOfSection enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop) {
            if (CGRectIntersectsRect(rect, attribute.frame)) {
                [result addObject:attribute];
            }
        }];
    }];
    [_headerLayoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop) {
        if (attribute.frame.size.height && CGRectIntersectsRect(rect, attribute.frame)) {
            [result addObject:attribute];
        }
    }];
    [_footerLayoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop) {
        if (attribute.frame.size.height && CGRectIntersectsRect(rect, attribute.frame)) {
            [result addObject:attribute];
        }
    }];
    
    // Header view hover.
    if (_sectionHeadersPinToVisibleBounds) {
        for (UICollectionViewLayoutAttributes *attriture in result) {
            if (![attriture.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) continue;
            NSInteger section = attriture.indexPath.section;
            UIEdgeInsets contentInsetOfSection = [self contentInsetForSection:section];
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes *itemAttribute = [self layoutAttributesForItemAtIndexPath:firstIndexPath];
            if (!itemAttribute) continue;
            CGFloat headerHeight = CGRectGetHeight(attriture.frame);
            CGRect frame = attriture.frame;
            frame.origin.y = MIN(
                                 MAX(self.collectionView.contentOffset.y, CGRectGetMinY(itemAttribute.frame)-headerHeight-contentInsetOfSection.top),
                                 CGRectGetMinY(itemAttribute.frame)+[_heightOfSections[section] floatValue]
                                 );
            attriture.frame = frame;
            attriture.zIndex = (NSIntegerMax/2)+section;
        }
    }
    
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_itemLayoutAttributes.count <= indexPath.section || _itemLayoutAttributes[indexPath.section].count <= indexPath.item) {
        return nil;
    }
    return _itemLayoutAttributes[indexPath.section][indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        for (UICollectionViewLayoutAttributes *attributes in _headerLayoutAttributes) {
            if (attributes.indexPath.section == indexPath.section) {
                return attributes;
            }
        }
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        for (UICollectionViewLayoutAttributes *attributes in _footerLayoutAttributes) {
            if (attributes.indexPath.section == indexPath.section) {
                return attributes;
            }
        }
    }
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (_sectionHeadersPinToVisibleBounds) {
        // 头部悬浮功能需要在滚动时实时计算布局(调用layoutAttributesForElementsInRect:方法)
        return YES;
    }
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

#pragma mark Private

- (UIEdgeInsets)contentInsetForSection:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if ([self.dataSource respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        edgeInsets = [self.dataSource collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return edgeInsets;
}

- (CGFloat)minimumLineSpacingForSection:(NSInteger)section {
    CGFloat minimumLineSpacing = self.minimumLineSpacing;
    if ([self.dataSource respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        minimumLineSpacing = [self.dataSource collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return minimumLineSpacing;
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section {
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    if ([self.dataSource respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        minimumInteritemSpacing = [self.dataSource collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return minimumInteritemSpacing;
}

@end
