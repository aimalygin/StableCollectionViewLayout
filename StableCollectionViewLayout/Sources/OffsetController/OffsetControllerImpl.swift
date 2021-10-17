//
//  OffsetCalculator.swift
//  StableCollectionViewLayout
//
//  Created by Anton Malygin on 28.03.2021.
//

import Foundation
import UIKit

public class OffsetControllerImpl: OffsetController {
    
    public var enableAutomaticContentOffsetAdjustment = true
    
    private weak var layoutDataSource: LayoutAttributesProvider?
    private weak var collectionDataSource: CollectionViewDataProvider?
    
    private let visibleStateController: VisibleIndexesStateController
        
    private var previousVisibleAttributes: [IndexPath: CGRect] = [:]
    private var offset: CGPoint?
    
    private var visibleState: VisibleIndexesState {
        visibleStateController.state
    }
    
    private var isInitialLoading: Bool {
        visibleState.bottomIndexPath.row == -Int.max &&
            visibleState.topIndexPath.row == Int.max
    }
    
    private var visibleStateIndexes: [IndexPath] {
        [visibleState.targetIndexPath,
         visibleState.topIndexPath,
         visibleState.bottomIndexPath
        ]
    }
    
    init(
        visibleStateController: VisibleIndexesStateController = VisibleIndexesStateControllerImpl(),
        layoutDataSource: LayoutAttributesProvider,
        collectionDataSource: CollectionViewDataProvider?
    ) {
        self.visibleStateController = visibleStateController
        self.layoutDataSource = layoutDataSource
        self.collectionDataSource = collectionDataSource
    }
    
    public func prepare(forCollectionViewUpdates updateItems: [CollectionViewUpdateItem]) {
        guard
            let collectionDataSource = collectionDataSource,
                enableAutomaticContentOffsetAdjustment else {
                return
        }
        
        let previousContentOffset = collectionDataSource.contentOffset
        let diff = offsetDifference(
            for: updateItems
        )
        guard diff.x != 0 || diff.y != 0 else {
            return
        }
        offset = CGPoint(
            x: previousContentOffset.x + diff.x,
            y: previousContentOffset.y + diff.y
        )
    }
    
    public func resetOffset() {
        offset = nil
    }
    
    public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let offset = offset else {
            return proposedContentOffset
        }
        return offset
    }
    
    public func refreshVisibleAttributes() {
        refreshVisibleState()
        
        guard let layoutDataSource = layoutDataSource else {
            return
        }
        let visibleCache = visibleStateIndexes
            .reduce(into: [IndexPath: CGRect](), { seed, indexPath in
                seed[indexPath] = layoutDataSource.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
            })
        previousVisibleAttributes = visibleCache
    }
    
    private func offsetDifference(for updates: [CollectionViewUpdateItem]) -> CGPoint {
        guard !isInitialLoading else {
            return .zero
        }
        
        let previousVisibleFrame = previousVisibleAttributes[visibleState.targetIndexPath] ?? .zero
        
        for item in updates {
            visibleStateController.update(with: item)
        }
        
        let newVisibleFrame = layoutDataSource?
            .layoutAttributesForItem(at: visibleState.targetIndexPath)?.frame ?? .zero
        let calculatedOffsetDiff = diff(
            from: previousVisibleFrame,
            new: newVisibleFrame
        )
        return calculatedOffsetDiff
    }
    
    private func refreshVisibleState() {
        guard let collectionDataSource = collectionDataSource else {
            return
        }
        visibleStateController.calculate(withIndexPathsForVisibleItems: collectionDataSource.indexPathsForVisibleItems)
    }
    
    private func diff(from previous: CGRect, new: CGRect) -> CGPoint {
        CGPoint(
            x: new.minX - previous.minX,
            y: new.minY - previous.minY
        )
    }
}
