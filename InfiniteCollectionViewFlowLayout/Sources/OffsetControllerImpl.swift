//
//  OffsetCalculator.swift
//  EndlessCollectionViewDemo
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

public class OffsetControllerImpl: OffsetController {
    private weak var layoutDataSource: LayoutAttributesProvider?
    private weak var collectionDataSource: CollectionViewDataProvider?
    
    private var visibleState = VisibleIndexesState()
    private let cache: LayoutAttributesCache
    
    private let insertAttributesFinder: InsertAttributesFinder
    private let deleteAttributesFinder: DeleteAttributesFinder
    private let reloadAttributesFinder: ReloadAttributesFinder
    
    public var scrollDirection: UICollectionView.ScrollDirection
    public var minimumLineSpacing: CGFloat
    public var minimumInteritemSpacing: CGFloat
    
    public var isLayoutAttributeEmpty: Bool {
        return cache.isEmpty
    }
    
    init(
        layoutDataSource: LayoutAttributesProvider,
        collectionDataSource: CollectionViewDataProvider?,
        minimumLineSpacing: CGFloat,
        minimumInteritemSpacing: CGFloat,
        scrollDirection: UICollectionView.ScrollDirection
    ) {
        self.layoutDataSource = layoutDataSource
        self.collectionDataSource = collectionDataSource
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.scrollDirection = scrollDirection
                
        let cache = LayoutAttributesCache()
        self.cache = cache
        
        self.insertAttributesFinder = InsertAttributesFinder(
            layoutDataSource: layoutDataSource,
            collectionDataSource: collectionDataSource,
            cachedLayoutAttributeProvider: cache
        )
        self.deleteAttributesFinder = DeleteAttributesFinder(
            layoutDataSource: layoutDataSource,
            collectionDataSource: collectionDataSource,
            cachedLayoutAttributeProvider: cache
        )
        self.reloadAttributesFinder = ReloadAttributesFinder(
            layoutDataSource: layoutDataSource,
            collectionDataSource: collectionDataSource,
            cachedLayoutAttributeProvider: cache
        )
    }
    
    public func refreshAttributes() {
        cache.cachedLayoutAttributes = getAllAttributes()
    }
    
    public func calculateOffsetDiff(for updates: [CollectionViewUpdateItem]) -> CGFloat {
        refreshVisibleState()
        
        let isInitialLoading: Bool = visibleState.bottom.row == -Int.max &&
            visibleState.top.row == Int.max
        guard !isInitialLoading else {
            return 0
        }
        
        var calculatedOffsetDiff: CGFloat = 0
        var inserted: [UICollectionViewLayoutAttributes] = []
        var deleted: [UICollectionViewLayoutAttributes] = []
        var beforeReloaded: [UICollectionViewLayoutAttributes] = []
        var afterReloaded: [UICollectionViewLayoutAttributes] = []
        for item in updates {
            switch item.updateAction {
            case .insert:
                let result = insertAttributesFinder.suitableLayoutAttributes(
                    item,
                    visibleState: visibleState
                )
                result.modifiedVisibleState.withWrapped({ visibleState = $0 })
                inserted.append(contentsOf: result.afterAttributes)
                result
                    .afterAttributes
                    .forEach { (attributes) in
                        cache.update(with: item, attributes: attributes)
                    }
            case .delete:
                let result = deleteAttributesFinder.suitableLayoutAttributes(
                    item,
                    visibleState: visibleState
                )
                deleted.append(contentsOf: result.beforeAttributes)
                result
                    .beforeAttributes
                    .forEach { (attributes) in
                        let afterDeleteAttributes = self.layoutDataSource?
                            .layoutAttributesForItem(at: attributes.indexPath)
                        cache.update(with: item, attributes: afterDeleteAttributes)
                    }
            case .reload:
                let result = reloadAttributesFinder.suitableLayoutAttributes(
                    item,
                    visibleState: visibleState
                )
                beforeReloaded.append(contentsOf: result.beforeAttributes)
                afterReloaded.append(contentsOf: result.afterAttributes)
                result
                    .afterAttributes
                    .forEach { (attributes) in
                        cache.update(with: item, attributes: attributes)
                    }
                break
            case .move, .none:
                break
            @unknown default:
                break
            }
        }
        
        let calculator = AttributesDiffCalculator(
            itemSpacing: itemSpacing,
            scrollDirection: scrollDirection
        )
                
        calculatedOffsetDiff += calculator.calculateDiff(from: inserted)
        
        calculatedOffsetDiff -= calculator.calculateDiff(from: deleted)
        
        calculatedOffsetDiff += calculator.calculateReloadDiff(
            beforeAttributes: beforeReloaded,
            afterAttributes: afterReloaded
        )
                        
        return calculatedOffsetDiff
    }
    
    private func getAllAttributes() -> [IndexPath: UICollectionViewLayoutAttributes] {
        guard let layoutDataSource = layoutDataSource,
              let collectionDataSource = self.collectionDataSource else { return [:] }
        
        var attributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
        let sections = collectionDataSource.numberOfSections
        for section in (0..<sections) {
            let numberOfRows = collectionDataSource
                .numberOfItems(inSection: section)
            for row in (0..<numberOfRows) {
                let indexPath = IndexPath(
                    row: row,
                    section: section
                )
                attributes[indexPath] = layoutDataSource
                    .layoutAttributesForItem(at: indexPath)
            }
        }
        return attributes
    }
    
    private func refreshVisibleState() {
        let indexPathsVisible = collectionDataSource?
            .indexPathsForVisibleItems
            .sorted(
                by: { ($0.section < $1.section) ||
                    ($0.section == $1.section && $0.row < $1.row)
                }
            ) ?? []
        if indexPathsVisible.count >= 2 {
            let last = indexPathsVisible[indexPathsVisible.count - 2]
            let first = indexPathsVisible[1]
            visibleState = VisibleIndexesState(
                bottom: last,
                top: first
            )
        } else {
            if let first = indexPathsVisible.first,
               let last = indexPathsVisible.last {
                visibleState = VisibleIndexesState(
                    bottom: last,
                    top: first
                )
            }
        }
    }
    
    private var itemSpacing: CGFloat {
        scrollDirection == .vertical ? minimumLineSpacing : minimumInteritemSpacing
    }
}

extension Dictionary where Key == IndexPath, Value == UICollectionViewLayoutAttributes {
    mutating func update(
        with item: CollectionViewUpdateItem,
        attributes: UICollectionViewLayoutAttributes?
    ) {
        switch item.updateAction {
        case .insert:
            if let indexPath = item.indexPathAfterUpdate {
                self[indexPath] = attributes
            }

        case .delete:
            if let indexPath = item.indexPathBeforeUpdate {
                self[indexPath] = attributes
            }
        case .reload:
            //TODO: support if different indexPathAfterUpdate and indexPathBeforeUpdate
            if let indexPath = item.indexPathAfterUpdate {
                self[indexPath] = attributes
            }
        case .move, .none:
            break
        @unknown default:
            break
        }
    }
}

